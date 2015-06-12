//
//  ViewController.h
//  TestInTweak
//
//  Created by Mokhlas Hussein on 10/06/15.
//  Copyright (c) 2015 Mokhlas Hussein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InTweakPurchase/InTweakPurchase.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)testPurchase:(id)sender;
- (IBAction)restorePurchases:(id)sender;


@end

