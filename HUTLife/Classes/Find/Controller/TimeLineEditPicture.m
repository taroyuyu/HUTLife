//
//  TimeLineEditPicture.m
//  HUTLife
//
//  Created by Lingyu on 16/3/9.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineEditPicture.h"


@interface TimeLineEditPicture ()
@property(nonatomic,strong)UIButton *addPictureButton;
@property(nonatomic,strong)NSMutableArray<UIButton*> *imageButtonArray;
@end

@implementation TimeLineEditPicture

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:[self addPictureButton]];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self addSubview:[self addPictureButton]];
    }
    
    return self;
}


-(UIButton*)addPictureButton
{
    if (self->_addPictureButton) {
        return self->_addPictureButton;
    }
    self->_addPictureButton = [UIButton new];
    [self->_addPictureButton setBackgroundImage:[UIImage imageNamed:@"AlbumAddPeoplePlus"] forState:UIControlStateNormal];
    [self->_addPictureButton setBackgroundImage:[UIImage imageNamed:@"AlbumAddPeoplePlusHL"] forState:UIControlStateHighlighted];
    [self->_addPictureButton sizeToFit];
    [self->_addPictureButton addTarget:self action:@selector(addPictureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return self->_addPictureButton;
}

-(void)addPictureButtonClicked
{
    if ([self delegate]) {
        [[self delegate] timeLineEditPictureDidNeedNewPicture:self];
    }
}

-(NSMutableArray<UIButton*>*)imageButtonArray
{
    if (self->_imageButtonArray) {
        return self->_imageButtonArray;
    }
    
    self->_imageButtonArray = [NSMutableArray<UIButton*> array];
    
    return self->_imageButtonArray;
}

-(NSArray<UIImage*>*)imageArray
{
    NSMutableArray<UIImage*> *images = [NSMutableArray array];
    
    for (UIButton *itemButton in [self imageButtonArray]) {
        [images addObject:[itemButton backgroundImageForState:UIControlStateNormal]];
    }
    return images;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize buttonSize = [[self addPictureButton] bounds].size;
    CGSize selfSize = [self bounds].size;
    CGFloat minInterval = 10;
    int columnCount = selfSize.width / (buttonSize.width + minInterval);//计算列数
    
    CGFloat interval = minInterval;
    
    [[self imageButtonArray] addObject:[self addPictureButton]];
    
    NSUInteger index = 0;
    
    for (UIButton *itemButton in [self imageButtonArray]) {
        
        CGFloat columnIndex = index % columnCount;
        CGFloat rowIndex = index / columnCount;
        
        CGFloat postionX = columnIndex * (interval + buttonSize.width) + interval;
        CGFloat postionY = rowIndex * (interval + buttonSize.height) + interval;
        
        [itemButton setFrame:CGRectMake(postionX, postionY, buttonSize.width, buttonSize.height)];
        
        index++;
    }
    
    [[self imageButtonArray] removeObject:[self addPictureButton]];
    
    CGFloat maxY = CGRectGetMaxY([[self addPictureButton] frame]) + interval;
    
    
    if (maxY > [self bounds].size.height) {
        
        [self setBounds:CGRectMake(0, 0, selfSize.width, maxY)];
        
        if ([self delegate]) {
            
            [[self delegate] timeLineEditDidInsertImage:self];
        }
    }
}


-(void)insertNewImage:(UIImage*)newImage
{
    NSLog(@"插入新的图片:%@",newImage);
    
    UIButton *newImageButton = [UIButton new];
    [newImageButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [newImageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newImageButton];
    [[self imageButtonArray] addObject:newImageButton];
    [self setNeedsLayout];
}

-(void)imageButtonClicked:(UIButton*)imageButton
{
    if ([self delegate]) {
        [[self delegate] timeLineEdit:self didSelectedImage:[imageButton backgroundImageForState:UIControlStateNormal]];
    }
}

@end
