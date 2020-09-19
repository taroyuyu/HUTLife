//
//  TimeLineToolItemCell.h
//  HUTLife
//
//  Created by Lingyu on 16/3/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeLineToolItemCellModel;

@interface TimeLineToolItemCell : UITableViewCell
@property(nonatomic,strong)TimeLineToolItemCellModel *model;
+(instancetype)celllWithModel:(TimeLineToolItemCellModel*)model;
@end
