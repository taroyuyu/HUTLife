//
//  NewTimeLineViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/27.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "NewTimeLineViewController.h"
#import "TimeLineEditCell.h"
#import "TimeLineToolItemCellModel.h"
#import "TimeLineToolItemCell.h"

@interface NewTimeLineViewController ()<TimeLineEditCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIBarButtonItem *cancleBarButtonItem;
@property(nonatomic,strong)UIBarButtonItem *doneBarButtonItem;
@property(nonatomic,strong)NSArray<TimeLineToolItemCellModel*> *toolSectionModel;
@property(nonatomic,strong)TimeLineEditCell *editCell;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@end

@implementation NewTimeLineViewController

+(instancetype)newTimeLineController
{
    return [[NewTimeLineViewController alloc] initWithStyle:UITableViewStyleGrouped];
}

-(UIBarButtonItem*)cancleBarButtonItem
{
    if (self->_cancleBarButtonItem) {
        return self->_cancleBarButtonItem;
    }
    
    self->_cancleBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBarButtonItemClicked)];
    
    return self->_cancleBarButtonItem;
}

-(void)cancleBarButtonItemClicked
{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(UIBarButtonItem*)doneBarButtonItem
{
    if (self->_doneBarButtonItem) {
        return self->_doneBarButtonItem;
    }
    
    self->_doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarbuttonItemClicked)];
    [self->_doneBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateDisabled];
    [self->_doneBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateNormal];
    [self->_doneBarButtonItem setEnabled:NO];
    return self->_doneBarButtonItem;
}

-(void)doneBarbuttonItemClicked
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setLeftBarButtonItem:[self cancleBarButtonItem]];
    [[self navigationItem] setRightBarButtonItem:[self doneBarButtonItem]];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCellTextDidChanegd:) name:TimeLineEditTextDidChangedNotification object:[self editCell]];
    
}

-(void)editCellTextDidChanegd:(NSNotification*)notification
{
    [[self doneBarButtonItem] setEnabled:![[self editCell] isEmpty]];
}

-(TimeLineEditCell*)editCell
{
    if (self->_editCell) {
        return self->_editCell;
    }
    
    self->_editCell = [TimeLineEditCell cell];
    [self->_editCell setDelegate:self];
    [self->_editCell setPlaceholder:@"这一刻的想法"];
    return self->_editCell;
}

-(UIImagePickerController*)imagePicker
{
    if (self->_imagePicker) {
        return self->_imagePicker;
    }
    
    self->_imagePicker = [UIImagePickerController new];
    [self->_imagePicker setDelegate:self];
    return self->_imagePicker;
}

-(void)showImagePicker
{
    
    UIAlertController *sourceTypeAlertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:[self imagePicker] animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:[self imagePicker] animated:YES completion:nil];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sourceTypeAlertController addAction:albumAction];
    [sourceTypeAlertController addAction:cameraAction];
    [sourceTypeAlertController addAction:cancleAction];
    
    [self presentViewController:sourceTypeAlertController animated:YES completion:nil];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[self editCell] insertNewImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)timeLineEditCellNeedNewPicture:(TimeLineEditCell*)timeLineEditCell
{
    [self showImagePicker];
}

-(void)timeLineEditCellDidInsertImage:(TimeLineEditCell *)timeLineEditCell
{
    [[self tableView] reloadData];
}

-(void)timeLineEditCell:(TimeLineEditCell *)timeLineEditCell didSelectedImage:(UIImage *)image
{
    
}

-(NSArray<TimeLineToolItemCellModel*>*)toolSectionModel
{
    if (self->_toolSectionModel) {
        return self->_toolSectionModel;
    }
    
    NSMutableArray<TimeLineToolItemCellModel*> *modelArray = [NSMutableArray<TimeLineToolItemCellModel*> array];
    [modelArray addObject:[[TimeLineToolItemCellModel alloc] initWithImageName:@"ShareCard_LocationIcon" titleName:@"所在位置" andValue:nil]];
    [modelArray addObject:[[TimeLineToolItemCellModel alloc] initWithImageName:@"AlbumGroupIcon" titleName:@"谁可以看" andValue:@"公开"]];
    self->_toolSectionModel = modelArray;
    
    return self->_toolSectionModel;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        //第一部分
        return 1;
    }else{
        //第二部分
        return [[self toolSectionModel] count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        //第一部分
        
        return [self editCell];
        
        
    }else{
        //第二部分
        return [TimeLineToolItemCell celllWithModel:[[self toolSectionModel] objectAtIndex:indexPath.row]];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //第一部分
        return [[self editCell] bounds].size.height;
    }else{
        //第二部分
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        //第一部分
        return 0.5;
    }else
    {
        return 20;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
