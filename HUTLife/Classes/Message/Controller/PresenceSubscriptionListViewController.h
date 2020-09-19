//
//  PresenceSubscriptionListViewController.h
//  HUTLife
//
//  Created by Lingyu on 16/4/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPPresence;
@interface PresenceSubscriptionListViewController : UITableViewController
@property(nonatomic,strong)NSArray<XMPPPresence*> *presenceSubscriptionArray;
@end
