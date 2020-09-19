//
//  ProfileDetailViewController.h
//  HUT
//
//  Created by Lingyu on 16/2/19.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface ProfileDetailViewController : UITableViewController
@property(nonatomic,strong)UserModel *model;
+(instancetype)profileDetailController;
@end
