//
//  GradeOverHeaderView.m
//  HUTLife
//
//  Created by Lingyu on 16/3/11.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "GradeOverHeaderView.h"
#import "StudentGradeItem.h"

@interface GradeOverHeaderView ()
@property (strong, nonatomic)  UIImageView *statuImageView;
@property (strong, nonatomic)  UILabel *gradeLabel;
@property (strong, nonatomic)  UILabel *courseNameLabel;
@property (nonatomic,strong)UIButton *backgroundButton;
@end

@implementation GradeOverHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadSubviews];
    }
    
    return self;
}


-(UIButton*)backgroundButton
{
    if (self->_backgroundButton) {
        return self->_backgroundButton;
    }
    
    self->_backgroundButton = [UIButton new];
    [self->_backgroundButton addTarget:self action:@selector(userClicked:) forControlEvents:UIControlEventTouchUpInside];
    return self->_backgroundButton;
}

-(UIImageView*)statuImageView
{
    if (self->_statuImageView) {
        return self->_statuImageView;
    }
    
    self->_statuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"]];
    [self->_statuImageView sizeToFit];
    
    return self->_statuImageView;
}

-(UILabel*)gradeLabel
{
    if (self->_gradeLabel) {
        return self->_gradeLabel;
    }
    
    self->_gradeLabel = [UILabel new];
    
    return self->_gradeLabel;
}

-(UILabel*)courseNameLabel
{
    if (self->_courseNameLabel) {
        return self->_courseNameLabel;
    }
    
    self->_courseNameLabel = [UILabel new];
    
    return self->_courseNameLabel;
}

-(void)loadSubviews
{
    [self addSubview:[self backgroundButton]];
    [self addSubview:[self statuImageView]];
    [self addSubview:[self gradeLabel]];
    [self addSubview:[self courseNameLabel]];
}

-(void)setModel:(StudentGradeItem *)model
{
    self->_model = model;
    [self loadModelInfo];
}

-(void)loadModelInfo
{
    [[self courseNameLabel] setText:[[self model] courseName]];
    [[self gradeLabel] setText:[[self model] courseGrade]];
    
}

- (void)userClicked:(UIButton *)sender {
    
    if ([self delegate]) {
        [[self delegate]gradeOverViewDidClicked:self];
    }else{
        NSLog(@"%@ delegate为nil",[self class]);
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize selfSize = [self bounds].size;
    
    
    CGFloat interval = 10;
    
    //布局backgroundButton
    [[self backgroundButton] setFrame:[self bounds]];
    
    //布局statusImageView
    CGSize statusImageViewSize = CGSizeMake(15, 15);
    [[self statuImageView] setBounds:CGRectMake(0, 0, statusImageViewSize.width, statusImageViewSize.height)];
    [[self statuImageView] setCenter:CGPointMake(interval+statusImageViewSize.width/2, selfSize.height/2)];
    
    //布局gradeLabel
    CGSize gradeLabelSize = CGSizeMake(40, 21);
    [[self gradeLabel] setBounds:CGRectMake(0, 0, gradeLabelSize.width, gradeLabelSize.height)];
    [[self gradeLabel] setCenter:CGPointMake(selfSize.width - interval - statusImageViewSize.width/2, selfSize.height/2)];
    
    //布局courseNamelLabel
    CGSize courseNameLabelSize = CGSizeMake(selfSize.width - CGRectGetMaxX([[self statuImageView] frame]) - 2 * interval - gradeLabelSize.width - interval, 21);
    [[self courseNameLabel] setFrame:CGRectMake(CGRectGetMaxX([[self statuImageView] frame]) + interval, (selfSize.height - courseNameLabelSize.height)/2 , courseNameLabelSize.width, courseNameLabelSize.height)];
    
    
}


@end
