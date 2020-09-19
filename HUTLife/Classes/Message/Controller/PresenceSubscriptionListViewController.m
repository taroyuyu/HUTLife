//
//  PresenceSubscriptionListViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/4/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "PresenceSubscriptionListViewController.h"
#import "PresenceSubscriptionViewCell.h"
#import "XMPPPresence.h"
#import "HUTManager.h"
NSString * const subscriptionCellIdentifier = @"subscriptionCell";

@interface PresenceSubscriptionListViewController ()<PresenceSubscriptionViewCellDelegate>

@end

@implementation PresenceSubscriptionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self navigationItem] setTitle:@"新朋友"];
    
    [[self tableView] setRowHeight:72];
    
    //注册Cell
    [[self tableView] registerClass:[PresenceSubscriptionViewCell class] forCellReuseIdentifier:subscriptionCellIdentifier];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self presenceSubscriptionArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PresenceSubscriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subscriptionCellIdentifier forIndexPath:indexPath];
    
    if ([cell model] == nil) {
        [cell setDelegate:self];
    }
    XMPPPresence *presece = [[self presenceSubscriptionArray] objectAtIndex:[indexPath row]];
    [cell setModel:presece];
    return cell;
}


-(void)subscriptionViewCellDidClickedButton:(PresenceSubscriptionViewCell*)subscripntionCell
{
    XMPPPresence *subscriptionPresence = [subscripntionCell model];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HUTManager sharedHUTManager] acceptFriendSubscription:[subscriptionPresence from]];
    }];
    
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HUTManager sharedHUTManager] rejectFriendSubscription:[subscriptionPresence from]];
    }];
    
    [alertController addAction:allowAction];
    [alertController addAction:rejectAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

@end
