//
//  TimeLineEditCell.h
//  HUTLife
//
//  Created by Lingyu on 16/3/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const TimeLineEditTextDidChangedNotification;

@class TimeLineEditCell;

@protocol TimeLineEditCellDelegate <NSObject>
@optional
-(void)timeLineEditCellNeedNewPicture:(TimeLineEditCell*)timeLineEditCell;
-(void)timeLineEditCellDidInsertImage:(TimeLineEditCell*)timeLineEditCell;
-(void)timeLineEditCell:(TimeLineEditCell*)timeLineEditCell didSelectedImage:(UIImage*)image;
@end

@interface TimeLineEditCell : UITableViewCell
@property(nonatomic)NSObject<TimeLineEditCellDelegate>* delegate;
@property(nonatomic,readonly)NSArray<UIImage*> *imageArray;
@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,copy)NSString *text;
+(instancetype)cell;
-(void)insertNewImage:(UIImage*)newImage;
//判断是否有文字
-(BOOL)isEmpty;
@end
