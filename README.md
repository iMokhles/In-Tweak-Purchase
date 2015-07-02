# In-Tweak Purchase

![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg?style=flat)
![Level](https://img.shields.io/badge/Language-Objective--C-blue.svg)
![License](https://img.shields.io/badge/License-GPL%20V3-blue.svg?style=flat)

* in-tweak purchase system works with [Paypal-iOS-SDK](https://github.com/paypal/PayPal-iOS-SDK) and [ParseSDK](https://www.parse.com).
* ~~this doesn't use any Private API all of the APIs used are Public.~~ it uses Private API to get UDID and Serial, next step is to get an Unique identifier of each device, to secure your payments
* ~~You can use it within any iOS application~~

* Works fine with tweaks

**Tweak Demo**

![DemoVideo](https://github.com/iMokhles/In-Tweak-Purchase/raw/master/screenshots/DemoVideo.gif)

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

[[InTweakPurchasePaypal sharedInTweak] setParseApplicationID:@"PARSE_APP_ID" clientKey:@"PARSE_CLIENT_ID" className:@"CLASS_NAME" devicesLimit:2 launchingWithOptions:nil];

// Configure your Paypal Account

// Paypal Environments can be found inside InTweakPurchasePaypal.h
// USER_DEFAULT_ID is an NSUserDefaults key to save it after complete the purchase
[[InTweakPurchasePaypal sharedInTweak] initWithClienID:@"PAYPAL_CLIENT_ID" clientIDSandbox:@"PAYPAL_SANDBOX_CLIENT_ID" environment:PayPal_Environment andPurchaseID:@"USER_DEFAULT_ID"];

// Configure your purchase item

// ex: ITEM_NAME = @"Remove Ads"
// ex: ITEM DATA = an zip file contents dylib, zip-file, Image, music to be uploaded (if the purchase done) (just accept one file till now)
// ex: ITEM_ID = @"com.imokhles.testtweak-removeads"
// ex: ITEM_DESCRIPTION = @"purchase this item to remove ads"
// ex: PRICE = @"0.99"
// ex: ITEM_SKU = @"RMV-353553"

[[InTweakPurchasePaypal sharedInTweak] presentPaypalViewControllerFromViewController:self WithItemName:@"ITEM_NAME" andItemDataIfNedded:NSDATA_OF_ITEM inTweakID:@"ITEM_ID" Description:@"ITEM_DESCRIPTION" Quantity:1 Price:@"PRICE" Currency:@"USD" SKU:@"ITEM_SKU"];

// Checking purchase 

// u can use it as u want
[[InTweakPurchasePaypal sharedInTweak] checkTransactionInfo:@"com.imokhles.testInTweak-1" transInfo:^(NSDictionary *info, BOOL success) {
    
    /*
    Info - Output ******* {
        "device_secret_string" = BE51C5D3F7063C1057E0776459893;
        "file_object" = "<PFFile: 0x7fd3abf47740>"; // use it if u want, if not just use the getParseFileObjectWithBlock methode 
        "trans_create_time" = "2015-06-11T19:44:32Z";
        "trans_id" = "PAY-NONETWORKPDEXAMPLE123";
        "trans_state" = approved;
        }
    */
    [[NSUserDefaults standardUserDefaults] setBool:success forKey:@"USER_DEFAULT_ID"];
    [self performSelectorOnMainThread:@selector(testPurchaseNotification:) withObject:nil waitUntilDone:YES];
}];

// if there are an error u will find it easily
// ex: 2015-06-12 12:41:10.179 TestInTweak[26062:5042354] [InTweakPurchase] ERROR: The Internet connection appears to be offline.


// Restoring purchase 

// to restore purchases just ask the user about his Paypal Transacion ID
// then the framework will check everything for u
// it it will return NO, if the user reached the devices limit ( with a notification )
[[InTweakPurchasePaypal sharedInTweak] restorePurchasesForTransaction:@"PAYPAL_TRANS_ID" transInfo:^(BOOL success) {
        if (success) {
            NSLog(@"Purchased Already");
        } else {
            NSLog(@"Ops somthing goes wrong with your TRANSACTION ID");
        }
}];

// Getting file data

// if u have uploaded data when you configurated your purchase item
// you can retrive it easily from here
[[InTweakPurchasePaypal sharedInTweak] getParseFileObjectWithBlock:^(NSData *objectData) {
    // get data
    [self.imageView setImage:[UIImage imageWithData:objectData]];
} progressBlock:^(NSUInteger percentDone) {
    // get the progress value
    self.progressView.progress = percentDone;
}];

```
**Get Payments Notifications**

```objective-c

// Gettings payments Notifications
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAFailedProductPurchasedNotification object:nil];

// Gettings save payments information Notifications
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedInfoSavedNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedInfoFailedNotification object:nil];

// Gettings Devices limit reached notification
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IADevicesLimitFailedNotification object:nil];

- (void)testPurchaseNotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:IAProductPurchasedNotification]) {
        //Purchased Done
    } else if ([notification.name isEqualToString:IAFailedProductPurchasedNotification]) {
        //Purchased Failed
    } else if ([notification.name isEqualToString:IAProductPurchasedInfoSavedNotification]) {
        //Purchased Info Saved Done
    } else if ([notification.name isEqualToString:IAProductPurchasedInfoFailedNotification]) {
        //Purchased Info Failed To Save
    } else if ([notification.name isEqualToString:IADevicesLimitFailedNotification]) {
        // Reached devices limit
    }
}


```

**Notes**

* ~~i think it will be available in Cydia as Hidden package, so~~
* ~~don't forget to depend it in your control file com.imokhles.InTweakPurchase~~

#### Contacts

If you have improvements or concerns, feel free to post [an issue](https://github.com/iMokhles/In-Tweak-Purchase/issues) and write details.

[Check out](https://github.com/iMokhles) all iMokhles's GitHub projects.
[Email us](mailto:mokhleshussien@aol.com?subject=From%20GitHub%20InTweakPurchase) with other ideas and projects.