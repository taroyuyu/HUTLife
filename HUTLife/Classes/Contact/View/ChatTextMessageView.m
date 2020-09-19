//
//  ChatTextMessageView.m
//  HUTLife
//
//  Created by Lingyu on 16/4/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ChatTextMessageView.h"

@interface ChatTextMessageView ()
@property(nonatomic,strong)UILabel *textMessageLabel;
@end

@implementation ChatTextMessageView

static CGFloat interval = 12;
static UIFont *textFont;
static UIColor *textColor;

+(void)initialize
{
    textFont = [UIFont systemFontOfSize:17];
    textColor = [UIColor blackColor];
}

//根据textMessage和最大宽度返回ChatTextMessageView的bounds属性
+(CGRect)needRectWithtextMessage:(NSString*)textMessage andMaxWidth:(CGFloat)maxWidth
{
    maxWidth -= 2 * interval;//textMessageLabel的maxWidth
    
    CGFloat maxHeight = CGFLOAT_MAX;
    
    CGRect textMessageLabelNeedBounds = [textMessage boundingRectWithSize:CGSizeMake(maxWidth, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor} context:nil];
    
    CGRect needBounds = CGRectMake(0, 0, textMessageLabelNeedBounds.size.width + 2 * interval, textMessageLabelNeedBounds.size.height + 2 * interval);
    
    
    return needBounds;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:[self textMessageLabel]];
    }
    
    return self;
}

-(UILabel*)textMessageLabel
{
    if (self->_textMessageLabel) {
        return self->_textMessageLabel;
    }
    
    self->_textMessageLabel = [UILabel new];
    [self->_textMessageLabel setNumberOfLines:0];
    [self->_textMessageLabel setFont:textFont];
    [self->_textMessageLabel setTextColor:textColor];
    
    return self->_textMessageLabel;
}

-(void)setTextMessage:(NSString *)textMessage
{
    self->_textMessage = [textMessage copy];
    
    [[self textMessageLabel] setText:[self textMessage]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = [self bounds].size;
    
    //布局textMessageLabel
    CGFloat textMessageLabelMarginTop = interval/2;
    CGFloat textMessageLabelMarginLeft = interval;
    CGFloat textMessageLabelWidth = contentSize.width - 2 * interval;
    CGFloat textMessageLabelHeight = contentSize.height - 2 * interval;
    [[self textMessageLabel] setFrame:CGRectMake(textMessageLabelMarginLeft, textMessageLabelMarginTop, textMessageLabelWidth, textMessageLabelHeight)];
}



@end
