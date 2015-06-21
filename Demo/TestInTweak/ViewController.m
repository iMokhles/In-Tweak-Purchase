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
    
    [[InTweakPurchasePaypal sharedInTweak] checkTransactionInfo:@"com.imokhles.testInTweak-1" transInfo:^(NSDictionary *info, BOOL success) {
        if (success) {
            NSLog(@"******* %@", info);
        } else {
            NSLog(@"ERROOOORR 23123");
        }
    }];
    
    [[InTweakPurchasePaypal sharedInTweak] initWithClienID:@"ATjwXhi0mlUsH0sgA6gZXNgM7CEdUGVLaBW2djhKe3bEZdEyR-LxaJmtOMyrPoJfSK7gvpcAE5PR_J7m" secretID:@"EPSUNxEX7Yrsc1t6PH_nrF_JKCdCst8EyhYQkDlSKXVSjWUXNMwhP5ol2LDC4pLvfT2b6unUSoFj7qZ2" environment:PayPalEnvironmentNoNetwork andPurchaseID:@"TestIT"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAFailedProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedInfoSavedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPurchaseNotification:) name:IAProductPurchasedInfoFailedNotification object:nil];
    
}

- (void)testPurchaseNotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:IAProductPurchasedNotification]) {
        [self.label setText:@"Purchased Already"];
    } else if ([notification.name isEqualToString:IAFailedProductPurchasedNotification]) {
        [self.label setText:@"Purchased failed"];
    } else if ([notification.name isEqualToString:IAProductPurchasedInfoSavedNotification]) {
        [self.label setText:@"Saved"];
    } else if ([notification.name isEqualToString:IAProductPurchasedInfoFailedNotification]) {
        [self.label setText:@"Save failed"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"TEEEEEST");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testPurchase:(id)sender {
    
    [[InTweakPurchasePaypal sharedInTweak] presentPaypalViewControllerFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController WithItemName:@"Test Item  1" andItemDataIfNedded:UIImagePNGRepresentation([UIImage imageNamed:@"whiteBG.jpg"]) inTweakID:@"com.imokhles.testInTweak-1" Description:@"This is ok" Quantity:1 Price:@"0.99" Currency:@"USD" SKU:@"876589"];
}

- (IBAction)restorePurchases:(id)sender {
    [[InTweakPurchasePaypal sharedInTweak] getParseFileObjectWithBlock:^(NSData *objectData) {
        //
        [self.imageView setImage:[UIImage imageWithData:objectData]];
    } progressBlock:^(NSUInteger percentDone) {
        //
        self.progressView.progress = percentDone;
    }];
//    [[InTweakPurchasePaypal sharedInTweak] restorePurchasesForTransaction:@"NONETWORKPAYIDEXAMPLE123" transInfo:^(BOOL success) {
//        if (success) {
//            NSLog(@"******* ");
//        } else {
//            NSLog(@"ERROOOORR");
//        }
//    }];
}
@end
