//
//  AddContactViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/4/13.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "AddContactViewController.h"
#import "HUTManager.h"
@interface AddContactViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *searchField;
@property(nonatomic,strong)UIBarButtonItem *addBarButtonItem;
@end

@implementation AddContactViewController


-(UITextField*)searchField
{
    if (self->_searchField) {
        return self->_searchField;
    }
    
    CGFloat interval = 10;
    CGFloat searchFieldMarginLeft = interval;
    CGFloat searchFieldMarginTop = interval + 20;
    CGFloat searchFieldHeight = 42;
    CGFloat searchFieldWidth = [[self view] bounds].size.width - 2 * searchFieldMarginLeft;
    
    
    self->_searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchFieldMarginLeft, searchFieldMarginTop, searchFieldWidth, searchFieldHeight)];
    
    [self->_searchField setPlaceholder:@"请输入联系人帐号"];
    
    [self->_searchField setBorderStyle:UITextBorderStyleBezel];
    
    [self->_searchField setDelegate:self];
    
    
    return self->_searchField;
}

-(UIBarButtonItem*)addBarButtonItem
{
    if (self->_addBarButtonItem) {
        return self->_addBarButtonItem;
    }
    
    self->_addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
    
    return self->_addBarButtonItem;
}

-(void)addFriend
{
    [[HUTManager sharedHUTManager] addFriendWithAccount:[[self searchField] text]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    if ([[[self navigationController] navigationBar] isHidden]==NO) {
        [[self view] setBounds:CGRectMake(0, -[[[self navigationController] navigationBar] bounds].size.height, [[self view] bounds].size.width, [[self view] bounds].size.height)];
    }
    
    [[self navigationItem]setTitle:@"添加联系人"];
    
    [[self navigationItem] setRightBarButtonItem:[self addBarButtonItem]];
    
    [[self view] addSubview:[self searchField]];
}

@end
