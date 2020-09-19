//
//  StudentGradeItem.h
//  HUT
//
//  Created by Lingyu on 16/3/1.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentGradeItem : NSObject
/**
 *学年
 */
@property(nonatomic,readonly)NSString *schoolYear;
/**
 *学期
 */
@property(nonatomic,readonly)NSString *term;
/**
 *课程代码
 */
@property(nonatomic,readonly)NSString *courseID;
/**
 *课程名称
 */
@property(nonatomic,readonly)NSString *courseName;
/**
 *课程性质
 */
@property(nonatomic,readonly)NSString *courseNatureName;
/**
 *课程归属
 */
@property(nonatomic,readonly)NSString *courseTypeName;
/**
 *学分
 */
@property(nonatomic,readonly)NSString *creditHour;
/**
 *成绩
 */
@property(nonatomic,readonly)NSString *courseGrade;
-(instancetype)initWithDict:(NSDictionary*)dict;
@end
