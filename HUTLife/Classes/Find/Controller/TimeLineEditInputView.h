//
//  TimeLineEditInputView.h
//  HUTLife
//
//  Created by Lingyu on 16/3/9.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineEditInputView : UITextView
@property(nonatomic,copy)NSString *placeholder;
/**
 *判断是否有文字
 */
-(BOOL)isEmpty;
-(void)insertAttributedText:(NSAttributedString*)attributedText;
/**
 *删除文字(包括带属性的文字)
 */
-(void)deleText;
@end
