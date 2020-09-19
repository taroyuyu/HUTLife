//
//  CourseItemButton.m
//  HUT
//
//  Created by Lingyu on 16/2/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "CourseItemButton.h"
#import "TimeTableItem.h"

@interface CourseItemButton ()
@property(nonatomic)UITextView *textView;
@end

@implementation CourseItemButton
{
    NSMutableArray<NSString*> *_colorsImageArray;
    NSMutableDictionary<NSString*,NSString*> *_colorDictionary;
}

static NSString *colorsImageFileName = @"ColorImage.plist";


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:[self textView]];
    }
    
    return self;
}

-(NSMutableArray<NSString*>*)colorsImageArray
{
    if (self->_colorsImageArray) {
        return self->_colorsImageArray;
    }
    
    self->_colorsImageArray = [NSMutableArray<NSString*> arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:colorsImageFileName withExtension:nil]];
    return self->_colorsImageArray;
}

-(NSMutableDictionary<NSString*,NSString*>*)colorDictionary
{
    if (self->_colorDictionary) {
        return self->_colorDictionary;
    }
    self->_colorDictionary = [NSMutableDictionary<NSString*,NSString*> dictionary];
    
    return self->_colorDictionary;
}

-(UITextView*)textView
{
    if (self->_textView) {
        return self->_textView;
    }
    
    self->_textView = [UITextView new];
    [self->_textView setBackgroundColor:[UIColor clearColor]];
    [self->_textView setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
    [self->_textView setTextColor:[UIColor whiteColor]];
    [self->_textView setUserInteractionEnabled:NO];
    return self->_textView;
}

-(void)setModel:(TimeTableItem *)model
{
    self->_model = model;
    
    [[self textView] setText:[NSString stringWithFormat:@"%@@%@",[[self model] courseName],[[self model] coursePlace]]];
    
    [self loadBackGround];
}

-(void)loadBackGround
{
    NSString *imageName = [[self colorDictionary] objectForKey:[[self model] courseName]];
    
    if (imageName==nil) {
        NSUInteger index = arc4random() % [[self colorsImageArray ] count];//随机颜色索引
        imageName = [[self colorsImageArray ] objectAtIndex:index];//获取颜色
        [[self colorsImageArray ] removeObjectAtIndex:index];//移除颜色
        [[self colorDictionary ] setObject:imageName forKey:[[self model] courseName]];//添加到字典中
    }
    
    //设置颜色
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [[self textView] setFrame:[self bounds]];
}

@end
