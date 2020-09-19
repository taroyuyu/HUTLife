//
//  VeriyCodeViewController.h
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VeriyCodeViewController;

@protocol VeriyCodeViewControllerDelegate <NSObject>

-(void)veriyCodeController:(VeriyCodeViewController*)veriyCodeController beginVeriyWithCode:(NSString*)verifyCode;

@end

@interface VeriyCodeViewController : UIViewController
@property(nonatomic)NSObject<VeriyCodeViewControllerDelegate> *delegate;
+(instancetype)verifyCodeViewController;
-(void)show;
-(void)dismiss;
@end
