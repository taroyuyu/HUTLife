//
//  UserModel.m
//  HUT
//
//  Created by Lingyu on 16/1/26.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(NSString*)description
{
    return [NSString stringWithFormat:@"姓名:%@ 学号:%@ 生日:%@",self.name,self.studentID,self.birthDate];
}
@end
