#import <InTweakPurchase/InTweakPurchase.h>

@interface WAChatListViewController : UITableViewController
@end

%hook WhatsAppAppDelegate
- (_Bool)application:(id)arg1 reallyDidFinishLaunchingWithOptions:(NSDictionary *)arg2 {
    [[InTweakPurchasePaypal sharedInTweak] setParseApplicationID:@"zcXyCI0r2vFVJU5kOiKPClvI8GGoBLLvxcGcvo3u" clientKey:@"VzBXlUnPWhFjV5LtUsgV5FmmQmTWi3LYizIEPatq" launchingWithOptions:arg2];

    [[InTweakPurchasePaypal sharedInTweak] checkTransactionInfo:@"com.imokhles.testInTweak-1" transInfo:^(NSDictionary *info, BOOL success) {
    
    /*
    Info - Output ******* {
        "device_secret_string" = BE51C5D3F7063C1057E0776459893;
        "trans_create_time" = "2015-06-11T19:44:32Z";
        "trans_id" = "PAY-NONETWORKPDEXAMPLE123";
        "trans_state" = approved;
        }
    */
        [[NSUserDefaults standardUserDefaults] setBool:success forKey:@"TestIT"];
        [self performSelectorOnMainThread:@selector(testPurchaseNotification:) withObject:nil waitUntilDone:YES];
    }];
    return %orig;
}
%end

%hook WAChatListViewController
- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAFailedProductPurchasedNotification object:nil];
    %orig;
}

%new
- (void)testPurchaseNotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:IAProductPurchasedNotification]) {
        
    } else if ([notification.name isEqualToString:IAFailedProductPurchasedNotification]) {
        
    }
}
- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    [[InTweakPurchasePaypal sharedInTweak] initWithClienID:@"ATjwXhi0mlUsH0sgA6gZXNgM7CEdUGVLaBW2djhKe3bEZdEyR-LxaJmtOMyrPoJfSK7gvpcAE5PR_J7m" secretID:@"EPSUNxEX7Yrsc1t6PH_nrF_JKCdCst8EyhYQkDlSKXVSjWUXNMwhP5ol2LDC4pLvfT2b6unUSoFj7qZ2" environment:PayPalEnvironmentNoNetwork andPurchaseID:@"TestIT"];
    %orig;
}
// i can create anywhere button to handle this action ( but this is a simple test ;) )
%new
- (void)testPurchase:(id)sender {
    
    [[InTweakPurchasePaypal sharedInTweak] presentPaypalViewControllerFromViewController:self WithItemName:@"Test Item  1" inTweakID:@"com.imokhles.testInTweak-1" Description:@"Tis is a test description" Quantity:1 Price:@"1.00" Currency:@"USD" SKU:@"876589"];
    
}
%end

