//
//  ViewController.m
//  TestInTweak
//
//  Created by Mokhlas Hussein on 10/06/15.
//  Copyright (c) 2015 Mokhlas Hussein. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAFailedProductPurchasedNotification object:nil];
}

- (void)testPurchaseNotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:IAProductPurchasedNotification]) {
        [self.label setText:@"Purchased Already"];
    } else if ([notification.name isEqualToString:IAFailedProductPurchasedNotification]) {
        [self.label setText:@"Purchased failed"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[InTweakPurchasePaypal sharedInTweak] initWithClienID:@"ATjwXhi0mlUsH0sgA6gZXNgM7CEdUGVLaBW2djhKe3bEZdEyR-LxaJmtOMyrPoJfSK7gvpcAE5PR_J7m" secretID:@"EPSUNxEX7Yrsc1t6PH_nrF_JKCdCst8EyhYQkDlSKXVSjWUXNMwhP5ol2LDC4pLvfT2b6unUSoFj7qZ2" environment:PayPalEnvironmentNoNetwork andPurchaseID:@"TestIT"];
    
    [[InTweakPurchasePaypal sharedInTweak] checkTransactionInfo:@"com.imokhles.testInTweak-1" transInfo:^(NSDictionary *info, BOOL success) {
        if (success) {
            NSLog(@"******* %@", info);
            NSLog(@"! %@", [info objectForKey:PF_C_TRANS_DATE]);
            NSLog(@"! %@", [info objectForKey:PF_C_TRANS_ID]);
            
        } else {
            NSLog(@"ERROOOORR");
        }
    }];
    NSLog(@"TEEEEEST");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testPurchase:(id)sender {
    
    [[InTweakPurchasePaypal sharedInTweak] presentPaypalViewControllerFromViewController:self WithItemName:@"Test Item  1" inTweakID:@"com.imokhles.testInTweak-1" Description:@"Tis is a test description" Quantity:1 Price:@"1.00" Currency:@"USD" SKU:@"876589"];
    
}
@end
