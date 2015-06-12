//
//  InTweakPurchasePaypal.m
//  InTweakPurchase
//
//  Created by Mokhlas Hussein on 26/05/15.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "InTweakPurchasePaypal.h"
#import "PayPalMobile.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentProduction

NSString *const IAProductPurchasedNotification = @"IAProductPurchasedNotification";
NSString *const IAFailedProductPurchasedNotification = @"IAFailedProductPurchasedNotification";

NSString *const IAProductPurchasedInfoSavedNotification = @"IAProductPurchasedInfoSavedNotification";
NSString *const IAProductPurchasedInfoFailedNotification = @"IAProductPurchasedInfoFailedNotification";

NSString *const kInTweakPurchaseErrorDomain = @"InTwekPurchaseErrorDomain";

OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;


NSString *const PF_C_CLASS_NAME = @"TWEAK_CLASS_NAME";
NSString *const PF_C_IN_TWEAK_ID = @"In_Tweak_ID";
NSString *const PF_C_TRANS_UDID = @"device_udid";
NSString *const PF_C_TRANS_SERIAL = @"device_serial";
NSString *const PF_C_TRANS_SECRET_STRING = @"device_secret_string";
NSString *const PF_C_TRANS_ID = @"trans_id";
NSString *const PF_C_TRANS_STATE = @"trans_state";
NSString *const PF_C_TRANS_DATE = @"trans_create_time";

static NSString *hatHazaElRakam(UIDevice *device) {
    return (__bridge NSString *)MGCopyAnswer(CFSTR("UniqueDeviceID"));
}

static NSString *hatHazaElRakamS(UIDevice *device) {
    return (__bridge NSString *)MGCopyAnswer(CFSTR("SerialNumber"));
}

@interface NSString (InTweakPurchase)

- (NSString *)rebuildString;

@end

@implementation NSString (InTweakPurchase)

- (NSString *)rebuildString {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end

static NSString *getSecretStringFrom(NSString *sec1, NSString *sec2) {
    
    NSString *secretString = [NSString stringWithFormat:@"%@%@", sec1, sec2];
    return [secretString rebuildString];
}
@interface InTweakPurchasePaypal () <PayPalPaymentDelegate>
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property (nonatomic, strong) NSString *purchID;
@property (nonatomic, strong) NSString *inTweakID;
@end

@implementation InTweakPurchasePaypal
+ (InTweakPurchasePaypal *)sharedInTweak {
    static id shared = nil;
    if (shared == nil) {
        shared = [[self alloc] init];
    }
    
    return shared;
}

- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)initWithClienID:(NSString *)clientID secretID:(NSString *)secretID environment:(NSString *)envi andPurchaseID:(NSString *)purchaseID {
        _purchID = purchaseID;
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : clientID,
                                                               PayPalEnvironmentSandbox : secretID}];
        // Set up payPalConfig
        _payPalConfig = [[PayPalConfiguration alloc] init];
        _payPalConfig.acceptCreditCards = NO;
        _payPalConfig.merchantName = @"InTweak Purchase.";
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
        [PayPalMobile preconnectWithEnvironment:envi];
}

