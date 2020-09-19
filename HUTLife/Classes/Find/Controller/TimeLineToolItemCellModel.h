//
//  TimeLineToolItemCellModel.h
//  HUTLife
//
//  Created by Lingyu on 16/3/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLineToolItemCellModel : NSObject
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *value;
-(instancetype)initWithImageName:(NSString*)imageName titleName:(NSString*)titleName andValue:(NSString*)value;
@end
