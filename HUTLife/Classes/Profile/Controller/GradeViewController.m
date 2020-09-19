//
//  GradeViewController.m
//  HUT
//
//  Created by Lingyu on 16/3/1.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "GradeViewController.h"
#import "StudentGradeItem.h"
#import "GradeViewCell.h"
#import "GradeOverHeaderView.h"
@interface GradeViewController ()<GradeOverViewDelegate>
@property(nonatomic,strong)NSMutableArray<NSNumber*> *sectionPackedArray;
@end

@implementation GradeViewController

+(instancetype)gradeController
{
    
    return [GradeViewController new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"成绩"];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [[self tableView] setRowHeight:140];
    [[self tableView] setSectionHeaderHeight:44];
}

-(NSMutableArray<NSNumber*>*)sectionPackedArray
{
    if (self->_sectionPackedArray) {
        return self->_sectionPackedArray;
    }
    NSMutableArray<NSNumber*> *packedArray = [NSMutableArray<NSNumber*> array];
    for (int index = 0; index < [[self gradeItemArray] count]; ++index) {
        NSNumber *boolValue = [[NSNumber alloc] initWithBool:false];
        [packedArray addObject:boolValue];
    }
    self->_sectionPackedArray = packedArray;
    return self->_sectionPackedArray;
}

-(void)setGradeItemArray:(NSArray<StudentGradeItem *> *)gradeItemArray
{
    self->_gradeItemArray = gradeItemArray;
    
    [[self tableView] reloadData];
    
}


-(void)gradeOverViewDidClicked:(GradeOverHeaderView*)gradeOverView
{
    NSNumber *oldValue = [[self sectionPackedArray] objectAtIndex:[gradeOverView tag]];
    
    NSNumber *newValue = [[NSNumber alloc] initWithBool:![oldValue boolValue]];
    [[self sectionPackedArray] replaceObjectAtIndex:[gradeOverView tag] withObject:newValue];
    
    [[self tableView] reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self gradeItemArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *boolValue = [[self sectionPackedArray] objectAtIndex:section];
    
    return [boolValue boolValue] ? 1 : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"gradeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell = [GradeViewCell cell];
    }
    
    StudentGradeItem *gradeItemModel = [[self gradeItemArray] objectAtIndex:[indexPath section]];
    
    
    [(GradeViewCell*)cell setModel:gradeItemModel];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *resuidentfier = @"headerView";
    
    GradeOverHeaderView *headerView = (GradeOverHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:resuidentfier];
    
    if (headerView==nil) {
        headerView = [[GradeOverHeaderView alloc] initWithReuseIdentifier:resuidentfier];
    }
    [headerView setModel:[[self gradeItemArray] objectAtIndex:section]];
    [headerView setDelegate:self];
    [headerView setTag:section];
    
    return headerView;
}

@end
