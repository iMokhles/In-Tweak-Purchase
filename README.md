# In-Tweak Purchase

* in-tweak purchase system works with Paypal-SDK and ParseSDK.
* this doesn't use any Private API all of the APIs used are Public.
* You can use it within any iOS application

**Installation**

**Link against those frameworks:**

<img src="https://raw.github.com/iMokhles/In-Tweak-Purchase/master/screenshots/Frameworks.png">

**Other Linker Flags:**

* -ObjC

**How to integrate**

```objective-c
#import <InTweakPurchase/InTweakPurchase.h>

// Configure your Parse Account

// inside your AppDelegate 
// you can use launchingWithOptions if u called it inside AppDelegate to track your device
// if you caleld it from another place you can put launchingWithOptions as nil

[[InTweakPurchasePaypal sharedInTweak] setParseApplicationID:@"PARSE_APP_ID" clientKey:@"PARSE_CLIENT_ID" launchingWithOptions:nil];

// Configure your Paypal Account

// Paypal Environments can be found inside InTweakPurchasePaypal.h
// USER_DEFAULT_ID is an NSUserDefaults key to save it after complete the purchase
[[InTweakPurchasePaypal sharedInTweak] initWithClienID:@"PAYPAL_CLIENT_ID" secretID:@"PAYPAL_CLIENT_ID" environment:PayPal_Environment andPurchaseID:USER_DEFAULT_ID];

// Configure your purchase item

// ex: ITEM_NAME = @"Remove Ads"
// ex: ITEM_ID = @"com.imokhles.testtweak-removeads"
// ex: ITEM_DESCRIPTION = @"purchase this item to remove ads"
// ex: PRICE = @"0.99"
// ex: ITEM_SKU = @"RMV-353553"

[[InTweakPurchasePaypal sharedInTweak] presentPaypalViewControllerFromViewController:self WithItemName:@"ITEM_NAME" inTweakID:@"ITEM_ID" Description:@"ITEM_DESCRIPTION" Quantity:1 Price:@"PRICE" Currency:@"USD" SKU:@"ITEM_SKU"];


```
**Get Payments Notifications**

```objective-c

// Gettings payments Notifications
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAFailedProductPurchasedNotification object:nil];

// Gettings save payments information Notifications
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedInfoSavedNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedInfoFailedNotification object:nil];


- (void)testPurchaseNotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:IAProductPurchasedNotification]) {
        //Purchased Done
    } else if ([notification.name isEqualToString:IAFailedProductPurchasedNotification]) {
        //Purchased Failed
    } else if ([notification.name isEqualToString:IAProductPurchasedInfoSavedNotification]) {
        //Purchased Info Saved Done
    } else if ([notification.name isEqualToString:IAProductPurchasedInfoFailedNotification]) {
        //Purchased Info Failed To Save
    }
}


```

#### Contacts

If you have improvements or concerns, feel free to post [an issue](https://github.com/iMokhles/In-Tweak-Purchase/issues) and write details.

[Check out](https://github.com/iMokhles) all iMokhles's GitHub projects.
[Email us](mailto:mokhleshussien@aol.com?subject=From%20GitHub%20InTweakPurchase) with other ideas and projects.