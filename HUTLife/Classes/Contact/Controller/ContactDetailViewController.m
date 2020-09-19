//
//  ContactDetailViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/4/6.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ChatViewController.h"
#import "ContactDetailHeadView.h"

@interface ContactDetailViewController ()
@property(nonatomic,strong)ContactDetailHeadView *detailHeaderView;
@property(nonatomic,strong)UIButton *chatButton;
@property (nonatomic, strong) UIDynamicAnimator *animator;//物理仿真器
@end

@implementation ContactDetailViewController


+(instancetype)contactDetailControllerWithModel:(XMPPUserCoreDataStorageObject*)model;
{
    ContactDetailViewController *detailController = [[ContactDetailViewController alloc] initWithNibName:nil bundle:nil];
    if (detailController) {
        [detailController setModel:model];
    }
    return detailController;
}

-(UIDynamicAnimator*)animator
{
    if (self->_animator) {
        return self->_animator;
    }
    
    self->_animator = [[UIDynamicAnimator alloc] initWithReferenceView:[self view]];
    
    return self->_animator;
}

-(ContactDetailHeadView*)detailHeaderView
{
    if (self->_detailHeaderView) {
        return self->_detailHeaderView;
    }
    
    CGSize navigationBarSize = CGSizeZero;
    if (![[[self navigationController] navigationBar] isHidden]) {
        navigationBarSize = [[[self navigationController] navigationBar] bounds].size;
    }
    
    CGFloat headerHeight = 200;
    self->_detailHeaderView = [[ContactDetailHeadView alloc] initWithFrame:CGRectMake(0, navigationBarSize.height+0,[[self view] bounds].size.width, headerHeight)];
    
    [self->_detailHeaderView setBackgroundColor:[UIColor colorWithRed:55/255.0 green:189/255.0 blue:255/255.0 alpha:1]];
    
    return self->_detailHeaderView;
}

-(UIButton*)chatButton
{
    if (self->_chatButton) {
        return self->_chatButton;
    }
    
    CGFloat chatButtonWidth = 60;
    self->_chatButton = [UIButton new];
    [self->_chatButton setTitle:@"聊天" forState:UIControlStateNormal];
    [self->_chatButton setBounds:CGRectMake(0, 0,chatButtonWidth, chatButtonWidth)];
    [[self->_chatButton layer] setCornerRadius:chatButtonWidth/2];
    [self->_chatButton setBackgroundColor:[UIColor colorWithRed:150/255.0 green:235/255.0 blue:225/255.0 alpha:1]];
    [self->_chatButton addTarget:self action:@selector(chatbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    return self->_chatButton;
}

-(void)chatbuttonClicked
{
    ChatViewController *chatController = [ChatViewController new];
    [chatController setFrend:[self model]];
    [[self navigationController] pushViewController:chatController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"详细资料"];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:[self detailHeaderView]];
    [[self view] addSubview:[self chatButton]];
    [self loadModeInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    [[self chatButton] setFrame:CGRectMake([[self view] bounds].size.width, [[self view] bounds].size.height, [[self chatButton] bounds].size.width, [[self chatButton] bounds].size.height)];
    
    //使用UIDynamic框架使得chatButton蹦上去
    
    // 把此前的行为清除掉
    [self.animator removeAllBehaviors];
    
    CGFloat chatButtonMarginBottom = 20;
    
    CGFloat chatButtonCenterY = [[self view] bounds].size.height - [[self chatButton] bounds].size.height/2  - chatButtonMarginBottom;
    
    CGPoint chatButtonCenter = CGPointMake([[self view] bounds].size.width/2, chatButtonCenterY );
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:[self chatButton] snapToPoint:chatButtonCenter];
    
    snap.damping = arc4random_uniform(5) / 10 + 0.3;
    
    // 把行为添加到仿真者中
    [self.animator addBehavior:snap];

}

-(void)loadModeInfo
{
    [[self detailHeaderView] setModel:[self model]];
}

@end
