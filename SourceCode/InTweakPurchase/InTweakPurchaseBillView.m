//
//  InTweakPurchaseBillView.m
//  InTweakPurchase
//
//  Created by Mokhlas Hussein on 02/07/15.
//  Copyright (c) 2015 Mokhlas Hussein. All rights reserved.
//

#import "InTweakPurchaseBillView.h"
#import "KLCPopup.h"

@interface UIView (intweak_screenshot)
- (UIImage *)screenshot;
@end

@implementation UIView (intweak_screenshot)
-(UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, [UIScreen mainScreen].bounds.size.height), NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@interface UILabel (Html)
- (void)setHtml:(NSString*) html;
@end

@implementation UILabel (Html)

- (void)setHtml:(NSString*)html
{
    NSError *err = nil;
    self.attributedText =
    [[NSAttributedString alloc]
     initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
}

- (void) boldRange: (NSRange) range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    
    self.attributedText = attributedText;
}

- (void) boldSubstring: (NSString*) substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

@end

@interface InTweakPurchaseBillView ()

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) NSString *itemNameLabel;
@property (nonatomic, strong) NSString *stateLabel;
@property (nonatomic, strong) NSString *dateLabel;
@property (nonatomic, strong) NSString *idLabel;

@property (nonatomic, strong) KLCPopup* popup;
@property (nonatomic, strong) UIView *billView;
@end

@implementation InTweakPurchaseBillView

- (void)transactionWithItemName:(NSString *)itemName state:(NSString *)transStat purchaseDate:(NSString *)dateString andPaymentID:(NSString *)payID {
    self.itemNameLabel = itemName;
    self.stateLabel = transStat;
    self.dateLabel = dateString;
    self.idLabel = payID;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Starting billing View");
        [self setBackgroundColor:[UIColor whiteColor]];
        self.popup = [KLCPopup popupWithContentView:self
                                           showType:KLCPopupShowTypeBounceInFromBottom
                                        dismissType:KLCPopupDismissTypeBounceOutToTop
                                           maskType:KLCPopupMaskTypeDimmed
                           dismissOnBackgroundTouch:YES
                              dismissOnContentTouch:NO];
    }
    return self;
}

- (void)prepareUI {
    NSLog(@"Prepare billing View");
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width-50, self.frame.size.width-20)];
    self.mainLabel.center = CGPointMake(self.frame.size.width  / 2, self.frame.size.height / 2);
    [self.mainLabel setNumberOfLines:0];
    [self.mainLabel setTextAlignment:NSTextAlignmentLeft];
    
    self.stateLabel = [self.stateLabel stringByReplacingOccurrencesOfString:@"approved" withString:@"Paid"];
    
    [self.mainLabel setHtml:[NSString stringWithFormat:@"<h1>%@ Bill</h1><h2>State:</h2><big><p>%@</p></big><h2>Date:</h2><big><p>%@</p></big><h2>Transaction ID:</h2><big><p>%@</p></big><h2>Note:</h2><big><p>Keep this bill in save for future use ( it's already saved in your Photos Album )</p></big>",self.itemNameLabel, self.stateLabel, self.dateLabel, self.idLabel]];
    
    [self.mainLabel setBackgroundColor:[UIColor clearColor]];
    [self.mainLabel setTextColor:[UIColor blackColor]];
    [self.mainLabel sizeToFit];
    
    [self addSubview:self.mainLabel];
}

//    [self.mainLabel setHtml:[NSString stringWithFormat:@"<b><h2>State:</h2></b><big><p>%@</p></big> <b><h2>Date:</h2></b><big><p>%@</p></big> <b><h2>Transaction ID:</h2></b><big><p>%@</p></big>", self.stateLabel, self.dateLabel, self.idLabel]];

//    [self.mainLabel setHtml:[NSString stringWithFormat:@"<b>State:</b><p>%@</p> <b>Date:</b><p>%@</p> <b>Transaction ID:</b><p>%@</p>", self.stateLabel, self.dateLabel, self.idLabel]];

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self prepareUI];
}
- (void)showBill {
    NSLog(@"Show billing View");
    [self.popup show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIImage *imageScreenShot = [self.popup screenshot];
        UIImageWriteToSavedPhotosAlbum(imageScreenShot, nil, nil, nil);
    });
    
}
- (void)hideBill {
    NSLog(@"Hide billing View");
    [self.popup dismiss:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
