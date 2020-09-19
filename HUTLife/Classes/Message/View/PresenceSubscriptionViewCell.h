//
//  PresenceSubscriptionViewCell.h
//  HUTLife
//
//  Created by Lingyu on 16/4/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPPresence;
@class PresenceSubscriptionViewCell;

@protocol PresenceSubscriptionViewCellDelegate <NSObject>

@optional
-(void)subscriptionViewCellDidClickedButton:(PresenceSubscriptionViewCell*)subscripntionCell;

@end

@interface PresenceSubscriptionViewCell : UITableViewCell
@property(nonatomic,strong)XMPPPresence *model;
@property(nonatomic,strong)NSObject<PresenceSubscriptionViewCellDelegate> *delegate;
@end
