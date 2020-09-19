//
//  WeekItemView.m
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "WeekItemView.h"

@interface WeekItemView ()
@property(nonatomic)UILabel *dayLabel;
@property(nonatomic)UILabel *weekDayLabel;
@end

@implementation WeekItemView

static UIColor *textColor;
static UIColor *borderColor;
static CGFloat borderWidth;
+(void)initialize
{
    textColor = [UIColor colorWithRed:45.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1];
    borderColor = [UIColor colorWithRed:90.0/255.0 green:200.0/255.0 blue:240.0/255.0 alpha:1];
    borderWidth = 1;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[self layer] setBorderColor:[borderColor CGColor]];
        [[self layer] setBorderWidth:borderWidth];
        
        [self addSubview:[self dayLabel]];
        [self addSubview:[self weekDayLabel]];
        
    }
    
    return self;
}

-(UILabel *)dayLabel
{
    if (self->_dayLabel) {
        return self->_dayLabel;
    }
    
    self->_dayLabel = [UILabel new];
    
    [self->_dayLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self->_dayLabel setTextColor:textColor];
    
    [self->_dayLabel setFont: [UIFont fontWithName:@"Arial" size:10.0f]];
    
    
    
    return self->_dayLabel;
}

-(UILabel*)weekDayLabel
{
    if (self->_weekDayLabel) {
        return self->_weekDayLabel;
    }
    
    self->_weekDayLabel = [UILabel new];
    
    [self->_weekDayLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self->_weekDayLabel setTextColor:textColor];
    
    [self->_weekDayLabel setFont: [UIFont fontWithName:@"Arial" size:12.0f]];
    
    return self->_weekDayLabel;
}

-(void)setDay:(NSString *)day
{
    self->_day = day;
    
    [[self dayLabel] setText:[self day]];
}

-(void)setWeekDay:(NSString *)weekDay
{
    self->_weekDay = weekDay;
    
    [[self weekDayLabel] setText:[self weekDay]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfWidth = [self bounds].size.width;
    
    CGFloat selfHeight = [self bounds].size.height;
    
    CGFloat dayHeight = selfHeight * 1 / 3;
    
    CGFloat weekDayHeight = selfHeight * 2 / 3;
    
    [[self dayLabel] setFrame:CGRectMake(0, 0, selfWidth, dayHeight)];
    
    [[self weekDayLabel] setFrame:CGRectMake(0, dayHeight, selfWidth, weekDayHeight)];
}

@end
