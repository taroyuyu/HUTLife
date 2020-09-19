//
//  GradeViewCell.m
//  HUT
//
//  Created by Lingyu on 16/3/1.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "GradeViewCell.h"
#import "StudentGradeItem.h"

@interface GradeViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *courseID;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseNative;
@property (weak, nonatomic) IBOutlet UILabel *creditHour;
@property (weak, nonatomic) IBOutlet UILabel *courseGrade;

@end

@implementation GradeViewCell

+(instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
}

-(void)setModel:(StudentGradeItem *)model
{
    self->_model = model;
    
    [[self courseID] setText:[NSString stringWithFormat:@"课程代码:%@",[model courseID]]];
    [[self courseName] setText:[NSString stringWithFormat:@"课程名称:%@",[model courseName]]];
    [[self courseNative] setText:[NSString stringWithFormat:@"课程性质:%@",[model courseNatureName]]];
    [[self creditHour] setText:[NSString stringWithFormat:@"学分:%@",[model creditHour]]];
    [[self courseGrade] setText:[NSString stringWithFormat:@"成绩:%@",[model courseGrade]]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
