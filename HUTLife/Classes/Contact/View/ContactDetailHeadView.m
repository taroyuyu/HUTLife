//
//  ContactDetailHeadView.m
//  HUTLife
//
//  Created by Lingyu on 16/4/7.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ContactDetailHeadView.h"
#import "HUTManager.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPvCardTemp.h"
@interface ContactDetailHeadView ()
@property(nonatomic,strong)UIImageView *avatorPicture;
@property(nonatomic,strong)UILabel *nameLabel;
@end

@implementation ContactDetailHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadSubviews];
    }
    
    return self;
}

-(void)loadSubviews
{
    [self addSubview:[self avatorPicture]];
    [self addSubview:[self nameLabel]];
}

-(UIImageView*)avatorPicture
{
    if (self->_avatorPicture) {
        return self->_avatorPicture;
    }
    
    CGSize avatorSize = CGSizeMake(80, 80);
    
    self->_avatorPicture = [UIImageView new];
    [self->_avatorPicture setBounds:CGRectMake(0, 0, avatorSize.width, avatorSize.height)];
    [[self->_avatorPicture layer] setCornerRadius:avatorSize.width/2];
    
    return self->_avatorPicture;
}

-(UILabel*)nameLabel
{
    if (self->_nameLabel) {
        return self->_nameLabel;
    }
    
    self->_nameLabel = [UILabel new];
    [self->_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self->_nameLabel setTextColor:[UIColor whiteColor]];
    
    return self->_nameLabel;
}


-(void)setModel:(XMPPUserCoreDataStorageObject *)model
{
    self->_model = model;
    [self loadModelInfo];
}

-(void)loadModelInfo
{
    XMPPvCardTemp *vCard = [[HUTManager sharedHUTManager] friendvCardTempWithAccount:[[self model] jid]];
    
    [[self avatorPicture] setImage:[UIImage imageWithData:[vCard photo]]];

    
    if ([[vCard nickname] isNotEmpty]) {
        [[self nameLabel] setText:[vCard nickname]];
    }else{
        [[self nameLabel] setText:[[self model] jidStr]];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = [self bounds].size;
    
    CGFloat interval = 5;
    
    //布局avatorPicture
    [[self avatorPicture] setCenter:CGPointMake(contentSize.width/2, contentSize.height/2)];
    
    //布局nameLabel
    CGFloat nameLabelHeight = 44;
    [[self nameLabel] setFrame:CGRectMake(0, CGRectGetMaxY([[self avatorPicture] frame]) + interval, contentSize.width, nameLabelHeight)];
}

@end
