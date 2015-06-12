//
//  InTweakPurchasePaypal.h
//  InTweakPurchase
//
//  Created by Mokhlas Hussein on 26/05/15.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Production (default): Normal, live environment. Real money gets moved.
/// This environment MUST be used for App Store submissions.
extern NSString *const PayPalEnvironmentProduction;
/// Sandbox: Uses the PayPal sandbox for transactions. Useful for development.
extern NSString *const PayPalEnvironmentSandbox;
/// NoNetwork: Mock mode. Does not submit transactions to PayPal. Fakes successful responses. Useful for unit tests.
extern NSString *const PayPalEnvironmentNoNetwork;

// get some keys to use while checking Parse Objects later
extern NSString *const PF_C_CLASS_NAME; // Class Name
extern NSString *const PF_C_IN_TWEAK_ID; // In Tweak ID (key)
extern NSString *const PF_C_TRANS_SECRET_STRING; // Secret means Secert ( for security propose only )
extern NSString *const PF_C_TRANS_UDID; // UDID (key)
extern NSString *const PF_C_TRANS_SERIAL; // SERAIL (key)
extern NSString *const PF_C_TRANS_ID; // Paypal Trans ID (key)
extern NSString *const PF_C_TRANS_STATE; // Paypal Trans STATE (key)
extern NSString *const PF_C_TRANS_DATE; // Paypal Trans DATE (key) // helps u to create limited time feature ;) FORMAT : 2015-06-11T17:29:09Z

UIKIT_EXTERN NSString *const IAProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAFailedProductPurchasedNotification;

UIKIT_EXTERN NSString *const IAProductPurchasedInfoSavedNotification;
UIKIT_EXTERN NSString *const IAProductPurchasedInfoFailedNotification;

// Block to check transaction later ;)
typedef void(^gotTransactionInfo)(NSDictionary *info, BOOL success);

@interface InTweakPurchasePaypal : NSObject

+ (InTweakPurchasePaypal *)sharedInTweak;

// checking transaction info
- (void)checkTransactionInfo:(NSString *)inTweakID transInfo:(gotTransactionInfo)callBack;
// setup your Parse IDs
- (void)setParseApplicationID:(NSString *)appID clientKey:(NSString *)clientKey launchingWithOptions:(NSDictionary *)launchOptions;

// setup your paypal IDs and your UserDefault ID ( PurchaseID )
- (void)initWithClienID:(NSString *)clientID secretID:(NSString *)secretID environment:(NSString *)envi andPurchaseID:(NSString *)purchaseID;
// create payment item
- (void)presentPaypalViewControllerFromViewController:(UIViewController *)viewController WithItemName:(NSString *)itemName inTweakID:(NSString *)inTweak Description:(NSString *)desc Quantity:(NSInteger)integer Price:(NSString *)price Currency:(NSString *)currency SKU:(NSString *)sku;
@end
