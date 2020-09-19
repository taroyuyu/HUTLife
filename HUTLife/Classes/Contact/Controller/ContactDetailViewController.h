//
//  ContactDetailViewController.h
//  HUTLife
//
//  Created by Lingyu on 16/4/6.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPUserCoreDataStorageObject;

@interface ContactDetailViewController : UIViewController
@property(nonatomic,strong)XMPPUserCoreDataStorageObject *model;
+(instancetype)contactDetailControllerWithModel:(XMPPUserCoreDataStorageObject*)model;
@end
