//
//  LoginViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "HUTManager.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hutAccount;
@property (weak, nonatomic) IBOutlet UITextField *hutPasswordPassword;
@end

@implementation LoginViewController

+(instancetype)loginController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)loginButtonClicked:(UIButton *)sender {

    [[self hutAccount] resignFirstResponder];
    [[self hutPasswordPassword] resignFirstResponder];
    
    NSString *hutAccount = [[self hutAccount] text];
    NSString *hutPassword = [[self hutPasswordPassword] text];
    [MBProgressHUD showMessage:@"正在登录"];
    [[HUTManager sharedHUTManager] loginHUTLifeWithAccount:hutAccount andPassword:hutPassword success:^(HUTManager *manager) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"登录成功"];
        [self performSelector:@selector(showMainViewController) withObject:nil afterDelay:2];
    } failure:^(HUTManager *manager, NSError *error) {
        [MBProgressHUD hideHUD];
        if ([error code] == HUTLifeConnectError) {
            [MBProgressHUD showError:@"网络连接异常"];
        }else if ([error code] ==  HUTLifePasswordError){
            [MBProgressHUD showError:@"用户名不存在或者密码错误"];
        }
    }];
}

-(void)showMainViewController
{
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    transition.duration = 0.4;
    transition.subtype = kCATransitionFromLeft;
    [[[[[UIApplication sharedApplication] delegate] window] layer]addAnimation:transition forKey:nil];
    
    
    MainViewController *mainController = [MainViewController new];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:mainController];
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    
    //创建核心动画
        CATransition *transition=[CATransition animation];
         //告诉要执行什么动画
         //设置过度效果
         transition.type=@"cube";
         //设置动画的过度方向（向右）
         transition.subtype=kCATransitionFromRight;
         //设置动画的时间
         transition.duration=0.4;
         //添加动画
    [[[[[UIApplication sharedApplication] delegate] window] layer]addAnimation:transition forKey:nil];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:[RegisterViewController registeViewController]];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}



@end
