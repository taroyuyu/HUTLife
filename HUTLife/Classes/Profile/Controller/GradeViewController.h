//
//  GradeViewController.h
//  HUT
//
//  Created by Lingyu on 16/3/1.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StudentGradeItem;

@interface GradeViewController : UITableViewController
@property(nonatomic,strong)NSArray<StudentGradeItem*> *gradeItemArray;
+(instancetype)gradeController;
@end
