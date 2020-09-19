//
//  TimeTable.m
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeTable.h"
#import "TimeTableItem.h"

@implementation TimeTable
+(instancetype)titmeTableWithDictionaries:(NSArray *)dictionaries
{
    TimeTable *timeTable = [TimeTable new];
    
    NSMutableArray<TimeTableItem*>* timeTableItems = [NSMutableArray<TimeTableItem*> new];
    
    for (NSDictionary *itemDictionary in dictionaries) {
        if ([itemDictionary objectForKey:@"courseName"]!=nil) {
            TimeTableItem *item = [TimeTableItem timeTableItemWithDictionary:itemDictionary];
            [timeTableItems addObject:item];
            
        }else if ([itemDictionary objectForKey:@"termYear"]){
            [timeTable setValuesForKeysWithDictionary:itemDictionary];
        }
    }
    
    
    [timeTable setTableItems:timeTableItems];
    
    return timeTable;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"collegeName:%@\tmajorName:%@\tclassName:%@\tgrade:%@\tterm:%d\ttermYear:%@\ttitmeTableItems:\n%@",[self collegeName],[self majorName],[self className],[self grade],[self term],[self termYear],[self tableItems]];
}
@end