// create parse
- (void)setParseApplicationID:(NSString *)appID clientKey:(NSString *)clientKey launchingWithOptions:(NSDictionary *)launchOptions{
    [Parse enableLocalDatastore];
    // Initialize Parse.
    [Parse setApplicationId:appID
                  clientKey:clientKey];
    
    if (launchOptions) {
        [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    }
}
// create payment item
- (void)presentPaypalViewControllerFromViewController:(UIViewController *)viewController WithItemName:(NSString *)itemName inTweakID:(NSString *)inTweak Description:(NSString *)desc Quantity:(NSInteger)integer Price:(NSString *)price Currency:(NSString *)currency SKU:(NSString *)sku {
    
    self.inTweakID = inTweak;
    
    PayPalItem *item1 = [PayPalItem itemWithName:itemName
                                    withQuantity:integer
                                       withPrice:[NSDecimalNumber decimalNumberWithString:price]
                                    withCurrency:currency
                                         withSku:sku];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:nil
                                                                                    withTax:nil];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = subtotal;
    payment.currencyCode = currency;
    payment.shortDescription = desc;
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *UniqueID_ = hatHazaElRakam(device);
    NSString *UniqueID_S = hatHazaElRakamS(device);
    
    PFQuery *query = [PFQuery queryWithClassName:PF_C_CLASS_NAME];
    //    [query whereKey:PF_C_TRANS_SERIAL equalTo:UniqueID_S];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0) {
                [viewController presentViewController:paymentViewController animated:YES completion:nil];
            } else {
                for (PFObject *object in objects) {
                    if ([[object objectForKey:PF_C_TRANS_STATE] isEqualToString:@"approved"] && [[object objectForKey:PF_C_TRANS_SERIAL] isEqualToString:UniqueID_S] && [[object objectForKey:PF_C_IN_TWEAK_ID] isEqualToString:inTweak] && [[object objectForKey:PF_C_TRANS_SECRET_STRING] isEqualToString:getSecretStringFrom(UniqueID_, UniqueID_S)]) {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_purchID];
                        [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedNotification object:nil];
                    } else {
                        [viewController presentViewController:paymentViewController animated:YES completion:nil];
                    }
                }
            }
        } else {
            NSLog(@"[InTweakPurchase] ERROR: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    
    // Dismiss the PayPalPaymentViewController.
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        //
        NSString *transID = [[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"id"];
        NSString *stateID = [[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"state"];
        NSString *ctimeID = [[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"create_time"];
        UIDevice *device = [UIDevice currentDevice];
        NSString *UniqueID_ = hatHazaElRakam(device);
        NSString *UniqueID_S = hatHazaElRakamS(device);
        
        
        PFQuery *query = [PFQuery queryWithClassName:PF_C_CLASS_NAME];
        //    [query whereKey:PF_C_TRANS_SERIAL equalTo:UniqueID_S];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count] == 0) {
                    PFObject *userData = [PFObject objectWithClassName:PF_C_CLASS_NAME];
                    userData[PF_C_TRANS_ID] = transID;
                    userData[PF_C_TRANS_DATE] = ctimeID;
                    userData[PF_C_TRANS_STATE] = stateID;
                    userData[PF_C_IN_TWEAK_ID] = self.inTweakID;
                    
                    userData[PF_C_TRANS_UDID] = UniqueID_;
                    userData[PF_C_TRANS_SERIAL] = UniqueID_S;
                    userData[PF_C_TRANS_SECRET_STRING] = getSecretStringFrom(UniqueID_, UniqueID_S);
                    
                    if ([stateID isEqualToString:@"approved"]) {
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_purchID];
                        [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedNotification object:nil];
                        [userData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                // The object has been saved.
                                [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedInfoSavedNotification object:nil];
                                
                            } else {
                                // There was a problem, check error.description
                                [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedInfoFailedNotification object:nil];
                                
                            }
                        }];
                    } else {
                        NSLog(@"Something Wrong");
                        [[NSNotificationCenter defaultCenter] postNotificationName:IAFailedProductPurchasedNotification object:nil];
                    }
                } else {
                    for (PFObject *object in objects) {
                        if (![[object objectForKey:PF_C_TRANS_SERIAL] isEqualToString:UniqueID_S]) {
                            PFObject *userData = [PFObject objectWithClassName:PF_C_CLASS_NAME];
                            userData[PF_C_TRANS_ID] = transID;
                            userData[PF_C_TRANS_DATE] = ctimeID;
                            userData[PF_C_TRANS_STATE] = stateID;
                            userData[PF_C_IN_TWEAK_ID] = self.inTweakID;
                            
                            userData[PF_C_TRANS_UDID] = UniqueID_;
                            userData[PF_C_TRANS_SERIAL] = UniqueID_S;
                            userData[PF_C_TRANS_SECRET_STRING] = getSecretStringFrom(UniqueID_, UniqueID_S);
                            
                            if ([stateID isEqualToString:@"approved"]) {
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:_purchID];
                                [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedNotification object:nil];
                                [userData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        // The object has been saved.
                                        [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedInfoSavedNotification object:nil];
                                        
                                    } else {
                                        // There was a problem, check error.description
                                        [[NSNotificationCenter defaultCenter] postNotificationName:IAProductPurchasedInfoFailedNotification object:nil];
                                        
                                    }
                                }];
                            } else {
                                NSLog(@"Something Wrong");
                                [[NSNotificationCenter defaultCenter] postNotificationName:IAFailedProductPurchasedNotification object:nil];
                            }
                        } else {
                            return;
                        }
                    }
                }
            } else {
                NSLog(@"[InTweakPurchase] ERROR: %@", error.localizedDescription);
            }
        }];

    }];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        //
        
    }];
}

- (NSDictionary *)indexKeyedDictionaryFromArray:(NSArray *)array
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [array enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         NSNumber *index = [NSNumber numberWithInteger:idx];
         [mutableDictionary setObject:obj forKey:index];
     }];
    NSDictionary *result = [NSDictionary.alloc initWithDictionary:mutableDictionary];
    return result;
}

- (void)checkTransactionInfo:(NSString *)inTweakID transInfo:(gotTransactionInfo)callBack {
    UIDevice *device = [UIDevice currentDevice];
    NSString *UniqueID_ = hatHazaElRakam(device);
    NSString *UniqueID_S = hatHazaElRakamS(device);
    
    PFQuery *query = [PFQuery queryWithClassName:PF_C_CLASS_NAME];
    [query whereKey:PF_C_IN_TWEAK_ID containsString:inTweakID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0) {
                callBack(nil, NO);
            } else {
                for (PFObject *object in objects) {
                    if (object) {
                        if ([[object objectForKey:PF_C_TRANS_STATE] isEqualToString:@"approved"] && [[object objectForKey:PF_C_TRANS_SERIAL] isEqualToString:UniqueID_S] && [[object objectForKey:PF_C_IN_TWEAK_ID] isEqualToString:inTweakID] && [[object objectForKey:PF_C_TRANS_SECRET_STRING] isEqualToString:getSecretStringFrom(UniqueID_, UniqueID_S)]) {
                            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
                            
                            [mutableDictionary setObject:[object objectForKey:PF_C_TRANS_STATE] forKey:PF_C_TRANS_STATE];
                            [mutableDictionary setObject:[object objectForKey:PF_C_TRANS_SECRET_STRING] forKey:PF_C_TRANS_SECRET_STRING];
                            [mutableDictionary setObject:[object objectForKey:PF_C_TRANS_DATE] forKey:PF_C_TRANS_DATE];
                            [mutableDictionary setObject:[object objectForKey:PF_C_TRANS_ID] forKey:PF_C_TRANS_ID];
                            
                            NSDictionary *transInfoDict = [NSDictionary.alloc initWithDictionary:mutableDictionary];
                            
                            callBack(transInfoDict, YES);
                        } else {
                            callBack(nil, NO);
                        }
                    }
                }
            }
        } else {
            NSLog(@"[InTweakPurchase] ERROR: %@", error.localizedDescription);
            callBack(nil, NO);
        }
        
    }];
}
@end
