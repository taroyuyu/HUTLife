//
//  MessageViewModel.h
//  HUTLife
//
//  Created by Lingyu on 16/4/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

typedef enum : NSUInteger {
    MessageViewModelPlayloadTyepMessage,
    MessageViewModelPlayloadTypePresenceSubscription,
} MessageViewModelPlayloadType;

@interface MessageViewModel : NSObject
@property(nonatomic,strong)UIImage *badgeImage;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *prompt;
@property(nonatomic,strong)NSObject *playload;
@property(nonatomic,assign)MessageViewModelPlayloadType playloadType;
@property(nonatomic,copy)NSString *senderJID;
@end
