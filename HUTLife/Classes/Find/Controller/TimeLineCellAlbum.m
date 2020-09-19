//
//  TimeLineCellAlbum.m
//  HUTLife
//
//  Created by Lingyu on 16/3/13.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineCellAlbum.h"

typedef enum : NSUInteger {
    PictureLayoutSchemeNone,//没有图片
    PictureLayoutSchemeFirst,//只有一个图片
    PictureLayoutSchemeSecond,//奇数个
    PictureLayoutSchemeThird,//偶数个
} PictureLayoutScheme;

@implementation TimeLineCellAlbum
{
    NSMutableArray<UIButton*> *pictureButtonArray;
}

+(CGSize)needSizeWithMaxWidth:(CGFloat)maxWidth pictureArray:(NSArray<UIImage*>*)pictureArray
{
    NSUInteger pictureCount = [pictureArray count];

    CGFloat minWidth = 80;
    CGFloat minHeight = minWidth;
    CGFloat interval = 4;
    
    NSInteger columnCount = (maxWidth + interval) / (minWidth + interval);
    NSInteger rowCount = pictureCount / columnCount + 1;
    CGFloat eachWidth = (maxWidth - interval * (columnCount -1))/columnCount;
    CGFloat eachHeight = eachWidth;
    
    CGSize needSize = CGSizeZero;
    
    for (NSUInteger index = 0; index < [pictureArray count]; ++index) {
        
        NSInteger column = index % columnCount;
        NSInteger row = index / columnCount;
        CGFloat postionX = column * (eachWidth + interval);
        CGFloat postionY = row * (eachHeight + interval);
        
        CGFloat width = postionX + eachWidth;
        CGFloat height = postionX + eachHeight;
        
        needSize.width = (needSize.width > width)?needSize.width : width;
        needSize.height = (needSize.height > height)?needSize.height : height;
        
    }
    
    return needSize;

}
+(instancetype)album
{
    TimeLineCellAlbum *cellAlbum = [TimeLineCellAlbum new];
    return cellAlbum;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self->pictureButtonArray = [NSMutableArray<UIButton*> array];
    }
    
    return self;
}


-(void)setPictureArray:(NSArray<UIImage *> *)pictureArray
{
    self->_pictureArray = pictureArray;
    
    //更新pictureButtonArray和subView
    NSUInteger currentCount = [self->pictureButtonArray count];
    NSInteger needCount = [[self pictureArray] count];
    
    if (needCount > currentCount) {//需要增加
        NSInteger increaseCount = needCount - currentCount;
        for (NSInteger index = 0; index < increaseCount; ++index) {
            UIButton *pictureButton = [UIButton new];
            [self addSubview:pictureButton];//将新的PictureButton添加到subView中
            [self->pictureButtonArray addObject:pictureButton];
        }
    }else if (currentCount > needCount){//需要减少
        NSInteger reduceCount = currentCount - needCount;
        for (NSInteger index = 0; index < reduceCount; ++index) {
            UIButton *lastPictureButton = [self->pictureButtonArray lastObject];
            [lastPictureButton removeFromSuperview];
            [self->pictureButtonArray removeLastObject];//将lastPictureButton移除
        }
    }
    
    //加载图片
    [self loadPicture];
    
}

//加载图片
-(void)loadPicture
{
    NSInteger index = 0;
    for (UIButton *pictureButtonItem in self->pictureButtonArray) {
        [pictureButtonItem setBackgroundImage:[[self pictureArray] objectAtIndex:index] forState:UIControlStateNormal];
        index++;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize selfSize = [self bounds].size;
    
    NSUInteger pictureCount = [self->pictureButtonArray count];

    CGFloat minWidth = 80;
    CGFloat minHeight = minWidth;
    CGFloat interval = 4;
    NSInteger columnCount = (selfSize.width + interval) / (minWidth + interval);
    NSInteger rowCount = pictureCount / columnCount + 1;
    CGFloat eachWidth = (selfSize.width - interval * (columnCount -1))/columnCount;
    CGFloat eachHeight = eachWidth;
    NSUInteger index = 0;
    for (UIView *viewItem in [self subviews]) {
        
        NSInteger column = index % columnCount;
        NSInteger row = index / columnCount;
        CGFloat postionX = column * (eachWidth + interval);
        CGFloat postionY = row * (eachHeight + interval);
        [viewItem setFrame:CGRectMake(postionX, postionY, eachWidth, eachHeight)];
        
        index++;
    }

}


@end
