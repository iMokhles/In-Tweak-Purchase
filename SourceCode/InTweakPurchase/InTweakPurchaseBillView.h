//
//  InTweakPurchaseBillView.h
//  InTweakPurchase
//
//  Created by Mokhlas Hussein on 02/07/15.
//  Copyright (c) 2015 Mokhlas Hussein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InTweakPurchaseBillView : UIView
- (void)transactionWithItemName:(NSString *)itemName state:(NSString *)transStat purchaseDate:(NSString *)dateString andPaymentID:(NSString *)payID;
- (void)showBill;
- (void)hideBill;
@end
