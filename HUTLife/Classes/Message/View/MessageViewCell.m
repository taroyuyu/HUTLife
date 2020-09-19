//
//  MessageViewCell.m
//  HUTLife
//
//  Created by Lingyu on 16/4/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "MessageViewCell.h"
#import "MessageViewModel.h"

@interface MessageViewCell ()
@property(nonatomic,strong)UIImageView *badgeView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *promptLabel;
@end

@implementation MessageViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addSubview:[self badgeView]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self promptLabel]];
    }
    
    return self;
}

-(UIImageView*)badgeView
{
    if (self->_badgeView) {
        return self->_badgeView;
    }
    self->_badgeView = [UIImageView new];
    CGSize flagImageViewSize = CGSizeMake(40, 40);
    [self->_badgeView setBounds:CGRectMake(0, 0, flagImageViewSize.width, flagImageViewSize.height)];
    [self->_badgeView setImage:[UIImage imageNamed:@"aio_buddy_validate_icon"]];
    [[self->_badgeView layer]setCornerRadius:flagImageViewSize.width/2];
    [self->_badgeView setClipsToBounds:YES];
    return self->_badgeView;
}

-(UILabel*)titleLabel
{
    if (self->_titleLabel) {
        return self->_titleLabel;
    }
    
    self->_titleLabel = [UILabel new];
    return self->_titleLabel;
}

-(UILabel*)promptLabel
{
    if (self->_promptLabel) {
        return self->_promptLabel;
    }
    
    self->_promptLabel = [UILabel new];
    
    return self->_promptLabel;
}

-(void)setModel:(MessageViewModel *)model
{
    self->_model = model;
    
    [self loadModelInfo];
}

-(void)loadModelInfo
{
    [[self badgeView] setImage:[[self model] badgeImage]];
    [[self titleLabel] setText:[[self model] title]];
    [[self promptLabel] setText:[[self model] prompt]];
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat interval = 10;
    
    CGSize contentSize = [self bounds].size;
    
    //布局flagImageView
    CGSize badgeViewSize = [[self badgeView] bounds].size;
    [[self badgeView] setCenter:CGPointMake(badgeViewSize.width/2 + interval, contentSize.height/2)];
    
    //布局flageLabel
    [[self titleLabel] sizeToFit];
    CGSize titleLaelSize = [[self titleLabel] bounds].size;
    CGFloat flagLabelMarginTop = interval * 1.5;
    CGFloat flagLabelMarginLeft = CGRectGetMaxX([[self badgeView] frame]) + interval;
    [[self titleLabel] setFrame:CGRectMake(flagLabelMarginLeft, flagLabelMarginTop, titleLaelSize.width, titleLaelSize.height)];
    
    //布局promptLael
    [[self promptLabel] sizeToFit];
    CGSize promptLabelSize = [[self promptLabel] bounds].size;
    CGFloat promptLabelMarginLeft = CGRectGetMaxX([[self badgeView] frame]) + interval;
    CGFloat promptLabelMarginTop = CGRectGetMaxY([[self titleLabel] frame]) + interval/2;
    [[self promptLabel] setFrame:CGRectMake(promptLabelMarginLeft, promptLabelMarginTop, promptLabelSize.width, promptLabelSize.height)];
    
}


@end
