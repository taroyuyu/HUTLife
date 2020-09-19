//
//  ChatTextMessageCell.h
//  HUTLife
//
//  Created by Lingyu on 16/4/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ChatTextMessageCellTypeSend,//由当前用户发出
    ChatTextMessageCellTypeReceived,//由当前用户接受
} ChatTextMessageCellType;
@class XMPPMessageArchiving_Message_CoreDataObject;
@interface ChatTextMessageCell : UITableViewCell
@property(nonatomic,strong)XMPPMessageArchiving_Message_CoreDataObject *model;
@property(nonatomic,assign)ChatTextMessageCellType type;
//根据ChatTextMessageModel和最大宽度返回ChatTextMessageCell的rowHeight属性
+(CGFloat)rowHeightWithtextMessage:(XMPPMessageArchiving_Message_CoreDataObject*)model andMaxWidth:(CGFloat)maxWidth;
+(instancetype)textMessageCellWithTableView:(UITableView*)tableView andModel:(XMPPMessageArchiving_Message_CoreDataObject*)model;
@end
