//
//  HUTTimeTableView.m
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "HUTTimeTableView.h"
#import "TimeTable.h"
#import "WeekItemView.h"
#import "CourseTableView.h"

@interface HUTTimeTableView ()<CourseTableViewDelegate>
@property(nonatomic)NSArray<NSString*> *weekDays;
@property(nonatomic)NSArray<WeekItemView*> *weekItemViewArray;
@property(nonatomic)NSArray<UILabel*> *courseTimeIndexArray;
@property(nonatomic)CourseTableView *tableView;
@property(nonatomic)UILabel *monthLabel;
@end

@implementation HUTTimeTableView

static NSString *weekDaysFileName = @"weekDays.plist";


+(instancetype)timeTableView
{
    HUTTimeTableView *view = [HUTTimeTableView new];
    
    return view;
}

-(NSArray<NSString*> *)weekDays
{
    if (self->_weekDays) {
        return self->_weekDays;
    }
    
    self->_weekDays = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:weekDaysFileName withExtension:nil]];
    
    return self->_weekDays;
}

-(UILabel*)monthLabel
{
    if (self->_monthLabel) {
        return self->_monthLabel;
    }
    
    self->_monthLabel = [UILabel new];
    
    [[self->_monthLabel layer] setBorderColor:[[UIColor colorWithRed:90.0/255.0 green:200.0/255.0 blue:240.0/255.0 alpha:1] CGColor]];
    
    [self->_monthLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1]];
    
    [[self->_monthLabel layer] setBorderWidth:1];
    
    [self->_monthLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self->_monthLabel setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
    
    //获取当前的月份
    
    NSDate *currentDate = [NSDate new];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSInteger month = [[dateFormatter stringFromDate:currentDate] integerValue];

    [self->_monthLabel setText:[NSString stringWithFormat:@"%ld月",month]];
    
    return self->_monthLabel;
}

-(CourseTableView*)tableView
{
    if (self->_tableView) {
        return self->_tableView;
    }
    
    self->_tableView = [CourseTableView new];
    
    [self->_tableView setCourseCount:12];
    
    [self->_tableView setTimeTableItems:[[self model] tableItems]];
    
    [self->_tableView setCourseTableViewdelegate:self];
    
    return self->_tableView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
        self->_weekIndex = 1;
    }
    
    return self;
}

-(void)setModel:(TimeTable *)model
{
    self->_model = model;
    
    [[self tableView] setTimeTableItems:[model tableItems]];
}

-(void)setWeekIndex:(NSInteger)weekIndex
{
    if (weekIndex!=self->_weekIndex) {
        self->_weekIndex = weekIndex;
        [[self tableView] setWeekIndex:self->_weekIndex];
    }
}

-(void)loadSubviews
{
    [self addSubview:[self monthLabel]];
    [self loadTopSubviews];
    [self addSubview:[self tableView]];
    
}

/**
 *加载顶部的子视图
 *用于显示 月份、星期一、星期二、星期三、星期四、星期五、星期六、星期天
 */
-(void)loadTopSubviews
{
    
    for (WeekItemView *itemView in [self weekItemViewArray]) {
        [itemView removeFromSuperview];
    }
    
    NSMutableArray<WeekItemView*> *itemViewArray = [NSMutableArray<WeekItemView*> new];
    
    NSUInteger index = 0;
    for (NSString *weekDayItem in [self weekDays]) {
        WeekItemView *itemView = [WeekItemView new];
        
        [itemView setWeekDay:weekDayItem];
        [itemView setDay:[NSString stringWithFormat:@"%ld",index+1]];
        
        [itemViewArray addObject:itemView];
        
        [self addSubview:itemView];
        
        index++;
        
    }
    
    [self setWeekItemViewArray:itemViewArray];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //布局monthLabel
    
    CGFloat width = [self bounds].size.width / ( [[self weekItemViewArray] count] * 2  + 1);
    
    CGFloat height = 40;
    
    [[self monthLabel] setFrame:CGRectMake(0, 0, width, height)];
    
    [self layoutTopSubviews];
    
    //布局底部的子视图
    
    CGFloat topSubviewHeight = [[[self weekItemViewArray] lastObject] bounds].size.height;
    [[self tableView] setFrame:CGRectMake(0, topSubviewHeight, [self bounds].size.width, [self bounds].size.height - topSubviewHeight)];
}

/**
 *布局顶部的子视图
 */
-(void)layoutTopSubviews
{
    NSUInteger index = 0;
    
    CGFloat width = [[self monthLabel] frame].size.width * 2;
    
    CGFloat height = [[self monthLabel] frame].size.height;
    
    CGFloat y = 0;
    
    for (WeekItemView *itemView in [self weekItemViewArray]) {
        
        CGFloat x = width * index + CGRectGetMaxX([[self monthLabel] frame]);
        
        [itemView setFrame:CGRectMake(x, y, width, height)];
        
        index++;
        
        
    }
}

-(void)courseTableView:(CourseTableView *)courseTableView didSelectedCourseItem:(TimeTableItem *)courseItem
{
    if ([self delegate]) {
        if ([[self delegate] respondsToSelector:@selector(timeTableView:didSelectedTimeTableItem:)]) {
            [[self delegate] timeTableView:self didSelectedTimeTableItem:courseItem];
        }
    }
}

-(void)courseTableVIew:(CourseTableView *)courseTableView didSelectedEmptyIndex:(NSIndexPath *)indexPath
{
    if ([self delegate]) {
        if ([[self delegate] respondsToSelector:@selector(timeTableView:didSelectedEmptyItemArIndex:)]) {
            [[self delegate] timeTableView:self didSelectedEmptyItemArIndex:indexPath];
        }
    }
}

-(void)addTimeTableItem:(TimeTableItem *)timeTableItem
{
    [[self tableView] addTimeTableItem:timeTableItem];
}

-(void)removeTimeTableItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[self tableView] removeTimeTableItemAtIndexPath:indexPath];
}

@end
