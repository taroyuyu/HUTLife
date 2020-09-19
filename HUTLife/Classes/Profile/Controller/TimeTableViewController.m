//
//  TimeTableViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeTableViewController.h"
#import "HUTTimeTableView.h"
#import "HUTManager.h"
#import "TimeTable.h"
#import "TimeTableItem.h"
#import "TimeTableItemDetaiilViewController.h"
#import "TimeTableWeekPicker.h"
#import "TimeTableWeekPopoverView.h"
@interface TimeTableViewController ()<HUTTimeTableViewDelegate,TimeTableWeekPickerDelegate,TimeTableWeekPopoverViewDelegate>
@property(nonatomic,strong)UIImageView* tableViewBackgroundImageView;
@property(nonatomic,strong)HUTTimeTableView *timeTableView;
@property(nonatomic,strong)TimeTableWeekPicker *weekPicker;
@property(nonatomic,strong)TimeTableWeekPopoverView *weekPopoverView;
@property(nonatomic,assign)NSInteger weekIndex;
@property(nonatomic,strong)UIBarButtonItem *settingBarButtonItem;
@end

@implementation TimeTableViewController

-(TimeTableWeekPopoverView*)weekPopoverView
{
    if (self->_weekPopoverView) {
        return self->_weekPopoverView;
    }
    
    self->_weekPopoverView = [TimeTableWeekPopoverView weekPopoverViewWithWeekCount:20];
    [self->_weekPopoverView setDelegate:self];
    return self->_weekPopoverView;
}

-(void)setWeekIndex:(NSInteger)weekIndex
{
    self->_weekIndex = weekIndex;
    [[self weekPicker] setWeek:[NSString stringWithFormat:@"第%ld周",self->_weekIndex]];
    
    [[self timeTableView] setWeekIndex:self->_weekIndex];
    
}

-(void)weekPopoverView:(TimeTableWeekPopoverView*)weekPopoverView didSelected:(NSInteger)index
{
    [weekPopoverView hiddenPopverView];
    [self setWeekIndex:index];
}

-(TimeTableWeekPicker*)weekPicker
{
    if (self->_weekPicker) {
        return self->_weekPicker;
    }
    
    self->_weekPicker = [TimeTableWeekPicker weekPicker];
    [self->_weekPicker setBounds:CGRectMake(0, 0, 100, 44)];
    [self->_weekPicker setTintColor:[[[self navigationController] navigationBar] tintColor]];
    [self->_weekPicker setDelegate:self];
    return self->_weekPicker;
}

-(UIBarButtonItem*)settingBarButtonItem
{
    if (self->_settingBarButtonItem) {
        return self->_settingBarButtonItem;
    }
    
    self->_settingBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingBarButtonClicked)];
    
    return self->_settingBarButtonItem;
}

-(void)settingBarButtonClicked
{
    
}


-(void)timeTableWeekPickerDidClicked:(TimeTableWeekPicker*)picker
{
    //显示
    [[self weekPopoverView] showAtView:picker];
}

-(UIImageView*)tableViewBackgroundImageView
{
    if (self->_tableViewBackgroundImageView) {
        return self->_tableViewBackgroundImageView;
    }
    
    self->_tableViewBackgroundImageView = [UIImageView new];
    
    [self->_tableViewBackgroundImageView setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, [[self view] bounds].size.height+[[self view] bounds].origin.y)];
    
    [self->_tableViewBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self->_tableViewBackgroundImageView setImage:[UIImage imageNamed:@"courseTableBackgrond"]];
    
    
    return self->_tableViewBackgroundImageView;
}

-(HUTTimeTableView*)timeTableView
{
    if (self->_timeTableView) {
        return self->_timeTableView;
    }
    
    self->_timeTableView = [HUTTimeTableView timeTableView];
    
    [self->_timeTableView setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, [[self view] bounds].size.height+[[self view] bounds].origin.y)];
    
    [self->_timeTableView setDelegate:self];
    
    [[HUTManager sharedHUTManager] enquireClassTimeTableWithSuccess:^(TimeTable *timeTable) {
        
        [self->_timeTableView setModel:timeTable];
        [[self navigationItem] setTitleView:[self weekPicker]];
        
    } andFailure:^(NSError *error) {
        if (error) {
            NSLog(@"获取课程表失败");
        }
    }];
    
    
    return self->_timeTableView;
}


- (void)viewDidLoad {
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [[self view] setBounds:CGRectMake(0, -20, [[self view] bounds].size.width, [[self view] bounds].size.height)];
    
    if ([[[self navigationController] navigationBar] isHidden] == NO) {
        //导航栏显示
        CGRect selfViewOriginBounds = [[self view] bounds];
        CGFloat navigationBarHeight = [[[self navigationController] navigationBar] bounds].size.height;
        
        [[self view] setBounds:CGRectMake(selfViewOriginBounds.origin.x,selfViewOriginBounds.origin.y - navigationBarHeight, selfViewOriginBounds.size.width, selfViewOriginBounds.size.height)];
    }
    
    [[self view] addSubview:[self tableViewBackgroundImageView]];
    
    [[self view] addSubview:[self timeTableView]];
    
    [[self navigationItem] setRightBarButtonItem:[self settingBarButtonItem]];
    
    
#pragma Test
    [self setWeekIndex:1];
}

-(void)timeTableView:(HUTTimeTableView *)timeTableView didSelectedTimeTableItem:(TimeTableItem *)timeTableItem
{
    TimeTableItemDetaiilViewController *itemDetailViewController = [TimeTableItemDetaiilViewController itemDetailViewController];
    
    [itemDetailViewController setModel:timeTableItem];
    
    [[self navigationController] pushViewController:itemDetailViewController animated:YES];
}

-(void)timeTableView:(HUTTimeTableView *)timeTableView didSelectedEmptyItemArIndex:(NSIndexPath *)indexPath
{
    
}


@end
