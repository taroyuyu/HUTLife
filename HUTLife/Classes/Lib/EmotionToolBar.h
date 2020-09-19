//
//  EmotionToolBar.h
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BarButtonTypeRecent,
    BarButtonTypeDefault,
    BarButtonTypeLXH
} BarButtonType;

@class EmotionToolBar;

@protocol EmotionToolBarDeleaget <NSObject>
@optional
-(void)emotionToolBar:(EmotionToolBar*)toolBar didSelected:(BarButtonType)type;
@end

@interface EmotionToolBar : UIView
@property(nonatomic)NSObject<EmotionToolBarDeleaget> *delegate;
+(instancetype)toolBar;
-(BarButtonType)selectedType;
@end
