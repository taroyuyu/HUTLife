//
//  ProfileListViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ProfileListViewController.h"
#import "HUTManager.h"
#import "UserModel.h"
#import "TimeTableViewController.h"
#import "VCardViewController.h"
#import "GradeViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "VeriyCodeViewController.h"
@interface ProfileListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userClassLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;
@end

@implementation ProfileListViewController

+(instancetype)profileListController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"profileListController"];
}

-(void)loadView
{
    [super loadView];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[self userAvatarView] layer] setCornerRadius:[[self userAvatarView] bounds].size.width/2];
    [[self userAvatarView]setClipsToBounds:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[[HUTManager sharedHUTManager] uservCard] nickname]) {
        [[self userNameLabel] setText:[[[HUTManager sharedHUTManager] uservCard] nickname]];
    }else{
        [[self userNameLabel] setText:[[HUTManager sharedHUTManager] hutLifeAccount]];
    }
    
    if ([[[HUTManager sharedHUTManager] uservCard] photo]) {
        [[self userAvatarView] setImage:[[UIImage alloc] initWithData:[[[HUTManager sharedHUTManager] uservCard] photo]]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            if ([indexPath row] == 0) {
                VCardViewController *vCardController = [VCardViewController new];
                [[self navigationController] pushViewController:vCardController animated:YES];
            }else if ([indexPath row] == 1) {
                return;
                [[self navigationController] pushViewController:[TimeTableViewController new] animated:YES];
            }else if([indexPath row] == 2){
                return;
                GradeViewController *viewController = [GradeViewController gradeController];
                [[HUTManager sharedHUTManager] enquireUserSchoolRecordsWithSuccess:^(NSArray<StudentGradeItem *> *gradeItems) {
                    [viewController setGradeItemArray:gradeItems];
                } andFailure:^(NSError *error) {
                    NSLog(@"获取成绩失败");
                }];
                [[self navigationController] pushViewController:viewController animated:YES];
            }
        }
            break;
        case 1:
        {
            if ([indexPath row] == 0) {
                [[self navigationController] pushViewController:[AboutViewController aboutController] animated:YES];
                
            }else if([indexPath row] == 1){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您的真的要退出吗" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [HUTManager cleanData];
                    [[[UIApplication sharedApplication] keyWindow] setRootViewController:[LoginViewController loginController]];
                }];
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancleAction];
                [alertController addAction:exitAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        default:
            break;
    }
}

@end
