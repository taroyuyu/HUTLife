//
//  TimeLineToolItemCell.m
//  HUTLife
//
//  Created by Lingyu on 16/3/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineToolItemCell.h"
#import "TimeLineToolItemCellModel.h"

@interface TimeLineToolItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation TimeLineToolItemCell

+(instancetype)celllWithModel:(TimeLineToolItemCellModel *)model
{
    TimeLineToolItemCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    if (cell) {
        [cell setModel:model];
    }
    return cell;
}

-(void)setModel:(TimeLineToolItemCellModel *)model
{
    self->_model = model;
    [self loadModelInfo];
    
}

-(void)loadModelInfo
{
    [[self imageView] setImage:[UIImage imageNamed:[[self model] imageName]]];
    [[self titleLabel] setText:[[self model] titleName]];
    [[self valueLabel] setText:[[self model] value]];
}

- (void)awakeFromNib {

    [self loadModelInfo];
}

@end
