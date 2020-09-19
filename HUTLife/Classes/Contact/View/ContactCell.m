//
//  ContactCell.m
//  HUTLife
//
//  Created by Lingyu on 16/4/6.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "ContactCell.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "HUTManager.h"

@interface ContactCell ()
@property(nonatomic,strong)UIImageView *userAvator;
@property(nonatomic,strong)UILabel *userName;
@end

@implementation ContactCell


+(instancetype)cellWithTableView:(UITableView *)tableView andModel:(XMPPUserCoreDataStorageObject *)model
{
    
    static NSString *contactsCellIdentifier = @"contactsCell";
    ContactCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:contactsCellIdentifier];
    
    if (nil==contactsCell) {
        contactsCell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactsCellIdentifier];
    }
    
    [contactsCell setModel:model];
    return contactsCell;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadSubviews];
    }
    
    return self;
}

-(void)loadSubviews
{
    [self addSubview:[self userAvator]];
    [self addSubview:[self userName]];
}

-(UIImageView*)userAvator
{
    if (self->_userAvator) {
        return self->_userAvator;
    }
    
    self->_userAvator = [UIImageView new];
    [self->_userAvator setBounds:CGRectMake(0, 0, 40, 40)];
    [[self->_userAvator layer] setCornerRadius:20];
    [self->_userAvator setClipsToBounds:YES];
    
    return self->_userAvator;
}

-(UILabel*)userName
{
    if (self->_userName) {
        return self->_userName;
    }
    
    self->_userName = [UILabel new];
    
    return self->_userName;
}

-(void)loadModelInfo
{
    //获取Model的电子名片
   XMPPvCardTemp *modelVCard =  [[HUTManager sharedHUTManager] friendvCardTempWithAccount:[[self model] jid]];
    
    [[self userAvator] setImage:[UIImage imageWithData:[modelVCard photo]]];
    
    if ([[modelVCard nickname] isNotEmpty]) {
        [[self userName] setText:[modelVCard nickname]];
    }else{
        [[self userName] setText:[[self model] jidStr]];
    }
    
    [self setNeedsDisplay];
}

-(void)setModel:(XMPPUserCoreDataStorageObject *)model
{
    self->_model = model;
    
    [self loadModelInfo];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat interval = 10;
    
    
    CGSize contentSize = [self bounds].size;
    //布局userAvator
    CGSize avatorSize = [[self userAvator] bounds].size;
    [[self userAvator] setCenter:CGPointMake(avatorSize.width/2 + interval, contentSize.height/2)];
    
    //布局userName
    [[self userName] sizeToFit];
    CGRect userNameFrame = [[self userName] frame];
    CGFloat userNamePostionX = CGRectGetMaxX([[self userAvator] frame]) + interval;
    CGFloat userNamePostionY = contentSize.height/2 - userNameFrame.size.height/2;
    [[self userName] setFrame:CGRectMake(userNamePostionX,userNamePostionY, userNameFrame.size.width, userNameFrame.size.height)];
    
}



@end
