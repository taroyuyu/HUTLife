//
//  ProfileDetailViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/19.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "UserModel.h"

@interface ProfileDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEnrollmentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCollegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMajorLabel;
@property (weak, nonatomic) IBOutlet UILabel *userClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMiddleSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHomeTownLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;

@end

@implementation ProfileDetailViewController

+(instancetype)profileDetailController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"profileDetailController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个人信息"];
    
}

-(void)setModel:(UserModel *)model
{
    self->_model = model;
    
    [self loadModelInfomation];
}

-(void)loadModelInfomation
{
    NSLog(@"加载");
    NSLog(@"%@",[self model]);
    
    [[self userNameLabel] setText:[[self model] name]];
    [[self schoolIDLabel] setText:[[self model] studentID]];
    if ([[self model] sex]) {
        [[self userSexLabel] setText:@"男"];
    }else{
        [[self userSexLabel] setText:@"女"];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [[self userBirthLabel] setText:[dateFormatter stringFromDate:[[self model] birthDate]]];
    [[self userEnrollmentDateLabel] setText:[dateFormatter stringFromDate:[[self model] enrollmentDate]]];
    [[self userCollegeLabel] setText:[[self model] college]];
    [[self userMajorLabel] setText:[[self model] major]];
    [[self userClassLabel] setText:[[self model] className]];
    [[self userMiddleSchoolLabel] setText:[[self model] middleSchool]];
    [[self userHomeTownLabel] setText:[[self model] homeTown]];
    
}

@end
