//
//  HUTTimeTableView.h
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeTable;

@class TimeTableItem;

@class HUTTimeTableView;

@protocol HUTTimeTableViewDelegate <NSObject>

@optional
-(void)timeTableView:(HUTTimeTableView*)timeTableView didSelectedTimeTableItem:(TimeTableItem*)timeTableItem;
-(void)timeTableView:(HUTTimeTableView*)timeTableView didSelectedEmptyItemArIndex:(NSIndexPath*)indexPath;

@end

@interface HUTTimeTableView : UIView
+(instancetype)timeTableView;
@property(nonatomic,strong)TimeTable *model;
@property(nonatomic,strong)NSObject<HUTTimeTableViewDelegate> *delegate;
@property(nonatomic,assign)NSInteger weekIndex;
-(void)addTimeTableItem:(TimeTableItem*)timeTableItem;
-(void)removeTimeTableItemAtIndexPath:(NSIndexPath*)indexPath;
@end
