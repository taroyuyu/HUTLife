//
//  EmotionKeyBoard.m
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "EmotionKeyBoard.h"
#import "EmotionToolBar.h"
#import "EmotionListView.h"
#import "EmotionModel.h"


NSString *const EmotionKeyBoardDidSelectedNotification = @"EmotionKeyBoardDidSelectedNotification";
NSString *const EmotionKeyBoardDeleButtonClcikedNotification = @"EmotionKeyBoardDeleButtonClcikedNotification";
NSString *const EmotionKeyBoardSelectedEmotionModel = @"EmotionKeyBoardSelectedEmotionName";

@interface EmotionKeyBoard ()<EmotionToolBarDeleaget,EmotionListViewDelegate>
@property(nonatomic,strong)EmotionToolBar *toolBar;
@property(nonatomic,strong)NSArray<EmotionListView*> *emotionLisrViewArray;
@property(nonatomic,strong)EmotionListView *selectedEmotionLisrtView;
@property(nonatomic,readonly)NSMutableArray<EmotionModel*> *recentlyEmotionModelArray;
@end

@implementation EmotionKeyBoard
{
    NSMutableArray<EmotionModel*> *_recentlyEmotionModelArray;
    NSMutableArray<NSDictionary*> *_recentlyEmotionDictArray;
    EmotionListView *recentEmotionlistView;
}

static CGFloat keyBoardHeight;
static CGFloat keyBoardWidth;

+(void)initialize
{
    keyBoardHeight = 216;
    keyBoardWidth = [[[UIApplication sharedApplication] keyWindow] bounds].size.width;
}

+(instancetype)keyBoard
{
    return [self new];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBounds:CGRectMake(0, 0, keyBoardWidth, keyBoardHeight)];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]]];
        [self loadSubviews];
        [self setSelectedEmotionListViewType:[[self toolBar] selectedType]];
    }
    return self;
}

-(void)setSelectedEmotionListViewType:(BarButtonType)type
{
    [self setSelectedEmotionLisrtView:[[self emotionLisrViewArray] objectAtIndex:type]];
}

-(void)loadSubviews
{
    [self addSubview:[self toolBar]];
    [self setSelectedEmotionLisrtView:[[self emotionLisrViewArray] firstObject]];
}

-(EmotionToolBar*)toolBar
{
    if (self->_toolBar) {
        return self->_toolBar;
    }

    self->_toolBar = [EmotionToolBar toolBar];
    [self->_toolBar setDelegate:self];
    
    return self->_toolBar;
}

-(NSString*)recentlyEmotionDictFile
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"recentlyEmotionDictFile"];
}

-(NSMutableArray<NSDictionary*>*)recentlyEmotionDictArray
{
    if (self->_recentlyEmotionDictArray) {
        return self->_recentlyEmotionDictArray;
    }
    
    self->_recentlyEmotionDictArray = [[NSMutableArray<NSDictionary*> alloc] initWithContentsOfFile:[self recentlyEmotionDictFile]];
    
    if (self->_recentlyEmotionDictArray==nil) {
        self->_recentlyEmotionDictArray = [NSMutableArray<NSDictionary *> array];
    }
    
    return self->_recentlyEmotionDictArray;
}

-(NSMutableArray<EmotionModel*>*)recentlyEmotionModelArray
{
    self->_recentlyEmotionModelArray = [NSMutableArray<EmotionModel*> array];
    
    [self->_recentlyEmotionModelArray addObjectsFromArray:[EmotionModel modelsWithArray:[self recentlyEmotionDictArray]]];
    
    return self->_recentlyEmotionModelArray;
}


-(void)emotionToolBar:(EmotionToolBar*)toolBar didSelected:(BarButtonType)type
{
    [self setSelectedEmotionListViewType:type];
}

-(void)setSelectedEmotionLisrtView:(EmotionListView *)selectedEmotionLisrtView
{
    [self->_selectedEmotionLisrtView removeFromSuperview];
    
    self->_selectedEmotionLisrtView = selectedEmotionLisrtView;
    
    [self addSubview:[self selectedEmotionLisrtView]];
}

