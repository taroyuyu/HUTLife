//
//  MessageListViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/3/7.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "MessageListViewController.h"
#import "PresenceSubscriptionListViewController.h"
#import "ChatViewController.h"
#import "MessageViewCell.h"
#import "HUTManager.h"
#import "MessageViewModel.h"
#import "XMPPPresence.H"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"

NSString * const messageViewCellIdentifier = @"messageViewCell";

NSString * const presenceSubscripntionKey = @"PresenceSubscripntionKey";

@interface MessageListViewController ()
@property(nonatomic,strong)NSMutableDictionary<NSString*,MessageViewModel*> *messageDictionary;
@property(nonatomic,strong)NSMutableArray<MessageViewModel*> *messageArray;
@property(nonatomic,strong)NSMutableSet<MessageViewModel*> *needPromptMessageSet;
@end

@implementation MessageListViewController

+(instancetype)messageListController
{
    return [[MessageListViewController alloc] initWithStyle:UITableViewStylePlain];
}

-(NSMutableDictionary<NSString*,MessageViewModel*>*)messageDictionary
{
    if (self->_messageDictionary) {
        return self->_messageDictionary;
    }
    
    self->_messageDictionary = [NSMutableDictionary<NSString*,MessageViewModel*> dictionary];
    
    return self->_messageDictionary;
}

-(NSMutableArray<MessageViewModel*>*)messageArray
{
    if (self->_messageArray) {
        return self->_messageArray;
    }
    
    self->_messageArray = [NSMutableArray<MessageViewModel*> array];
    
    return self->_messageArray;
}

-(NSMutableSet<MessageViewModel*>*)needPromptMessageSet
{
    if (self->_needPromptMessageSet) {
        return self->_needPromptMessageSet;
    }
    
    self->_needPromptMessageSet = [NSMutableSet<MessageViewModel*> set];
    
    return self->_needPromptMessageSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息"];
    [[self tableView] setRowHeight:72];
    
    //注册MessageViewCell
    [[self tableView] registerClass:[MessageViewCell class] forCellReuseIdentifier:messageViewCellIdentifier];
    
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hutManagerReceivedMessage:) name:HUTManagerDidReceiveMessageNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hutManagerReceivedNewPresenceSubscrition) name:HUTManagerDidReceivePresenceSubscriptionRequestNotificationName object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self hutManagerReceivedNewPresenceSubscrition];
}

