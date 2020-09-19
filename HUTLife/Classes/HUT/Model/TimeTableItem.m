//
//  TimeTableItem.m
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeTableItem.h"

@implementation TimeTableItem
+(instancetype)timeTableItemWithDictionary:(NSDictionary*)dictionary
{
    TimeTableItem *item = [TimeTableItem new];
    
    [item setValuesForKeysWithDictionary:dictionary];
    
    return item;
}

-(BOOL)isNeedShownInWeekIndex:(NSInteger)weekIndex
{
    if ([self courseFrom] <= weekIndex && weekIndex <= [self courseTo]) {
        switch ([self courseFlag]) {
            case CourseFlagSingle:
            {
                return weekIndex % 2 == 0 ? NO : YES;
            }
                break;
            case CourseFlageDouble:
            {
                return weekIndex % 2 == 0 ? YES : NO;
            }
                break;
            case CourseFlageCommon:
            {
                return YES;
            }
                break;
        }
    }
    
    return NO;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"courseDay=%d\tcourseFlag=%d\tcourseFrom=%d\tcourseName=%@\tcoursePlace=%@\tcourseTeacher=%@\tcourseTime=%@",[self courseDay],[self courseFlag],[self courseFlag],[self courseName],[self coursePlace],[self courseTeacher],[self courseTime]];
}
@end
