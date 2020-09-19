//
//  EmotionModel.m
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "EmotionModel.h"

@implementation EmotionModel

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    EmotionModel *mode = [EmotionModel new];
    [mode setValuesForKeysWithDictionary:dict];
    return mode;
}

+(NSArray<EmotionModel*>*)modelsWithArray:(NSArray<NSDictionary *> *)dictArray
{
    NSMutableArray *models = [NSMutableArray<EmotionModel*> array];
    
    for (NSDictionary *dictItem in dictArray) {
        EmotionModel *modelItem = [self modelWithDict:dictItem];
        [models addObject:modelItem];
    }
    
    return [models copy];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"png :%@ \tchs :%@",[self png],[self chs]];
}

@end
