//
//  CourseTableView.m
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "CourseTableView.h"
#import "TimeTableItem.h"
#import "CourseItemButton.h"

@interface CourseTableView ()
@property(nonatomic)NSArray<UILabel*> *courseIndexArray;
@property(nonatomic)NSMutableArray<CourseItemButton*> *courseItemButtonArray;
@property(nonatomic)UIButton *editButton;
@property(nonatomic)NSArray<UILabel*> *intervalLabelsArray;
@end

@implementation CourseTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBounces:NO];
        [self setWeekIndex:1];
    }
    
    return self;
}

-(UIButton*)editButton
{
    if (self->_editButton) {
        return self->_editButton;
    }
    
    self->_editButton = [UIButton new];
    [self->_editButton setImage:[UIImage imageNamed:@"courseAddImage_img"] forState:UIControlStateNormal];
    
    [self->_editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return self->_editButton;
}

-(void)editButtonClicked:(UIButton*)editButton
{
    
    //左边课程索引的宽度
    CGFloat leftWidth = [[[self courseIndexArray] firstObject] frame].size.width;
    //左边课程索引的高度
    CGFloat leftHeight = [[[self courseIndexArray] firstObject] frame].size.height;
    
    CGFloat courseButonWidth = leftWidth * 2;
    
    
    //第几行
    NSUInteger row = editButton.frame.origin.y / leftHeight;
    //第几列
    NSUInteger column = (editButton.frame.origin.x - leftWidth) / courseButonWidth;
    
    if ([self courseTableViewdelegate]) {
        if ([[self courseTableViewdelegate] respondsToSelector:@selector(courseTableVIew:didSelectedEmptyIndex:)]) {
            [[self courseTableViewdelegate] courseTableVIew:self didSelectedEmptyIndex:[NSIndexPath indexPathForRow:row inSection:column]];
        }
    }
}

-(void)setCourseCount:(NSUInteger)courseCount
{
    self->_courseCount = courseCount;
    [self loadCourseIndexArray];
}

-(void)loadCourseIndexArray
{
    for (UILabel *indexLabel in [self courseIndexArray]) {
        [indexLabel removeFromSuperview];
    }
    
    NSMutableArray<UILabel*> *indexLabelArray = [NSMutableArray<UILabel*> new];
    
    for (int index = 0;index < [self courseCount]; index++) {
        
        UILabel * indexLabel = [UILabel new];
        
        [indexLabel setTextAlignment:NSTextAlignmentCenter];
        
        [indexLabel setText:[NSString stringWithFormat:@"%d",index+1]];
        
        [indexLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1]];
        
        [[indexLabel layer] setBorderColor:[[UIColor colorWithRed:90.0/255.0 green:200.0/255.0 blue:240.0/255.0 alpha:1] CGColor]];
    
        [[indexLabel layer] setBorderWidth:1];

        [self addSubview:indexLabel];
        
        [indexLabelArray addObject:indexLabel];
        
    }
    
    [self setCourseIndexArray:indexLabelArray];
    
    [self setNeedsLayout];
}

-(void)setTimeTableItems:(NSArray<TimeTableItem *> *)timeTableItems
{
    self->_timeTableItems = timeTableItems;

    
    [self loadIntervalLabels];
    
    [self loadtTableItems];

}

-(void)setWeekIndex:(NSInteger)weekIndex
{
    self->_weekIndex = weekIndex;
    
    
    [self loadtTableItems];
}

/**
 *加载课程单元格
 */

-(void)loadtTableItems
{
    
    for (CourseItemButton *itemButton in [self courseItemButtonArray]) {
        [itemButton removeFromSuperview];
    }
    
    self->_courseItemButtonArray = [NSMutableArray<CourseItemButton*> new];
    
    for (TimeTableItem *item in [self timeTableItems]) {
        
        if ([item isNeedShownInWeekIndex:[self weekIndex]]) {
            
            CourseItemButton *itemButton = [CourseItemButton new];
            
            [itemButton setModel:item];
            
            [itemButton addTarget:self action:@selector(courseItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:itemButton];
            
            [[self courseItemButtonArray] addObject:itemButton];
        }
        
        
    }
    
    [self setNeedsLayout];
    
}

-(void)courseItemButtonClicked:(CourseItemButton*)itemButton
{
    [[self editButton] removeFromSuperview];
    
    
    
    if ([self courseTableViewdelegate]) {
        if ([[self courseTableViewdelegate] respondsToSelector:@selector(courseTableView:didSelectedCourseItem:)]) {
            [[self courseTableViewdelegate] courseTableView:self didSelectedCourseItem:[itemButton model]];
        }
    }
}

/**
 *加载单元分割线
 */

-(void)loadIntervalLabels
{
    for (UILabel *labelItem in [self intervalLabelsArray]) {
        [labelItem removeFromSuperview];
    }
    
    NSMutableArray<UILabel*> *labelArray = [NSMutableArray<UILabel*> array];
    
    //行
    NSUInteger row = [[self courseIndexArray] count] - 1;
    //列
    NSUInteger column = 6;
    
    for (int index = 0; index < row * column; index++) {
        
        UILabel *label = [UILabel new];
        
        [label setText:@"+"];
        [label setTextColor:[UIColor colorWithRed:45.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:0.4]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:label];
        
        [labelArray addObject:label];
        
        
    }
    
    [self setIntervalLabelsArray:labelArray];
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutCourseIndexLabels];
    
    [self layoutCousrButtons];
    
    [self layoutIntervalLabels];
    
}

