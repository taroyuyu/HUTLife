//
//  TimeTableWeekPicker.h
//  HUTLife
//
//  Created by Lingyu on 16/4/2.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeTableWeekPicker;

@protocol TimeTableWeekPickerDelegate <NSObject>

@optional
-(void)timeTableWeekPickerDidClicked:(TimeTableWeekPicker*)picker;
@end

@interface TimeTableWeekPicker : UIView
@property(nonatomic,strong)NSObject<TimeTableWeekPickerDelegate> *delegate;
@property(nonatomic,copy)NSString *week;
@property(nonatomic,strong)UIColor *tintColor;
+(instancetype)weekPicker;
@end
