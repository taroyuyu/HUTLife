//
//  MessageViewCell.h
//  HUTLife
//
//  Created by Lingyu on 16/4/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageViewModel;

@interface MessageViewCell : UITableViewCell
@property(nonatomic,strong)MessageViewModel *model;
@end
