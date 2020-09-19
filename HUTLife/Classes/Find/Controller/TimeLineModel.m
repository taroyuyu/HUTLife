//
//  TimeLineModel.m
//  HUTLife
//
//  Created by Lingyu on 16/3/12.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineModel.h"

@implementation TimeLineModel
+(instancetype)timeLineWithDict:(NSDictionary *)dict
{
    TimeLineModel *model = [self new];
    
    if (model) {
        [model setValuesForKeysWithDictionary:dict];
    }
    
    return model;
}

+(NSArray<TimeLineModel*>*)timeLinesWithDict:(NSArray<NSDictionary *> *)dictArray
{
    NSMutableArray<TimeLineModel*> *array = [NSMutableArray<TimeLineModel*> array];
    
    for (NSDictionary *dictItem in dictArray) {
        TimeLineModel *model = [self timeLineWithDict:dictItem];
        [array addObject:model];
    }
    
    return [array copy];
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"content:\t%@\npostion:\t%@\nimagesURL:\t%@\nheaderPicture:\t%@\nnickName:\t%@\n",[self content],[self postion],[self imagesURL],[self headePicture],[self nickName]];
}
@end
