//
//  TimeTableItem.h
//  HUT
//
//  Created by Lingyu on 16/2/16.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    /**不区分单双周*/
    CourseFlageCommon,
    /**单周*/
    CourseFlagSingle,
    /**双周*/
    CourseFlageDouble,
} CourseFlag;

@interface TimeTableItem : NSObject
@property(nonatomic,copy)NSString* courseName;
@property(nonatomic,copy)NSString* courseTeacher;
@property(nonatomic,copy)NSString* coursePlace;
@property(nonatomic,assign)int courseFrom;
@property(nonatomic,assign)int courseTo;
@property(nonatomic,assign)CourseFlag courseFlag;
@property(nonatomic,assign)int courseDay;
@property(nonatomic,strong)NSArray<NSNumber*>* courseTime;
+(instancetype)timeTableItemWithDictionary:(NSDictionary*)dictionary;
-(BOOL)isNeedShownInWeekIndex:(NSInteger)weekIndex;
@end
