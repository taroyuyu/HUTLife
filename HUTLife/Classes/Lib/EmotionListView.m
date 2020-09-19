//
//  EmotionListView.m
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionModel.h"

@interface EmotionListView ()
@property(nonatomic,strong)NSArray<EmotionModel*> *modelArray;
@property(nonatomic,strong)NSArray<UIButton*> *emotionButtonArray;
@end

@implementation EmotionListView
{
    NSMutableArray<UIButton*> *deleButtonArray;
}
static CGFloat emotionButtonWidth = 32;
static CGFloat emotionButtonHeight = 32;
+(instancetype)emotionListViewWithModels:(NSArray<EmotionModel*>*)modelsArray
{
    EmotionListView *listView = [self new];
    [listView setModelArray:modelsArray];
    return listView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setBounces:NO];
        [self setPagingEnabled:YES];
    }
    
    return self;
}

-(void)setModelArray:(NSArray<EmotionModel *> *)modelArray
{
    self->_modelArray = modelArray;
    
    [self loadSubviews];
}

-(void)loadSubviews
{
    for (UIButton *button in [self subviews]) {
        [button removeFromSuperview];
    }
    
    NSMutableArray<UIButton*> *buttonArray = [NSMutableArray<UIButton*> array];
    
    NSUInteger index = 0;
    for (EmotionModel *model in [self modelArray]) {
        UIButton *emotionButton = [self emotionButtonWithModel:model];
        [emotionButton setTag:index];
        [emotionButton addTarget:self action:@selector(emotionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emotionButton];
        [buttonArray addObject:emotionButton];
        index++;
    }
    
    [self setEmotionButtonArray:[buttonArray copy]];
    
    [self setNeedsDisplay];
}

-(void)emotionButtonClicked:(UIButton*)emotionButton
{
    
    if ([[self emotionListViewDelegate] respondsToSelector:@selector(emotionListView:DidSelected:)]) {
        [[self emotionListViewDelegate] emotionListView:self DidSelected:[[self modelArray] objectAtIndex:[emotionButton tag]]];
    }
}

-(UIButton*)emotionButtonWithModel:(EmotionModel*)model
{
    UIButton *emotionButton = [UIButton new];
    [emotionButton setBackgroundImage:[UIImage imageNamed:[model png]] forState:UIControlStateNormal];
    [emotionButton setBounds:CGRectMake(0, 0, emotionButtonWidth, emotionButtonHeight)];
    return emotionButton;
}

-(UIButton*)deleButtonWithIndex:(NSUInteger)index
{
    if (self->deleButtonArray==nil) {
        self->deleButtonArray = [NSMutableArray<UIButton*> array];
    }
    
    UIButton *deleButton;
    
    if (index < [self->deleButtonArray count]) {
        deleButton = [self->deleButtonArray objectAtIndex:index];
    }{
        deleButton = [UIButton new];
        [deleButton setBackgroundImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleButton setBackgroundImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleButton setBounds:CGRectMake(0, 0, 36, 32)];
        [deleButton addTarget:self action:@selector(deleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self->deleButtonArray addObject:deleButton];
        [self addSubview:deleButton];
    }
    
    return deleButton;
}

-(void)deleButtonClicked
{
    if ([[self emotionListViewDelegate] respondsToSelector:@selector(emotionListViewDeleButtonClicked:)]) {
        [[self emotionListViewDelegate] emotionListViewDeleButtonClicked:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize selfSize = [self frame].size;
    
    CGFloat minInterval = 5;
    
    int columnCount = (selfSize.width-minInterval) / (minInterval + emotionButtonWidth);
    int rowCount = (selfSize.height - minInterval) / (minInterval + emotionButtonHeight);
    int eachPageCount = columnCount * rowCount - 1;
    NSInteger pageCount = [[self emotionButtonArray] count] / eachPageCount + 1;
    
    CGFloat intervalH = (selfSize.width - columnCount * emotionButtonWidth) / (columnCount + 1);
    CGFloat intervalV = (selfSize.height - rowCount * emotionButtonHeight) / (rowCount + 1);
    
    NSInteger pageIndex = 0;
    
    NSInteger index = 0;
    
    for (UIButton *emotionButton in [self emotionButtonArray]) {
        
        NSInteger column = index % columnCount;
        NSInteger row = index / columnCount;
                            //差值                                        //初始值
        CGFloat centerX = pageIndex * selfSize.width + (emotionButtonWidth + intervalH) * column + (emotionButtonWidth/2 + intervalH) ;
        CGFloat centerY = (emotionButtonHeight + intervalV) * row + (emotionButtonHeight/2 + intervalV) ;
        
        [emotionButton setCenter:CGPointMake(centerX, centerY)];
        
        index++;
        
        if (index == eachPageCount) {
            UIButton *deleButton = [self deleButtonWithIndex:pageIndex];
            CGFloat centerX =  pageIndex * selfSize.width + selfSize.width - (intervalH + emotionButtonWidth /2);
            CGFloat centerY = selfSize.height - (intervalV + emotionButtonHeight / 2);
            [deleButton setCenter:CGPointMake(centerX, centerY)];
            pageIndex++;
            index = 0;
        }

    }
    
    [self setContentSize:CGSizeMake(pageCount * selfSize.width, selfSize.height)];
    
    //在最后一页添加DeleButton
    
    UIButton *deleButton = [self deleButtonWithIndex:pageIndex];
    CGFloat centerX = [self contentSize].width - (intervalH + emotionButtonWidth /2);
    CGFloat centerY = [self contentSize].height - (intervalV + emotionButtonHeight / 2);
    [deleButton setCenter:CGPointMake(centerX, centerY)];
    
}



@end