-(void)hutManagerReceivedMessage:(NSNotification*)notification
{
    NSString *sendrJID = [[notification userInfo] objectForKey:@"senderJID"];
    
    NSString *messageContent = [[notification userInfo] objectForKey:@"messageContent"];
    
    //vCard
    XMPPvCardTemp *friendvCardTemp = [[HUTManager sharedHUTManager] friendvCardTempWithAccount:[XMPPJID jidWithString:sendrJID]];
    
    MessageViewModel *messageModel = [[self messageDictionary] objectForKey:sendrJID];
    
    if (nil == messageModel) {//不存在
        messageModel = [MessageViewModel new];
        
        [messageModel setSenderJID:sendrJID];
        
        [messageModel setBadgeImage:[UIImage imageWithData:[friendvCardTemp photo]]];
        
        if ([[friendvCardTemp nickname] isNotEmpty]) {
            [messageModel setTitle:[friendvCardTemp nickname]];
        }else{
            [messageModel setTitle:sendrJID];
        }
        
        [messageModel setPlayload:sendrJID];
        
        [messageModel setPlayloadType:MessageViewModelPlayloadTyepMessage];
        
        
        [[self messageDictionary] setObject:messageModel forKey:[messageModel senderJID]];//添加到字典中
        
        [[self messageArray] insertObject:messageModel atIndex:0];//添加到数组中
    
    }else{//存在
        [[self messageArray] removeObject:messageModel];
        [[self messageArray] insertObject:messageModel atIndex:0];//添加到数组中

    }
    
    [[self tableView] reloadData];
    
    [[self needPromptMessageSet] addObject:messageModel];
    
    //显示徽章
    NSInteger messageCount = [[self needPromptMessageSet] count];
    
    if (messageCount>0) {
        [[[self navigationController]tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
    }else{
        [[[self navigationController]tabBarItem] setBadgeValue:nil];
    }
    
}


-(void)hutManagerReceivedNewPresenceSubscrition
{
    //获取好友订阅请求
    NSArray<XMPPPresence*> *presenceSubscriptionArray = [[HUTManager sharedHUTManager] getAllPresenceSubscriptionRequest];
    
    
    MessageViewModel *presenceSubscriptionMessageModel = [[self messageDictionary] objectForKey:presenceSubscripntionKey];
    
    if (nil==presenceSubscriptionMessageModel) {
        NSLog(@"创建");
        presenceSubscriptionMessageModel = [MessageViewModel new];
        [presenceSubscriptionMessageModel setSenderJID:presenceSubscripntionKey];
        [presenceSubscriptionMessageModel setBadgeImage:[UIImage imageNamed:@"aio_buddy_validate_icon"]];
        [presenceSubscriptionMessageModel setTitle:@"好友请求"];
        [presenceSubscriptionMessageModel setPlayloadType:MessageViewModelPlayloadTypePresenceSubscription];
    }
    
    if ([presenceSubscriptionArray count] > 0) {
        //有处理的好友请求
        
        
        XMPPvCardTemp *friendvCardTemp = [[HUTManager sharedHUTManager] friendvCardTempWithAccount:[[presenceSubscriptionArray lastObject] from]];
        
        if ([[friendvCardTemp nickname] isNotEmpty]) {
            [presenceSubscriptionMessageModel setPrompt:[NSString stringWithFormat:@"%@请求添加你为好友",[friendvCardTemp nickname]]];
        }else{
            [presenceSubscriptionMessageModel setPrompt:[NSString stringWithFormat:@"%@请求添加你为好友",[[presenceSubscriptionArray lastObject] from]]];
        }
        
        [presenceSubscriptionMessageModel setPlayload:presenceSubscriptionArray];
        [[self messageDictionary] setObject:presenceSubscriptionMessageModel forKey:[presenceSubscriptionMessageModel senderJID]];
        [[self messageArray] removeObject:presenceSubscriptionMessageModel];
        [[self messageArray] insertObject:presenceSubscriptionMessageModel atIndex:0];
        
        
        
        [[self needPromptMessageSet] addObject:presenceSubscriptionMessageModel];
    }
    
    [[self tableView] reloadData];
    
    //显示徽章
    NSInteger messageCount = [[self needPromptMessageSet] count];
    
    
    if (messageCount>0) {
        [[[self navigationController]tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
    }else{
        [[[self navigationController]tabBarItem] setBadgeValue:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self messageArray] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageViewCellIdentifier forIndexPath:indexPath];
    MessageViewModel *messageModel = [[self messageArray] objectAtIndex:[indexPath row]];
    if ([messageModel playloadType] == MessageViewModelPlayloadTyepMessage) {
        [messageModel setPrompt:[[[HUTManager sharedHUTManager] getLastedMessageWithFriend:[XMPPJID jidWithString:[messageModel senderJID]]] body]];
    }
    [cell setModel:messageModel];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewModel *model = [[self messageArray] objectAtIndex:[indexPath row]];
    
    [[self needPromptMessageSet] removeObject:model];
    //显示徽章
    NSInteger messageCount = [[self needPromptMessageSet] count];
    
    
    if (messageCount>0) {
        [[[self navigationController]tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
    }else{
        [[[self navigationController]tabBarItem] setBadgeValue:nil];
    }

    switch ([model playloadType]) {
        case MessageViewModelPlayloadTyepMessage:
        {
            ChatViewController *chatController = [ChatViewController new];
            XMPPUserCoreDataStorageObject *friendModel = [[HUTManager sharedHUTManager] friendModelWithAccount:[XMPPJID jidWithString:(NSString*)[model playload]]];
            [chatController setFrend:friendModel];
            [[self navigationController] pushViewController:chatController animated:YES];
        }
            break;
        case MessageViewModelPlayloadTypePresenceSubscription:
        {
            PresenceSubscriptionListViewController *subscriptionListViewController = [PresenceSubscriptionListViewController new];
            [subscriptionListViewController setPresenceSubscriptionArray:(NSArray<XMPPPresence*>*)[model playload]];
            [[self navigationController] pushViewController:subscriptionListViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray<UITableViewRowAction*> *rowActionArray = [NSMutableArray<UITableViewRowAction*> array];
    
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MessageViewModel *messageModel = [(MessageViewCell*)[tableView cellForRowAtIndexPath:indexPath] model];
        
        //从messageArray中移除
        [[self messageArray] removeObject:messageModel];
        //从messageDictionary中移除
        [[self messageDictionary] removeObjectForKey:[messageModel senderJID]];
        //从needPromptMessageSet移除
        [[self needPromptMessageSet]removeObject:messageModel];
        
        //显示徽章
        NSInteger messageCount = [[self needPromptMessageSet] count];
        
        
        if (messageCount>0) {
            [[[self navigationController]tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
        }else{
            [[[self navigationController]tabBarItem] setBadgeValue:nil];
        }

        
        [tableView reloadData];
    }];
    
    [rowActionArray addObject:deleAction];
    
    return rowActionArray;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
