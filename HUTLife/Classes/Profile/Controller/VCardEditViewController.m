//
//  VCardEditViewController.m
//  HUTLife
//
//  Created by Lingyu on 16/4/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "VCardEditViewController.h"
#import "XMPPvCardTemp.h"
#import "UIImage+Compress.h"
@interface VCardEditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatorView;
@property (weak, nonatomic) IBOutlet UITextField *nicjNameField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (nonatomic,strong) UIBarButtonItem *saveBarButtonItem;
@end

@implementation VCardEditViewController

+(instancetype)vCardEditController
{
    VCardEditViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vCardEditController"];
    
    return viewController;
}

-(UIBarButtonItem*)saveBarButtonItem
{
    if (self->_saveBarButtonItem) {
        return self->_saveBarButtonItem;
    }
    
    self->_saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(saveBarButtonItemClicked)];
    return self->_saveBarButtonItem;
}

-(void)saveBarButtonItemClicked
{
    [MBProgressHUD showMessage:@"正在保存"];
    
    UIImage *avatarImage = [[self avatorView] backgroundImageForState:UIControlStateNormal];
    avatarImage = [avatarImage compressToSpecialSize:CGSizeMake(60, 60)];
    NSData *avatarData = UIImagePNGRepresentation(avatarImage);
    
    NSString *nickName = [[self nicjNameField] text];
    
    [[self model] setPhoto:avatarData];
    [[self model] setNickname:nickName];
    
    
    [[HUTManager sharedHUTManager] updateUserVCard:[self model] success:^(HUTManager *manager) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"更新成功"];
    } failure:^(HUTManager *manager, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"更新失败"];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"基本信息"];
    
    [[self navigationItem] setRightBarButtonItem:[self saveBarButtonItem]];
    
    [[[self avatorView] layer] setCornerRadius:[[self avatorView] bounds].size.width/2];
    [[self avatorView] setClipsToBounds:YES];
    [[self avatorView] addTarget:self action:@selector(avatorViewClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadModelInfo];
}

-(void)avatorViewClicked
{
    UIAlertController *photoSourcePicker = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [imagePickerController setDelegate:self];
        [imagePickerController setAllowsEditing:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setDelegate:self];
        [imagePickerController setAllowsEditing:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [photoSourcePicker addAction:albumAction];
    [photoSourcePicker addAction:cameraAction];
    [photoSourcePicker addAction:cancleAction];
    [self presentViewController:photoSourcePicker animated:YES completion:^{
        
    }];

}

-(void)loadModelInfo
{
    UIImage *avatarImage = [[UIImage alloc] initWithData:[[self model] photo]];
    if (nil==avatarImage) {
        avatarImage = [UIImage imageNamed:@"normal_avatar"];
    }
    
    [[self avatorView] setBackgroundImage:avatarImage forState:UIControlStateNormal];
    
    [[self nicjNameField] setText:[[self model] nickname]];
    [[self accountField] setText:[[HUTManager sharedHUTManager] hutLifeAccount]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
        [self dismissViewControllerAnimated:YES completion:nil];
        [[self avatorView] setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
