//
//  EmotionTextAttachment.h
//  HUTLife
//
//  Created by Lingyu on 16/3/12.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmotionModel;

@interface EmotionTextAttachment : NSTextAttachment
@property(nonatomic,strong)EmotionModel* model;
@end
