//
//  EmotionListView.h
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmotionListView;
@class EmotionModel;
@protocol EmotionListViewDelegate <NSObject>
@optional
-(void)emotionListView:(EmotionListView*)listView DidSelected:(EmotionModel*)model;
-(void)emotionListViewDeleButtonClicked:(EmotionListView*)listView;
@end
@interface EmotionListView : UIScrollView;
@property(nonatomic,strong)NSObject<EmotionListViewDelegate> *emotionListViewDelegate;
+(instancetype)emotionListViewWithModels:(NSArray<EmotionModel*>*)modelsArray;

-(void)setModelArray:(NSArray<EmotionModel *> *)modelArray;
@end
