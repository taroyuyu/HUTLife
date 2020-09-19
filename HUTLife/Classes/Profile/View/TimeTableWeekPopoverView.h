//
//  TimeTableWeekPopoverView.h
//  HUTLife
//
//  Created by Lingyu on 16/4/2.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeTableWeekPopoverView;

@protocol TimeTableWeekPopoverViewDelegate <NSObject>

@optional
-(void)weekPopoverView:(TimeTableWeekPopoverView*)weekPopoverView didSelected:(NSInteger)index;
@end

@interface TimeTableWeekPopoverView : UIImageView
@property(nonatomic,assign)NSInteger weekCount;
@property(nonatomic,weak)NSObject<TimeTableWeekPopoverViewDelegate> *delegate;
+(instancetype)weekPopoverViewWithWeekCount:(NSInteger)weekCount;
-(void)showAtView:(UIView*)anchorView;
-(void)hiddenPopverView;
@end
