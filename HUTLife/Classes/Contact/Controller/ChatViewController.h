//
//  ChatViewController.h
//  HUTLife
//
//  Created by Lingyu on 16/4/7.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPUserCoreDataStorageObject;

@interface ChatViewController : UIViewController
@property(nonatomic,strong)XMPPUserCoreDataStorageObject *frend;
@end
