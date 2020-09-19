//
//  ContactListViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/3/7.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactCell.h"
#import "HUTManager.h"
#import "ContactDetailViewController.h"
#import "AddContactViewController.h"
#import "XMPPUserCoreDataStorageObject.h"

@interface ContactListViewController ()
@property(nonatomic,strong)NSArray<XMPPUserCoreDataStorageObject*> *contactList;
@property(nonatomic,strong)UIBarButtonItem *addFriendBarButtonItem;
@end

@implementation ContactListViewController
{
    NSArray<XMPPUserCoreDataStorageObject*> *_contactList;
}
+(instancetype)contactListController
{
    return [[ContactListViewController alloc] initWithStyle:UITableViewStylePlain];
}

-(NSArray<XMPPUserCoreDataStorageObject*> *)contactList
{
    if (self->_contactList) {
        return self->_contactList;
    }
    
    self->_contactList = [NSArray<XMPPUserCoreDataStorageObject*> array];
    
    return self->_contactList;
}

-(void)setContactList:(NSArray<XMPPUserCoreDataStorageObject *> *)contactList
{
    self->_contactList = [contactList copy];
    [[self tableView] reloadData];
}

-(UIBarButtonItem*)addFriendBarButtonItem
{
    if (self->_addFriendBarButtonItem) {
        return self->_addFriendBarButtonItem;
    }
    
    self->_addFriendBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendBarButtonDidClicked)];
    
    return self->_addFriendBarButtonItem;
}

-(void)addFriendBarButtonDidClicked
{
    [[self navigationController] pushViewController:[AddContactViewController new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"通讯录"];
    [[self tableView] setRowHeight:60];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self navigationItem] setRightBarButtonItem:[self addFriendBarButtonItem]];
    
    [self setContactList:[[HUTManager sharedHUTManager] fetchFriendList]];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendListDidChanged) name:HUTManagerDidFriendListChangedNotificationName object:nil];
}

-(void)friendListDidChanged
{
    [self setContactList:[[HUTManager sharedHUTManager] fetchFriendList]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self contactList] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMPPUserCoreDataStorageObject *contactModel = [[self contactList] objectAtIndex:[indexPath row]];
    
    ContactCell *cell = [ContactCell cellWithTableView:tableView andModel:contactModel];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *model = [(ContactCell*)[tableView cellForRowAtIndexPath:indexPath]model];
    ContactDetailViewController *detailController = [ContactDetailViewController contactDetailControllerWithModel:model];
    [[self navigationController] pushViewController:detailController animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray<UITableViewRowAction*> *rowActionArray = [NSMutableArray<UITableViewRowAction*> array];
    
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        XMPPUserCoreDataStorageObject *friendModel = [(ContactCell*)[tableView cellForRowAtIndexPath:indexPath] model];
        [[HUTManager sharedHUTManager] deleteFriend:friendModel];
    }];
    
    [rowActionArray addObject:deleAction];
    
    return rowActionArray;
    
}

@end
