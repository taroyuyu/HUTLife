//
//  TimeLineCellAlbum.h
//  HUTLife
//
//  Created by Lingyu on 16/3/13.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCellAlbum : UIView
@property(nonatomic,strong)NSArray<UIImage*> *pictureArray;
+(instancetype)album;
+(CGSize)needSizeWithMaxWidth:(CGFloat)maxWidth pictureArray:(NSArray<UIImage*>*)pictureArray;
@end
