//
//  TimeLineToolItemCellModel.m
//  HUTLife
//
//  Created by Lingyu on 16/3/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineToolItemCellModel.h"

@implementation TimeLineToolItemCellModel
-(instancetype)initWithImageName:(NSString *)imageName titleName:(NSString *)titleName andValue:(NSString *)value
{
    self = [super init];
    if (self) {
        [self setImageName:imageName];
        [self setTitleName:titleName];
        [self setValue:value];
    }
    
    return self;
}
@end
