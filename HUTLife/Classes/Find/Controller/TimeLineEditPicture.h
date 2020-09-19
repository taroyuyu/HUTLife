//
//  TimeLineEditPicture.h
//  HUTLife
//
//  Created by Lingyu on 16/3/9.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeLineEditPicture;

@protocol TimeLineEditPictureDelegate <NSObject>
@optional
-(void)timeLineEditPictureDidNeedNewPicture:(TimeLineEditPicture*)timeLineEditPicture;
-(void)timeLineEditDidInsertImage:(TimeLineEditPicture*)timeLineEditPicture;
-(void)timeLineEdit:(TimeLineEditPicture*)timeLineEditPicture didSelectedImage:(UIImage*)image;
@end

@interface TimeLineEditPicture : UIView
@property(nonatomic,strong)NSObject<TimeLineEditPictureDelegate>* delegate;
@property(nonatomic,readonly)NSArray<UIImage*> *imageArray;
-(void)insertNewImage:(UIImage*)newImage;
@end
