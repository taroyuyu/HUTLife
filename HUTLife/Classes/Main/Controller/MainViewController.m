//
//  MainViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "MainViewController.h"
#import "MessageViewController.h"
#import "ContactViewController.h"
#import "FindViewController.h"
#import "ProfileViewController.h"
#import "HUTManager.h"
@interface MainViewController ()

@end

@implementation MainViewController


/**
 *加载子控制器
 */
-(void)loadChildControllers
{
    [self addChildViewController:[MessageViewController messageController]];
    [self addChildViewController:[ContactViewController contactController]];
    [self addChildViewController:[FindViewController findViewController]];
    [self addChildViewController:[ProfileViewController profileViewController]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self loadChildControllers];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
