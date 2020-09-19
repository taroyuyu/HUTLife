//
//  TimeTableWeekPopoverView.m
//  HUTLife
//
//  Created by Lingyu on 16/4/2.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeTableWeekPopoverView.h"

const CGFloat interval = 5;

@interface TimeTableWeekPopoverView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TimeTableWeekPopoverView
{
    UITableView *_listView;
    NSInteger rowHeight;
}

+(instancetype)weekPopoverViewWithWeekCount:(NSInteger)weekCount
{
    TimeTableWeekPopoverView *popoverView = [[TimeTableWeekPopoverView alloc] initWithImage:nil highlightedImage:nil];
    [popoverView setWeekCount:weekCount];
    return popoverView;
}

-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIImage *backgroundImage = [UIImage imageNamed:@"week_popover_bg"];
    
    self = [super initWithImage:backgroundImage highlightedImage:highlightedImage];
    
    if (self) {
        [self sizeToFit];
        [self setUserInteractionEnabled:YES];
        [self setBounds:CGRectMake(0, 0, [self bounds].size.width, 100)];
        
        self->rowHeight = 40;
        
        //loadListView
        [self addSubview:[self listView]];
    }
    
    return self;
}

-(void)setWeekCount:(NSInteger)weekCount
{
    self->_weekCount = weekCount;
    
    if (self->_weekCount >= 5) {
        [self setBounds:CGRectMake(0, 0, [self bounds].size.width, 5 * rowHeight + 2 * interval)];
    }else{
        [self setBounds:CGRectMake(0, 0, [self bounds].size.width, weekCount * rowHeight + 2 * interval)];
    }
    
    [self setNeedsLayout];
    
}

-(UITableView*)listView
{
    if (self->_listView) {
        return self->_listView;
    }
    
    self->_listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self->_listView setDelegate:self];
    [self->_listView setDataSource:self];
    [self->_listView setRowHeight:self->rowHeight];
    return self->_listView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self->_weekCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *weekCellIdentifier = @"weekCell";
    
    UITableViewCell *weekCell = [tableView dequeueReusableCellWithIdentifier:weekCellIdentifier];
    
    if (nil==weekCell) {
        weekCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:weekCellIdentifier];
    }
    
    [[weekCell textLabel] setText:[NSString stringWithFormat:@"第%ld周",[indexPath row]+1]];
    
    return weekCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self delegate] respondsToSelector:@selector(weekPopoverView:didSelected:)]) {
        [[self delegate] weekPopoverView:self didSelected:[indexPath row]+1];
    }
}

-(void)showAtView:(UIView *)anchorView
{
    //获取Window
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
    
    //获取anchorPoint
    CGPoint anchorPoint = [frontWindow convertPoint:[anchorView center] fromView:[anchorView superview]];
    
    
    //设置frame
        //获取自身尺寸
    CGSize selfSize = [self bounds].size;
    
    [self setFrame:CGRectMake(anchorPoint.x - selfSize.width/2, anchorPoint.y, selfSize.width, selfSize.height)];
    
    //添加到frontWindow
    
    [frontWindow addSubview:self];
    
}

-(void)hiddenPopverView
{
    [self removeFromSuperview];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = [self bounds].size;
    
    //layout subviews
    [[self listView] setFrame:CGRectMake(interval, interval * 2, contentSize.width - 2 * interval,contentSize.height - 4 * interval)];
    
}
@end
