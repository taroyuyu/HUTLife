//
//  TimeLineModel.h
//  HUTLife
//
//  Created by  on 16/3/12.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLineModel : NSObject
/**
 *内容
 */
@property(nonatomic,copy)NSString *content;
/**
 *图片的URL
 */
@property(nonatomic,strong)NSArray<NSString*> *imagesURL;
/**
 *位置
 */
@property(nonatomic,copy)NSString *postion;
/**
 *头像的URL
 */
@property(nonatomic,copy)NSString *headePicture;
/**
 *昵称
 */
@property(nonatomic,copy)NSString *nickName;
+(instancetype)timeLineWithDict:(NSDictionary*)dict;
+(NSArray<TimeLineModel*>*)timeLinesWithDict:(NSArray<NSDictionary*>*)dictArray;
@end
