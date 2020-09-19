//
//  GradeOverHeaderView.h
//  HUTLife
//
//  Created by Lingyu on 16/3/11.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StudentGradeItem;
@class GradeOverHeaderView;

@protocol GradeOverViewDelegate <NSObject>
-(void)gradeOverViewDidClicked:(GradeOverHeaderView*)gradeOverView;
@end

@interface GradeOverHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)StudentGradeItem *model;
@property(nonatomic,strong)NSObject<GradeOverViewDelegate>* delegate;
@end
