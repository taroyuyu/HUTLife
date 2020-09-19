//
//  TimeLineViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/27.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineViewController.h"
#import "NewTimeLineViewController.h"
#import "HUTManager.h"
#import "TimeLineCell.h"

@interface TimeLineViewController ()
@property(nonatomic,strong)UIBarButtonItem *addTimeLineButtonItem;
@property(nonatomic,strong)NSMutableArray<TimeLineModel*> *timeLineModels;
@end

@implementation TimeLineViewController

+(instancetype)timeLineController
{
    return [TimeLineViewController new];
}

-(UIBarButtonItem*)addTimeLineButtonItem
{
    if (self->_addTimeLineButtonItem) {
        return self->_addTimeLineButtonItem;
    }
    
    self->_addTimeLineButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTimeLineButtonItemClicked:)];
    
    return self->_addTimeLineButtonItem;
}

-(void)addTimeLineButtonItemClicked:(UIBarButtonItem*)item
{
    [[self navigationController] pushViewController:[NewTimeLineViewController newTimeLineController] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self navigationItem] setTitle:@"时间线"];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[[[self navigationController] navigationBar] tintColor]}];
    
    [[self navigationItem] setRightBarButtonItem:[self addTimeLineButtonItem]];
    
    [[HUTManager sharedHUTManager] refreshNewTimeLineWithSuccess:^(NSArray<TimeLineModel *> *modeArray) {
        NSLog(@"modeArray %@",[modeArray firstObject]);
        [[self timeLineModels] addObjectsFromArray:modeArray];
        [[self tableView] reloadData];
    } andFailure:nil];
}

-(NSMutableArray<TimeLineModel*>*)timeLineModels
{
    if (self->_timeLineModels) {
        return self->_timeLineModels;
    }
    
    self->_timeLineModels = [NSMutableArray<TimeLineModel*> array];
    
    return self->_timeLineModels;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self timeLineModels] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TimeLineCell timeLineCellWithTableView:tableView andModel:[[self timeLineModels] objectAtIndex:indexPath.row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TimeLineCell cellHighetWitableTableView:tableView andModel:[[self timeLineModels] objectAtIndex:[indexPath row]]];
}

@end
