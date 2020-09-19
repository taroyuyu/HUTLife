//
//  VeriyCodeViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "VeriyCodeViewController.h"
#import "HUTManager.h"

@interface VeriyCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *verifyCodeImage;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;

@end

@implementation VeriyCodeViewController

+(instancetype)verifyCodeViewController
{

   return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verifyCodeController"];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self nextVerifyCodeClicked:nil];
}


//换下一张验证码
- (IBAction)nextVerifyCodeClicked:(UIButton *)sender {
    
    [[HUTManager sharedHUTManager] getLatestVerifyCodeWithSuccessBlock:^(NSData *imageData) {
        
        
        
            UIImage *image = [UIImage imageWithData:imageData];
            
            if (image) {
                [[self verifyCodeImage] setImage:image];
            }
        
    } failureBlock:^(NSError* error){
        NSLog(@"获取验证码失败");
    }];
}

//开始验证
- (IBAction)verifyButtonClicked:(UIButton *)sender {
    
    if ([self delegate]) {
        [[self delegate] veriyCodeController:self beginVeriyWithCode:[[self verifyCodeField] text]];
    }
}

//取消
- (IBAction)cancleButtonClicked:(UIButton *)sender {
    [self dismiss];
    [[self verifyCodeImage] setImage:nil];
}

-(void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:[self view]];
}

-(void)dismiss
{
    
    [[self view] removeFromSuperview];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
