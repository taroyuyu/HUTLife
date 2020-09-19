//
//  TimeTableWeekPicker.m
//  HUTLife
//
//  Created by Lingyu on 16/4/2.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeTableWeekPicker.h"

@implementation TimeTableWeekPicker
{
    UIButton *_titleButton;
    UIImageView *_statusIndicator;
}

+(instancetype)weekPicker
{
    TimeTableWeekPicker *picker = [TimeTableWeekPicker new];
    return picker;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:[self titleButton]];
        [self addSubview:[self statusIndicator]];
    }
    
    return self;
}

-(UIButton*)titleButton
{
    if (self->_titleButton) {
        return self->_titleButton;
    }
    
    self->_titleButton = [UIButton new];
    [self->_titleButton setTitle:@"第五周" forState:UIControlStateNormal];
    [self->_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_titleButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return self->_titleButton;
}

-(void)titleButtonClicked
{
    if ([[self delegate] respondsToSelector:@selector(timeTableWeekPickerDidClicked:)]) {
        [[self delegate] timeTableWeekPickerDidClicked:self];
    }
}

-(void)setTintColor:(UIColor *)tintColor
{
    self->_tintColor = tintColor;
    [[self titleButton] setTitleColor:tintColor forState:UIControlStateNormal];
}

-(UIImageView*)statusIndicator
{
    if (self->_statusIndicator) {
        return self->_statusIndicator;
    }
    
    self->_statusIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"]];
    
    return self->_statusIndicator;
}

-(void)setWeek:(NSString *)week
{
    self->_week = week;
    [[self titleButton] setTitle:week forState:UIControlStateNormal];
}


-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isSelf = [super hitTest:point withEvent:event];
    
    if (isSelf) {
        return [self titleButton];
    }
    
    return  nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = [self bounds].size;
    
    CGFloat interval = 10;
    
    //布局statusIndicator
    [[self statusIndicator] sizeToFit];
    CGSize statusIndicatorSize = [[self statusIndicator] bounds].size;
    [[self statusIndicator] setFrame:CGRectMake(contentSize.width - 2 * interval - statusIndicatorSize.width, (contentSize.height - statusIndicatorSize.height)/2, statusIndicatorSize.width, statusIndicatorSize.height)];
    
    //布局 titleButton
    [[self titleButton] setFrame:CGRectMake(interval,interval, contentSize.width - 3 * interval - statusIndicatorSize.width, contentSize.height - 2 * interval)];
}

@end
