//
//  CourseTableView.h
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeTableItem;

@class CourseTableView;

@protocol CourseTableViewDelegate <NSObject>

@optional
-(void)courseTableView:(CourseTableView*)courseTableView didSelectedCourseItem:(TimeTableItem*)courseItem;
-(void)courseTableVIew:(CourseTableView*)courseTableView didSelectedEmptyIndex:(NSIndexPath*)indexPath;
@end

@interface CourseTableView : UIScrollView
@property(nonatomic,assign)NSUInteger courseCount;
@property(nonatomic,strong)NSArray<TimeTableItem*> *timeTableItems;
@property(nonatomic,strong)NSObject<CourseTableViewDelegate> *courseTableViewdelegate;
@property(nonatomic,assign)NSInteger weekIndex;
-(void)addTimeTableItem:(TimeTableItem*)timeTableItem;
-(void)removeTimeTableItemAtIndexPath:(NSIndexPath*)indexPath;
@end
