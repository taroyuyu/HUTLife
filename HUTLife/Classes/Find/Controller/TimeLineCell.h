//
//  TimeLineCell.h
//  HUTLife
//
//  Created by Lingyu on 16/3/12.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeLineModel;

@interface TimeLineCell : UITableViewCell
@property(nonatomic,strong)TimeLineModel *model;
+(instancetype)timeLineCellWithTableView:(UITableView*)tableView andModel:(TimeLineModel*)model;
+(CGFloat)cellHighetWitableTableView:(UITableView*)tableView andModel:(TimeLineModel*)model;
@end
