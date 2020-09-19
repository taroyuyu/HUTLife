//
//  TimeLineEditInputView.m
//  HUTLife
//
//  Created by Lingyu on 16/3/9.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineEditInputView.h"

@interface TimeLineEditInputView ()

@end


@implementation TimeLineEditInputView

-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfTextDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    self->_placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self isEmpty]) {
        [[self placeholder] drawAtPoint:CGPointMake(5, 7) withAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    }
    
}

//判断是否有文字
-(BOOL)isEmpty
{
    if ([self text] && ![[self text] isEqualToString:@""]) {
        //self text 不为空
        return false;
    }else if([[self attributedText] length] > 0)
    {
        return false;
    }
    
    return true;
}
/**
 *插入带属性的文字
 */
-(void)insertAttributedText:(NSAttributedString *)attributedText
{
    
    NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedText]];
    
    //获取当前光标的位置
    NSRange currentSelectedRange = [self selectedRange];
    
    if (currentSelectedRange.length > 0) {
        //有内容被选中
        [newAttributedString replaceCharactersInRange:currentSelectedRange withAttributedString:attributedText];
    }else{
        [newAttributedString insertAttributedString:attributedText atIndex:currentSelectedRange.location];
    }
    [self setAttributedText:newAttributedString];
    
    //将光标移动
    currentSelectedRange.location += [attributedText length];
    [self setSelectedRange:currentSelectedRange];
    
    [self setNeedsDisplay];
}
/**
 *删除文字(带属性的文字)
 */
-(void)deleText
{
    [self deleteBackward];
}

-(void)selfTextDidChanged
{
    [self setNeedsDisplay];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
