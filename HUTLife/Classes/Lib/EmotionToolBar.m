//
//  EmotionToolBar.m
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "EmotionToolBar.h"

@interface EmotionToolBar ()
@property(nonatomic,strong)NSArray<UIButton*> *barButtonArray;
@property(nonatomic,strong)UIButton *selectedBarButton;
@end

@implementation EmotionToolBar

static CGFloat toolBarWidth;
static CGFloat toolBarHeight;

+(void)initialize
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    toolBarWidth = [keyWindow bounds].size.width;
    toolBarHeight = 37;
}

+(instancetype)toolBar
{
    return [self new];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBounds:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
        [self loadSubviews];
    }
    
    return self;
}

-(void)loadSubviews
{
    //加载toolBar
    for (UIButton* buttonItem in [self barButtonArray]) {
        [self addSubview:buttonItem];
    }
}

-(BarButtonType)selectedType
{
    return [[self selectedBarButton] tag];
}

-(void)setSelectedBarButton:(UIButton *)selectedBarButton
{
    [self->_selectedBarButton setSelected:NO];
    
    self->_selectedBarButton = selectedBarButton;
    
    [self->_selectedBarButton setSelected:YES];
}

-(NSArray<UIButton*> *)barButtonArray
{
    if (self->_barButtonArray) {
        return self->_barButtonArray;
    }
    
    NSMutableArray<UIButton*> *buttonArray = [NSMutableArray<UIButton*> array];
    UIButton *recentButton = [self buttonWithTitl:@"最近" normalImage:[UIImage imageNamed:@"compose_emotion_table_left_normal"] andSelectedImage:[UIImage imageNamed:@"compose_emotion_table_left_selected"]];
    [recentButton setTag:BarButtonTypeRecent];
    [self setSelectedBarButton:recentButton];
    UIButton *defaultButton = [self buttonWithTitl:@"默认" normalImage:[UIImage imageNamed:@"compose_emotion_table_mid_normal"] andSelectedImage:[UIImage imageNamed:@"compose_emotion_table_mid_selected"]];
    [defaultButton setTag:BarButtonTypeDefault];
    UIButton *lxhButton = [self buttonWithTitl:@"浪小花" normalImage:[UIImage imageNamed:@"compose_emotion_table_right_normal"] andSelectedImage:[UIImage imageNamed:@"compose_emotion_table_right_selected"]];
    [lxhButton setTag:BarButtonTypeLXH];
    
    [buttonArray addObject:recentButton];
    [buttonArray addObject:defaultButton];
    [buttonArray addObject:lxhButton];
    
    self->_barButtonArray = [buttonArray copy];
    
    return self->_barButtonArray;
}

-(UIButton*)buttonWithTitl:(NSString*)title normalImage:(UIImage*)normalImage andSelectedImage:(UIImage*)selectedImage
{
    UIButton *button = [UIButton new];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(switchButtonStatu:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)switchButtonStatu:(UIButton*)barButton
{
    [self setSelectedBarButton:barButton];

    if ([[self delegate] respondsToSelector:@selector(emotionToolBar:didSelected:)]) {
        [[self delegate] emotionToolBar:self didSelected:barButton.tag];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //布局toolBar
    CGFloat width = [self bounds].size.width / [[self barButtonArray] count];
    CGFloat height = [self bounds].size.height;
    NSUInteger index = 0;
    for (UIButton *button in [self barButtonArray]) {
        
        CGFloat postionX = index * width;
        CGFloat postionY = 0;
        [button setFrame:CGRectMake(postionX, postionY, width, height)];
        
        index++;
    }
    
}

@end