/**
 *布局左边的课程索引Label
 */
-(void)layoutCourseIndexLabels
{
    
    CGFloat width = [self bounds].size.width / 15;
    CGFloat height = width * 8 / 3;
    CGFloat X = 0;
    NSUInteger index = 0;
    
    for (UILabel *indexLabel in [self courseIndexArray]) {
        
        CGFloat Y = height * index;
        
        [indexLabel setFrame:CGRectMake(X, Y, width, height)];
        
        index++;
        
    }
    
    [self setContentSize:CGSizeMake([self bounds].size.width, CGRectGetMaxY([[self courseIndexArray] lastObject].frame))];
}

/**
 *布局课程单元格
 */

-(void)layoutCousrButtons
{
    
    //左边课程索引的宽度
    CGFloat leftWidth = [[[self courseIndexArray] firstObject] frame].size.width;
    //左边课程索引的高度
    CGFloat leftHeight = [[[self courseIndexArray] firstObject] frame].size.height;
    
    
    CGFloat courseButonWidth = leftWidth * 2;
    
    
    
    for (CourseItemButton *itemButton in [self courseItemButtonArray]) {
        
        TimeTableItem *model = [itemButton model];
        
        CGFloat courseButtonX = (model.courseDay - 1) * courseButonWidth + leftWidth;
        
        CGFloat courseButtonY = (model.courseTime.firstObject.intValue - 1) * leftHeight;
        
        CGFloat courseButtonHeight = (model.courseTime.count) * leftHeight;
        
        [itemButton setFrame:CGRectMake(courseButtonX, courseButtonY, courseButonWidth, courseButtonHeight)];
        
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    
    
    //左边课程索引的宽度
    CGFloat leftWidth = [[[self courseIndexArray] firstObject] frame].size.width;
    //左边课程索引的高度
    CGFloat leftHeight = [[[self courseIndexArray] firstObject] frame].size.height;
    
    CGFloat courseButonWidth = leftWidth * 2;
    
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    //第几行
    NSUInteger row = touchPoint.y / leftHeight;
    //第几列
    NSUInteger column = (touchPoint.x - leftWidth) / courseButonWidth;
    
    [self showEditButtonAt:[NSIndexPath indexPathForRow:row inSection:column]];
}

-(void)showEditButtonAt:(NSIndexPath*)indexPath
{
    [[self editButton] removeFromSuperview];
    
    //左边课程索引的宽度
    CGFloat leftWidth = [[[self courseIndexArray] firstObject] frame].size.width;
    //左边课程索引的高度
    CGFloat leftHeight = [[[self courseIndexArray] firstObject] frame].size.height;
    
    CGFloat courseButonWidth = leftWidth * 2;


    CGFloat editButtonX = leftWidth + courseButonWidth * indexPath.section;
    
    CGFloat editButtonY = leftHeight * indexPath.row;
    
    [[self editButton] setFrame:CGRectMake(editButtonX, editButtonY, courseButonWidth, leftHeight)];
    
    [self addSubview:[self editButton]];
    
}

/**
 *布局intervalLabels
 */
-(void)layoutIntervalLabels
{
    CGFloat width = 10;
    
    CGFloat height = width;
    
    
    NSUInteger rowCount = [[self courseIndexArray] count] - 1;
    
    NSUInteger columnCount = 6;
    
    
    for (int index = 0; index < rowCount * columnCount; index++) {
        
        UILabel *currentLabel = [[self intervalLabelsArray] objectAtIndex:index];
        
        //列
        NSUInteger column = index % columnCount;
        //行
        NSUInteger row = index / columnCount;
        
        CGFloat centerX = ( column + 1 ) * [[[self courseItemButtonArray] firstObject] frame].size.width + [[[self courseIndexArray] firstObject] frame].size.width;
        CGFloat centerY = (row + 1) * [[[self courseIndexArray] firstObject] frame].size.height;
        
        [currentLabel setBounds:CGRectMake(0, 0, width, height)];
        [currentLabel setCenter:CGPointMake(centerX, centerY)];
        
        
    }
    
}

-(void)addTimeTableItem:(TimeTableItem *)timeTableItem
{
    
    NSMutableArray *newArray= [[self timeTableItems] mutableCopy];
    
    [newArray addObject:timeTableItem];
    
    [self setTimeTableItems:[newArray copy]];
    
}

-(void)removeTimeTableItemAtIndexPath:(NSIndexPath *)indexPath
{
    //查找符合的TimeTableItem
    
    NSMutableArray *newArraya = [[self timeTableItems] mutableCopy];
    
    for (TimeTableItem* item in [self timeTableItems]) {
        if ([item courseFrom] <= [indexPath row]&&[indexPath row] <= [item courseTo]) {
            //符合条件
            [newArraya removeObject:item];
        }
    }
    
    [self setTimeTableItems:[newArraya copy]];
}

@end
