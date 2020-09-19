//
//  ChatTextMessageCell.m
//  HUTLife
//
//  Created by Lingyu on 16/4/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ChatTextMessageCell.h"
#import "ChatTextMessageView.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "HUTManager.h"
@interface ChatTextMessageCell ()
@property(nonatomic,strong)UIImageView *avatorView;
@property(nonatomic,strong)ChatTextMessageView *textMessageView;
@end

@implementation ChatTextMessageCell
static CGFloat interval = 5;
static CGFloat avatorViewWidth = 40;
//根据ChatTextMessageModel和最大宽度返回ChatTextMessageCell的rowHeight属性
+(CGFloat)rowHeightWithtextMessage:(XMPPMessageArchiving_Message_CoreDataObject*)model andMaxWidth:(CGFloat)maxWidth;
{
    NSString *textMessage = [model body];
    //计算avator
    CGFloat avatorViewMarginTop = interval;
    CGFloat avatorViewMarginLeft = interval;
    CGSize avatorViewSize = CGSizeMake(avatorViewWidth, avatorViewWidth);
    CGRect avatorViewFrame = CGRectMake(avatorViewMarginLeft, avatorViewMarginTop, avatorViewSize.width, avatorViewSize.height);
    
    //计算textMessageView
    CGFloat textMessageLabelMarginTop = interval;
    CGFloat textMessageLabelMarginLeft = CGRectGetMaxX(avatorViewFrame) + interval;
    CGFloat textMessageLabelMaxWidth = maxWidth - textMessageLabelMarginLeft - interval;
    
    CGRect textMessageLabelNeedBounds = [ChatTextMessageView needRectWithtextMessage:textMessage andMaxWidth:textMessageLabelMaxWidth];
    CGFloat textMessageLabelWidth = textMessageLabelNeedBounds.size.width;
    CGFloat textMessageLabelHeight = textMessageLabelNeedBounds.size.height;
    CGRect textMessageLabelFrame = CGRectMake(textMessageLabelMarginLeft, textMessageLabelMarginTop, textMessageLabelWidth, textMessageLabelHeight);
    
    CGFloat rowHeight = CGRectGetMaxY(textMessageLabelFrame) + interval;
    
    return rowHeight;
    
}
+(instancetype)textMessageCellWithTableView:(UITableView*)tableView andModel:(XMPPMessageArchiving_Message_CoreDataObject*)model
{
    static NSString *textMessageCellIdentifier = @"textMessageCell";
    
    ChatTextMessageCell *textMessageCell = [tableView dequeueReusableCellWithIdentifier:textMessageCellIdentifier];
    
    if (nil==textMessageCell) {
        textMessageCell = [[ChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textMessageCellIdentifier];
    }
    [textMessageCell setModel:model];
    
    return textMessageCell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadSubviews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}


-(void)loadSubviews
{
    [self addSubview:[self avatorView]];
    [self addSubview:[self textMessageView]];
}

-(void)setType:(ChatTextMessageCellType)type
{
    self->_type = type;
    
    //更新textMessageView的背景颜色
    switch (type) {
        case ChatTextMessageCellTypeSend:
            [self->_textMessageView setImage:[UIImage imageNamed:@"SenderTextNodeBkg"]];
            [self->_textMessageView setHighlightedImage:[UIImage imageNamed:@"SenderTextNodeBkgHL"]];
            break;
        case ChatTextMessageCellTypeReceived:
            [self->_textMessageView setImage:[UIImage imageNamed:@"ReceiverTextNodeBkg"]];
            break;
    }
}

-(void)setModel:(XMPPMessageArchiving_Message_CoreDataObject *)model
{
    self->_model = model;
    [self loadModelInfo];
}

-(UIImageView*)avatorView
{
    if (self->_avatorView) {
        return self->_avatorView;
    }
    
    self->_avatorView = [UIImageView new];
    [self->_avatorView setBounds:CGRectMake(0, 0, avatorViewWidth, avatorViewWidth)];
    [[self->_avatorView layer] setCornerRadius:avatorViewWidth/2];
    [self->_avatorView setClipsToBounds:YES];
    
    return self->_avatorView;
}

-(ChatTextMessageView*)textMessageView
{
    if (self->_textMessageView) {
        return self->_textMessageView;
    }
    
    self->_textMessageView = [ChatTextMessageView new];
    return self->_textMessageView;
}

-(void)loadModelInfo
{
    if ([[self model] isOutgoing]) {
        [self setType:ChatTextMessageCellTypeSend];
    }else{
        [self setType:ChatTextMessageCellTypeReceived];
    }
    
    
    switch ([self type]) {
        case ChatTextMessageCellTypeSend:
            [[self avatorView]setImage:[UIImage imageWithData:[[[HUTManager sharedHUTManager] friendvCardTempWithAccount:[XMPPJID jidWithString:[[HUTManager sharedHUTManager] hutLifeAccount]]] photo]]];
            break;
        case ChatTextMessageCellTypeReceived:
            [[self avatorView]setImage:[UIImage imageWithData:[[[HUTManager sharedHUTManager] friendvCardTempWithAccount:[[self model] bareJid]] photo]]];
            break;
    }

    
    [[self textMessageView] setTextMessage:[[self model] body]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = [self bounds].size;
    
    //根据type进行布局
    
    switch (_type) {
        case ChatTextMessageCellTypeSend:
        {
            //布局avator
            CGFloat avatorViewMarginTop = interval;
            CGFloat avatorViewMarginRight = interval;
            CGSize avatorViewSize = [[self avatorView] bounds].size;
            [[self avatorView] setFrame:CGRectMake(contentSize.width-avatorViewMarginRight-avatorViewSize.width, avatorViewMarginTop, avatorViewSize.width, avatorViewSize.height)];
            
            //布局textMessageView
            CGFloat textMessageLabelMarginTop = interval;
            CGFloat textMessageLabelMaxWidth = contentSize.width - avatorViewSize.width - 3 * interval;
            CGRect textMessageLabelNeedBounds = [ChatTextMessageView needRectWithtextMessage:[[self textMessageView] textMessage] andMaxWidth:textMessageLabelMaxWidth];
            CGFloat textMessageLabelWidth = textMessageLabelNeedBounds.size.width;
            CGFloat textMessageLabelHeight = textMessageLabelNeedBounds.size.height;
            CGFloat textMessageLabelMarginLeft = contentSize.width - (avatorViewSize.width + avatorViewMarginRight + interval + textMessageLabelWidth);
            [[self textMessageView] setFrame:CGRectMake(textMessageLabelMarginLeft, textMessageLabelMarginTop, textMessageLabelWidth, textMessageLabelHeight)];
        }
            break;
        case ChatTextMessageCellTypeReceived:
        {
            //布局avator
            CGFloat avatorViewMarginTop = interval;
            CGFloat avatorViewMarginLeft = interval;
            CGSize avatorViewSize = [[self avatorView] bounds].size;
            [[self avatorView] setFrame:CGRectMake(avatorViewMarginLeft, avatorViewMarginTop, avatorViewSize.width, avatorViewSize.height)];
            
            //布局textMessageView
            CGFloat textMessageLabelMarginTop = interval;
            CGFloat textMessageLabelMarginLeft = CGRectGetMaxX([[self avatorView] frame]) + interval;
            CGFloat textMessageLabelMaxWidth = contentSize.width - textMessageLabelMarginLeft - interval;
            CGRect textMessageLabelNeedBounds = [ChatTextMessageView needRectWithtextMessage:[[self textMessageView] textMessage] andMaxWidth:textMessageLabelMaxWidth];
            CGFloat textMessageLabelWidth = textMessageLabelNeedBounds.size.width;
            CGFloat textMessageLabelHeight = textMessageLabelNeedBounds.size.height;
            [[self textMessageView] setFrame:CGRectMake(textMessageLabelMarginLeft, textMessageLabelMarginTop, textMessageLabelWidth, textMessageLabelHeight)];
            
        }
            break;
    }
    
}

@end
