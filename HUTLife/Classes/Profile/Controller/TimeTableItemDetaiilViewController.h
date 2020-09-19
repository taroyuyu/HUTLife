//
//  TimeTableItemDetaiilViewController.h
//  HUT
//
//  Created by Lingyu on 16/2/18.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeTableItem;

@interface TimeTableItemDetaiilViewController : UITableViewController
+(instancetype)itemDetailViewController;
@property(nonatomic,strong)TimeTableItem *model;
@end
