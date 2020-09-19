//
//  ContactCell.h
//  HUTLife
//
//  Created by Lingyu on 16/4/6.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPUserCoreDataStorageObject;

@interface ContactCell : UITableViewCell
@property(nonatomic,strong)XMPPUserCoreDataStorageObject *model;
+(instancetype)cellWithTableView:(UITableView*)tableView andModel:(XMPPUserCoreDataStorageObject*)model;
@end
