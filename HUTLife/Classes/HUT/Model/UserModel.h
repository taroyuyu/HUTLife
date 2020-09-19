//
//  UserModel.h
//  HUT
//
//  Created by Lingyu on 16/1/26.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
/**
 *学号
 */
@property(nonatomic,copy)NSString *studentID;
/**
 *姓名
 */
@property(nonatomic,copy)NSString *name;
/**
 *性别。YES代表男，NO代表女
 */
@property(nonatomic,assign)BOOL sex;
/**
 *入学时间
 */
@property(nonatomic,strong)NSDate *enrollmentDate;
/**
 *出生日期
 */
@property(nonatomic,strong)NSDate *birthDate;

/**
 *高中
 */
@property(nonatomic,copy)NSString *middleSchool;
/**
 *籍贯
 */
@property(nonatomic,copy)NSString *homeTown;
/**
 *身份证
 */
@property(nonatomic,copy)NSString *identity;
/**
 *学院
 */
@property(nonatomic,copy)NSString *college;
/**
 *班级
 */
@property(nonatomic,copy)NSString *className;
/**
 *专业
 */
@property(nonatomic,copy)NSString *major;
@end
