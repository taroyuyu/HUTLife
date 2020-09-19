//
//  EmotionKeyBoard.h
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmotionModel;

/**
 *EmotionKeyBoard选中了表情
 */
extern NSString *const EmotionKeyBoardDidSelectedNotification;
/**
 *EmotionkeyBoard删除按钮被点击
 */
extern NSString *const EmotionKeyBoardDeleButtonClcikedNotification;
/**
 *从通知中获取EmotionModel
 */
extern NSString *const EmotionKeyBoardSelectedEmotionModel;
@interface EmotionKeyBoard : UIView
+(NSDictionary*)emotionModelToDict:(EmotionModel*)model;
+(instancetype)keyBoard;
@end
