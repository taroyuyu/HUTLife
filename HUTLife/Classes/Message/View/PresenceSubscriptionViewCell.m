//
//  PresenceSubscriptionViewCell.m
//  HUTLife
//
//  Created by Lingyu on 16/4/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "PresenceSubscriptionViewCell.h"
#import "XMPPPresence.h"
#import "HUTManager.h"

@interface PresenceSubscriptionViewCell ()
@property(nonatomic,strong)UIImageView *avatarView;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UIButton *allowSubscriptionButton;
@end

@implementation PresenceSubscriptionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addSubview:[self avatarView]];
        [self addSubview:[self nickNameLabel]];
        [self addSubview:[self allowSubscriptionButton]];
    }
    
    return self;
}

-(UIImageView*)avatarView
{
    if (self->_avatarView) {
        return self->_avatarView;
    }
    
    self->_avatarView = [UIImageView new];
    CGFloat avatarViewWidth = 40;
    [self->_avatarView setBounds:CGRectMake(0, 0, avatarViewWidth, avatarViewWidth)];
    [[self->_avatarView layer] setCornerRadius:avatarViewWidth/2];
    [self->_avatarView setClipsToBounds:YES];
    
    return self->_avatarView;
}

-(UILabel*)nickNameLabel
{
    if (self->_nickNameLabel) {
        return self->_nickNameLabel;
    }
    
    self->_nickNameLabel = [UILabel new];
    
    return self->_nickNameLabel;
}

-(UIButton*)allowSubscriptionButton
{
    if (self->_allowSubscriptionButton) {
        return self->_allowSubscriptionButton;
    }
    
    self->_allowSubscriptionButton = [UIButton new];
    [self->_allowSubscriptionButton setTitle:@"同意" forState:UIControlStateNormal];
    [self->_allowSubscriptionButton setTitle:@"已同意" forState:UIControlStateSelected];
    [self->_allowSubscriptionButton setTitle:@"不同意" forState:UIControlStateDisabled];
    [self->_allowSubscriptionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_allowSubscriptionButton setBounds:CGRectMake(0, 0, 80, 30)];
    [[self->_allowSubscriptionButton layer] setBorderWidth:2];
    [[self->_allowSubscriptionButton layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [self->_allowSubscriptionButton addTarget:self action:@selector(allowSubscriptionButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    return self->_allowSubscriptionButton;
}

-(void)allowSubscriptionButtonDidClicked
{
    if ([[self delegate] respondsToSelector:@selector(subscriptionViewCellDidClickedButton:)]) {
        [[self delegate] subscriptionViewCellDidClickedButton:self];
    }
}

-(void)setModel:(XMPPPresence *)model
{
    self->_model = model;
    
    [self loadModelInfo];
}

-(void)loadModelInfo
{
    XMPPvCardTemp *vCard = [[HUTManager sharedHUTManager] friendvCardTempWithAccount:[[self model] from]];
    UIImage *avatarImage = [UIImage imageWithData:[vCard photo]];
    
    [[self avatarView] setImage:avatarImage];
    
    if ([vCard nickname]) {
        NSLog(@"nickName = %@",[vCard nickname]);
        [[self nickNameLabel] setText:[vCard nickname]];
    }else{
        NSLog(@"vCard JID:%@",[vCard jid]);
        [[self nickNameLabel] setText:[[[self model] from] bare]];
    }
    
    [self setNeedsLayout];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = [self bounds].size;
    
    CGFloat interval = 5;
    
    //布局avatarView
    CGSize avatarViewSize = [[self avatarView] bounds].size;
    CGFloat avatarViewCenterX = avatarViewSize.width/2 + interval;
    CGFloat avatarViewCenterY = contentSize.height/2;
    [[self avatarView] setCenter:CGPointMake(avatarViewCenterX, avatarViewCenterY)];
    
    //布局nickNameLabel
    [[self nickNameLabel] sizeToFit];
    CGSize nickNameLabelSize = [[self nickNameLabel] bounds].size;
    CGFloat nickNameLabelMarginLeft =CGRectGetMaxX([[self avatarView] frame]) + interval;
    CGFloat nickNameLabelMarginTop = interval;
    [[self nickNameLabel] setFrame:CGRectMake(nickNameLabelMarginLeft, nickNameLabelMarginTop, nickNameLabelSize.width, nickNameLabelSize.height)];
    
    //布局allowSubscriptionButton
    CGSize allowButtonSize = [[self allowSubscriptionButton] bounds].size;
    CGFloat allowButtonCenterX = contentSize.width - (allowButtonSize.width/2 + interval);
    CGFloat allowButtonCenterY = contentSize.height/2;
    [[self allowSubscriptionButton] setCenter:CGPointMake(allowButtonCenterX, allowButtonCenterY)];
    
}

@end
