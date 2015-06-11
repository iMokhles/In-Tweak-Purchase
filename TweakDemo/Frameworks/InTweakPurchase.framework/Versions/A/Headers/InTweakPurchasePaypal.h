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

UIKIT_EXTERN NSString *const IAProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAFailedProductPurchasedNotification;

UIKIT_EXTERN NSString *const IAProductPurchasedInfoSavedNotification;
UIKIT_EXTERN NSString *const IAProductPurchasedInfoFailedNotification;

@interface InTweakPurchasePaypal : NSObject

+ (InTweakPurchasePaypal *)sharedInTweak;

// setup your Parse IDs
- (void)setParseApplicationID:(NSString *)appID clientKey:(NSString *)clientKey launchingWithOptions:(NSDictionary *)launchOptions;

// setup your paypal IDs and your UserDefault ID ( PurchaseID )
- (void)initWithClienID:(NSString *)clientID secretID:(NSString *)secretID environment:(NSString *)envi andPurchaseID:(NSString *)purchaseID;
// create payment item
- (void)presentPaypalViewControllerFromViewController:(UIViewController *)viewController WithItemName:(NSString *)itemName inTweakID:(NSString *)inTweak Description:(NSString *)desc Quantity:(NSInteger)integer Price:(NSString *)price Currency:(NSString *)currency SKU:(NSString *)sku;
@end
