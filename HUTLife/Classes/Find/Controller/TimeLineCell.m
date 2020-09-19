//
//  TimeLineCell.m
//  HUTLife
//
//  Created by Lingyu on 16/3/12.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineCell.h"
#import "TimeLineModel.h"
#import "TimeLineCellAlbum.h"



@interface TimeLineCell ()
@property(nonatomic,strong)UIView *timeLineView;
@property(nonatomic,strong)UIImageView *headerPictureImageView;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)TimeLineCellAlbum *cellAlbum;
@property(nonatomic,strong)UILabel *postionLabel;
@end

@implementation TimeLineCell

static CGFloat headerPictureWidth = 40;
static CGFloat headerPictureHeight = 40;
static CGFloat headerPictureImageViewTop = 10;

static CGFloat timeLineX = 25;
static CGFloat timeLineWidth = 2;

static UIFont *contentLabelFont;

static UIFont *postionLabelFont;

+(void)initialize
{
    contentLabelFont = [UIFont systemFontOfSize:17];
    postionLabelFont = [UIFont systemFontOfSize:17];
}

+(CGFloat)cellHighetWitableTableView:(UITableView*)tableView andModel:(TimeLineModel*)model
{
    //cell的宽度
    CGFloat cellWidth = [tableView bounds].size.width;
    
    //timeLine的中心点X
    CGFloat timeLineCenterX =timeLineX + timeLineWidth / 2;
    
    //布局headerPictureImageView
    CGRect headerPictureImageFrame = CGRectMake(timeLineCenterX - headerPictureWidth/2, headerPictureImageViewTop, headerPictureWidth, headerPictureHeight);
    
    //布局nickNameLabel
    CGFloat interval = 5;
    CGFloat nickNameLabelX = CGRectGetMaxX(headerPictureImageFrame) + interval;
    CGFloat nickNameLabely = headerPictureImageFrame.origin.y + interval;
    CGFloat nickNameLabelWidth = cellWidth - nickNameLabelX - interval;
    CGFloat nickNameLabelHeight = 21;
    CGRect nickNameLabelFrame = CGRectMake(nickNameLabelX, nickNameLabely, nickNameLabelWidth, nickNameLabelHeight);
    
    //布局contentLabel
    CGFloat contentLabelX = nickNameLabelFrame.origin.x;
    CGFloat contentLabelY = CGRectGetMaxY(nickNameLabelFrame) + interval;
    CGFloat contentLabelWidth = cellWidth - contentLabelX - interval;
    CGFloat contentLabelHeight = [[model content] boundingRectWithSize:CGSizeMake(contentLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabelFont} context:nil].size.height + interval;
    CGRect contentLabelFrame = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
    
    //布局cellAlbum
    CGFloat cellAlbumX = contentLabelFrame.origin.x;
    CGFloat cellAlbumY = CGRectGetMaxY(contentLabelFrame) + interval;
    CGFloat cellAlbumWidth = cellWidth - cellAlbumX - interval;
    
    
    NSMutableArray<UIImage*> *picturesArray = [NSMutableArray<UIImage*> array];
    
    for (NSString *imageURL in [model imagesURL]) {
        UIImage *picture = [UIImage imageNamed:imageURL];
        [picturesArray addObject:picture];
    }
    
    
    
    CGSize cellAlbumSize = [TimeLineCellAlbum needSizeWithMaxWidth:cellAlbumWidth pictureArray:picturesArray];
    CGRect cellAlbumFrame = CGRectMake(cellAlbumX, cellAlbumY, cellAlbumSize.width, cellAlbumSize.height);
    
    //布局postionLabel
    CGFloat postionLabelMaxWidth = cellWidth - (timeLineX + timeLineWidth/2 + interval);
    CGFloat postionLabelHeight = [[model postion] boundingRectWithSize:CGSizeMake(cellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabelFont} context:nil].size.height;
    CGRect postionLabelFrame = CGRectMake(timeLineX+timeLineWidth/2+interval, CGRectGetMaxY(cellAlbumFrame) + interval, postionLabelMaxWidth, postionLabelHeight);
    
    //高度
    CGFloat cellHeight = CGRectGetMaxY(postionLabelFrame) + interval;
    
    return cellHeight;
}
+(instancetype)timeLineCellWithTableView:(UITableView *)tableView andModel:(TimeLineModel *)model
{
    NSString *reuseIdentifier = @"TimeLineCell";
    
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell==nil) {
        cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [cell setModel:model];
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadSubviews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

-(void)setModel:(TimeLineModel *)model
{
    self->_model = model;
    [[self headerPictureImageView] setImage:[UIImage imageNamed:[model headePicture]]];
    [[self nickNameLabel] setText:[model nickName]];
    [[self contentLabel] setText:[model content]];
    
    NSMutableArray<UIImage*> *picturesArray = [NSMutableArray<UIImage*> array];
    
    for (NSString *imageURL in [[self model] imagesURL]) {
        UIImage *picture = [UIImage imageNamed:imageURL];
        [picturesArray addObject:picture];
    }
    
    [[self cellAlbum] setPictureArray:picturesArray];
    
    [[self postionLabel] setText:[[self model] postion]];
}

-(void)loadSubviews
{
    [self addSubview:[self timeLineView]];
    [self addSubview:[self headerPictureImageView]];
    [self addSubview:[self nickNameLabel]];
    [self addSubview:[self contentLabel]];
    [self addSubview:[self cellAlbum]];
    [self addSubview:[self postionLabel]];
}

-(UIView*)timeLineView
{
    if (self->_timeLineView) {
        return self->_timeLineView;
    }
    
    self->_timeLineView = [UIView new];
    [self->_timeLineView setBackgroundColor:[UIColor brownColor]];
    
    return self->_timeLineView;
}

-(UIImageView*)headerPictureImageView
{
    if (self->_headerPictureImageView) {
        return self->_headerPictureImageView;
    }
    
    self->_headerPictureImageView = [UIImageView new];
    [self->_headerPictureImageView setBounds:CGRectMake(0, 0, headerPictureWidth, headerPictureHeight)];
    [[self->_headerPictureImageView layer] setCornerRadius:headerPictureWidth/2];
    [[self->_headerPictureImageView layer] setMasksToBounds:YES];
    return self->_headerPictureImageView;
}

-(UILabel*)nickNameLabel
{
    if (self->_nickNameLabel) {
        return self->_nickNameLabel;
    }
    self->_nickNameLabel = [UILabel new];
    [self->_nickNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self->_nickNameLabel setTextColor:[UIColor blueColor]];
    return self->_nickNameLabel;
}

-(UILabel*)contentLabel
{
    if (self->_contentLabel) {
        return self->_contentLabel;
    }
    
    self->_contentLabel = [UILabel new];
    [self->_contentLabel setTextAlignment:NSTextAlignmentLeft];
    [self->_contentLabel setNumberOfLines:0];
    [self->_contentLabel setFont:contentLabelFont];
    return self->_contentLabel;
}

-(TimeLineCellAlbum*)cellAlbum
{
    if (self->_cellAlbum) {
        return self->_cellAlbum;
    }
    
    self->_cellAlbum = [TimeLineCellAlbum album];
    
    return self->_cellAlbum;
}

-(UILabel*)postionLabel
{
    if (self->_postionLabel) {
        return self->_postionLabel;
    }
    
    self->_postionLabel = [UILabel new];
    [self->_postionLabel setTextAlignment:NSTextAlignmentRight];
    [[self->_postionLabel layer] setBorderWidth:2];
    [[self->_postionLabel layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [self->_postionLabel setFont:postionLabelFont];
    return self->_postionLabel;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize selfSize = [self bounds].size;
    
    //布局timeLine
    CGFloat timeLineX = 25;
    CGFloat timeLineWidth = 2;
    [[self timeLineView] setFrame:CGRectMake(timeLineX, 0, timeLineWidth, selfSize.height)];
    
    //布局headPicture
    
        //距离顶部高度
    CGFloat headerPictureImageViewTop = 10;
    [[self headerPictureImageView] setCenter:CGPointMake([[self timeLineView] center].x, [[self headerPictureImageView] bounds].size.height/2+headerPictureImageViewTop)];
    
    //布局nickNameLabel
    CGFloat interval = 5;
    CGFloat nickNameLabelX = CGRectGetMaxX([[self headerPictureImageView] frame]) + interval;
    CGFloat nickNameLabely = [[self headerPictureImageView] frame].origin.y + interval;
    CGFloat nickNameLabelWidth = selfSize.width - nickNameLabelX - interval;
    CGFloat nickNameLabelHeight = 21;
    [[self nickNameLabel] setFrame:CGRectMake(nickNameLabelX, nickNameLabely, nickNameLabelWidth, nickNameLabelHeight)];
    
    //布局contentLabel
    CGFloat contentLabelX = [[self nickNameLabel] frame].origin.x;
    CGFloat contentLabelY = CGRectGetMaxY([[self nickNameLabel] frame]) + interval;
    CGFloat contentLabelWidth = selfSize.width - contentLabelX - interval;
    CGFloat contentLabelHeight = [[[self contentLabel] text] boundingRectWithSize:CGSizeMake(contentLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabelFont} context:nil].size.height + interval;
    [[self contentLabel] setFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
    
    //布局cellAlbum
    
    NSMutableArray<UIImage*> *picturesArray = [NSMutableArray<UIImage*> array];
    
    for (NSString *imageURL in [[self model] imagesURL]) {
        UIImage *picture = [UIImage imageNamed:imageURL];
        [picturesArray addObject:picture];
    }
    
    
    CGFloat cellAlbumX = [[self contentLabel] frame].origin.x;
    CGFloat cellAlbumY = CGRectGetMaxY([[self contentLabel] frame]) + interval;
    CGFloat cellAlbumWidth = selfSize.width - cellAlbumX - interval;
    CGSize cellAlbumSize = [TimeLineCellAlbum needSizeWithMaxWidth:cellAlbumWidth pictureArray:picturesArray];
    [[self cellAlbum] setFrame:CGRectMake(cellAlbumX, cellAlbumY, cellAlbumSize.width, cellAlbumSize.height)];
    
    //布局postionLabel
    [[self postionLabel] sizeToFit];
    
    CGFloat postionLabelX = selfSize.width - interval - [[self postionLabel] bounds].size.width;
    CGFloat postionLabelY = CGRectGetMaxY([[self cellAlbum] frame]) + interval;
    [[self postionLabel] setFrame:CGRectMake(postionLabelX, postionLabelY, [[self postionLabel] bounds].size.width, [[self postionLabel] bounds].size.height)];
    
    
}

@end
