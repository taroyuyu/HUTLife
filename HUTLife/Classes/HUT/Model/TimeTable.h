//
//  TimeTable.h
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimeTableItem;

@interface TimeTable : NSObject
@property(nonatomic,copy)NSString* collegeName;
@property(nonatomic,copy)NSString* majorName;
@property(nonatomic,copy)NSString* className;
@property(nonatomic,copy)NSString* grade;
@property(nonatomic,assign)int term;
@property(nonatomic,copy)NSString* termYear;
@property(nonatomic,strong)NSArray<TimeTableItem*>* tableItems;
+(instancetype)titmeTableWithDictionaries:(NSArray*)dictionaries;
@end