-(NSArray<EmotionListView*>*)emotionLisrViewArray
{
    if (self->_emotionLisrViewArray) {
        return self->_emotionLisrViewArray;
    }
    
    NSMutableArray<EmotionListView*> *listArray = [NSMutableArray<EmotionListView*> array];
    
    //最近
    EmotionListView *recentEmotionListView = [EmotionListView emotionListViewWithModels:[self recentlyEmotionModelArray]];
    [recentEmotionListView setEmotionListViewDelegate:self];
    [listArray addObject:recentEmotionListView];
    self->recentEmotionlistView = recentEmotionListView;
    //默认
    NSString *defaultFilePath = [[NSBundle mainBundle] pathForResource:@"defaultEmotionIcon.plist" ofType:nil];
    NSArray<NSDictionary*> *defaultEmotionDictArray = [NSArray<NSDictionary*> arrayWithContentsOfFile:defaultFilePath];
    EmotionListView *defaultEmotionListView = [EmotionListView emotionListViewWithModels:[EmotionModel modelsWithArray:defaultEmotionDictArray]];
    [defaultEmotionListView setEmotionListViewDelegate:self];
    [listArray addObject:defaultEmotionListView];
    //lxh
    NSString *lxhFilePath = [[NSBundle mainBundle] pathForResource:@"lxhEmotionIcon.plist" ofType:nil];
    NSArray<NSDictionary*> *lxhEmotionDictArray = [NSArray<NSDictionary*> arrayWithContentsOfFile:lxhFilePath];
    EmotionListView *lxhEmotionListView = [EmotionListView emotionListViewWithModels:[EmotionModel modelsWithArray:lxhEmotionDictArray]];
    [lxhEmotionListView setEmotionListViewDelegate:self];
    [listArray addObject:lxhEmotionListView];
    
    self->_emotionLisrViewArray = [listArray copy];
    return self->_emotionLisrViewArray;
}


-(void)emotionListView:(EmotionListView*)listView DidSelected:(EmotionModel*)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionKeyBoardDidSelectedNotification object:self userInfo:@{EmotionKeyBoardSelectedEmotionModel:model}];
    
    [self saveEmotionModel:model];
    
    [self->recentEmotionlistView setModelArray:[self recentlyEmotionModelArray]];
}

/**
 *
 */
-(void)saveEmotionModel:(EmotionModel*)model
{
    NSDictionary *dict = [EmotionKeyBoard emotionModelToDict:model];
    
    NSUInteger index = 0;
    for (NSDictionary *item in [self recentlyEmotionDictArray]) {
        
        if ([[item objectForKey:@"chs"] isEqualToString:[model chs]]) {
            NSDictionary *firstObject = [[self recentlyEmotionDictArray] firstObject];
            [[self recentlyEmotionDictArray] replaceObjectAtIndex:0 withObject:item];
            [[self recentlyEmotionDictArray] replaceObjectAtIndex:index withObject:firstObject];
            return;
        }
        
        index++;
    }
    
    [[self recentlyEmotionDictArray] insertObject:dict atIndex:0];
    
    
    [[self recentlyEmotionDictArray] writeToFile:[self recentlyEmotionDictFile] atomically:YES];
    
}

+(NSDictionary*)emotionModelToDict:(EmotionModel*)model
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if ([model chs]) {
        [dict setObject:[model chs] forKey:@"chs"];
    }
    
    if ([model cht]) {
        [dict setObject:[model cht] forKey:@"cht"];
    }
    
    if ([model gif]) {
        [dict setObject:[model gif] forKey:@"gif"];
    }
    
    if ([model png]) {
        [dict setObject:[model png] forKey:@"png"];
    }
    
    if ([model type]) {
        [dict setObject:[model type] forKey:@"type"];
    }
    
    
    return dict;
}

-(void)emotionListViewDeleButtonClicked:(EmotionListView*)listView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionKeyBoardDeleButtonClcikedNotification object:self];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //布局toolBar
    
    CGFloat toolBarPostionX = 0;
    
    CGFloat toolBarPostionY = [self bounds].size.height - [[self toolBar] bounds].size.height;
    
    [[self toolBar] setFrame:CGRectMake(toolBarPostionX, toolBarPostionY, [[self toolBar] bounds].size.width, [[self toolBar] bounds].size.height)];
 
    //布局listView
    CGFloat listViewPostionX = 0;
    CGFloat listViewPostionY = 0;
    CGFloat listViewPostionHeight = [self bounds].size.height - [[self toolBar] bounds].size.height;
    
    [[self selectedEmotionLisrtView] setFrame:CGRectMake(listViewPostionX, listViewPostionY, [self bounds].size.width, listViewPostionHeight)];
}

@end

