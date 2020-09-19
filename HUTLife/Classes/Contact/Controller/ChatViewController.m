//
//  ChatViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/4/7.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ChatViewController.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "ChatToolBar.h"
#import "HUTManager.h"
#import "ChatTextMessageCell.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,ChatToolBarDelegate,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)UITableView *chatView;
@property(nonatomic,strong)ChatToolBar *toolBar;
@property(nonatomic,strong)NSMutableArray<ChatMessageModel*> *messageArray;
@end

@implementation ChatViewController
{
    NSFetchedResultsController *_messageStorageController;
}

-(ChatToolBar*)toolBar
{
    if (self->_toolBar) {
        return self->_toolBar;
    }
    CGFloat toolBarHeight = 42;
    self->_toolBar = [[ChatToolBar alloc] initWithFrame:CGRectMake(0, [[self view] bounds].size.height-toolBarHeight, [[self view] bounds].size.width, toolBarHeight)];
    [self->_toolBar setDelegate:self];
    return self->_toolBar;
}

-(UITableView*)chatView
{
    if (self->_chatView) {
        return self->_chatView;
    }
    
    CGFloat chatViewWidth = [[self view] bounds].size.width;
    CGFloat chatViewHeight = [[self view] bounds].size.height - [[self toolBar] bounds].size.height;
    
    self->_chatView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, chatViewWidth, chatViewHeight) style:UITableViewStylePlain];
    
    [self->_chatView setDelegate:self];
    [self->_chatView setDataSource:self];
    [self->_chatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    if (![[[self navigationController] navigationBar] isHidden]) {
        [self->_chatView setBounds:CGRectMake(0, -[[[self navigationController] navigationBar] bounds].size.height, chatViewWidth, chatViewHeight)];
    }
    
    return self->_chatView;
}


-(void)chatToolBar:(ChatToolBar*)toolBar didUserInputText:(NSString*)text
{
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[[self frend] jid]];
    // 设置内容
    [message addBody:text];
    [[HUTManager sharedHUTManager] sendChatMessage:message];
    [toolBar clearTextInput];
}

-(NSMutableArray<ChatMessageModel*>*)messageArray
{
    if (self->_messageArray) {
        return self->_messageArray;
    }
    
    self->_messageArray = [NSMutableArray<ChatMessageModel*> array];
    
    return self->_messageArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    XMPPvCardTemp *vCard = [[HUTManager sharedHUTManager] friendvCardTempWithAccount:[[self frend] jid]];
    
    //设置title
    if ([[vCard nickname] isNotEmpty]) {
        [[self navigationItem] setTitle:[vCard nickname]];
    }else{
        [[self navigationItem] setTitle:[[self frend] jidStr]];
    }
    //填充view
    [[self view] addSubview:[self chatView]];
    [[self view] addSubview:[self toolBar]];
    
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangedFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //加载消息
    [self loadMessage];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self chatViewScrollToEnd];
}

-(void)loadMessage
{
    // 上下文
    NSManagedObjectContext *context = [HUTManager sharedHUTManager].hutXMPPMessageStorage.mainThreadManagedObjectContext;
    // 设置查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
        // 设置条件
        // 1.当前登录用户的JID的消息
        // 2.好友的Jid的消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[[HUTManager sharedHUTManager] hutLifeAccount],[[self.frend jid] bare]];
    request.predicate = pre;
    
        //3.按时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 查询
    if (nil==_messageStorageController) {
        _messageStorageController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        NSError *err = nil;
        [_messageStorageController performFetch:&err];
        // 代理
        _messageStorageController.delegate = self;
    }
    
}


#pragma mark ResultController的代理
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 刷新数据
    [self.chatView reloadData];
    [self chatViewScrollToEnd];
}


-(void)keyBoardWillChangedFrame:(NSNotification*)notification
{
    CGRect keyboardFrameEnd = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat changedHeight = [[UIScreen mainScreen] bounds].size.height - keyboardFrameEnd.origin.y;
    
    [[self view] setBounds:CGRectMake(0, changedHeight, [[self view] bounds].size.width, [[self view] bounds].size.height)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self->_messageStorageController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *messageModel =  _messageStorageController.fetchedObjects[indexPath.row];
    
    ChatTextMessageCell *messageCell = [ChatTextMessageCell textMessageCellWithTableView:tableView andModel:messageModel];
    
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *messageModel =  _messageStorageController.fetchedObjects[indexPath.row];
    
    return [ChatTextMessageCell rowHeightWithtextMessage:messageModel andMaxWidth:[tableView bounds].size.width];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[self toolBar] resignFirstResponder];
}

-(void)chatViewScrollToEnd
{
    if ([[_messageStorageController fetchedObjects] count] > 0) {
        [[self chatView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[_messageStorageController fetchedObjects] count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
