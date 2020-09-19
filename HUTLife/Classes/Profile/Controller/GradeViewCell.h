//
//  GradeViewCell.h
//  HUT
//
//  Created by Lingyu on 16/3/1.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StudentGradeItem;

@interface GradeViewCell : UITableViewCell
@property(nonatomic,strong)StudentGradeItem *model;
+(instancetype)cell;
@end
