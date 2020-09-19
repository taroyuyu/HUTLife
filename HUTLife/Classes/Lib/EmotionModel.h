//
//  EmotionModel.h
//  HUTLife
//
//  Created by Lingyu on 16/3/10.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmotionModel : NSObject
@property(nonatomic,copy)NSString *chs;
@property(nonatomic,copy)NSString *cht;
@property(nonatomic,copy)NSString *gif;
@property(nonatomic,copy)NSString *png;
@property(nonatomic,copy)NSString *type;
+(instancetype)modelWithDict:(NSDictionary*)dict;
+(NSArray<EmotionModel*>*)modelsWithArray:(NSArray<NSDictionary*>*)dictArray;
@end
