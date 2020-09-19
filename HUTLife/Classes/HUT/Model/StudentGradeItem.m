//
//  StudentGradeItem.m
//  HUT
//
//  Created by Lingyu on 16/3/1.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "StudentGradeItem.h"

@implementation StudentGradeItem
{
    NSDictionary *modelDict;
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self->modelDict = dict;
    }
    return self;
}

-(NSString*)schoolYear
{
    return [self->modelDict objectForKey:@"学年"];
}

-(NSString*)term
{
    return [self->modelDict objectForKey:@"学期"];
}

-(NSString*)courseID
{
    return [self->modelDict objectForKey:@"课程代码"];
}

-(NSString*)courseName
{
    return [self->modelDict objectForKey:@"课程名称"];
}

-(NSString*)courseNatureName
{
    return [self->modelDict objectForKey:@"课程性质"];
}

-(NSString*)courseTypeName
{
    return [self->modelDict objectForKey:@"课程归属"];
}

-(NSString*)creditHour
{
    return [self->modelDict objectForKey:@"学分"];
}

-(NSString*)courseGrade
{
    return [self->modelDict objectForKey:@"成绩"];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"学年:%@\t学期:%@\t课程代码:%@\t课程名称:%@\t课程性质:%@\t课程归属:%@\t学分:%@\t成绩:%@\n",[self schoolYear],[self term],[self courseID],[self courseName],[self courseNatureName],[self courseTypeName],[self creditHour],[self courseGrade]];
}
@end
