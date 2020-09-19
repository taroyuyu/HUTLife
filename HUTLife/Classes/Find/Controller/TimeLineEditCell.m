//
//  TimeLineEditCell.m
//  HUTLife
//
//  Created by Lingyu on 16/3/8.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeLineEditCell.h"
#include "TimeLineEditInputView.h"
#include "TimeLineEditPicture.h"
#import "EmotionKeyBoard.h"
#import "EmotionModel.h"
#import "EmotionTextAttachment.h"

NSString * const TimeLineEditTextDidChangedNotification = @"TimeLineEditTextDidChangedNotification";
@interface TimeLineEditCell ()<TimeLineEditPictureDelegate,UITextFieldDelegate>
@property (strong, nonatomic)  TimeLineEditInputView *inputView;
@property (strong, nonatomic)  TimeLineEditPicture *pitcureAlbum;
@property (strong, nonatomic)   UIView *inputAccessoryView;
@property (strong, nonatomic)   UIBarButtonItem *emotionBarButtonItem;
@property (strong, nonatomic)   UIBarButtonItem *keyBoardButtonItem;
@property (strong, nonatomic)   UIFont  *inputViewFont;
/**
 *表情键盘
 */
@property (strong, nonatomic)   EmotionKeyBoard *emotionKeyBoard;
@end

@implementation TimeLineEditCell

+(instancetype)cell
{
    TimeLineEditCell *cell = [[TimeLineEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setBounds:CGRectMake(0, 0, 320, 160)];
    return cell;
}

-(UIFont*)inputViewFont
{
    if (self->_inputViewFont) {
        return self->_inputViewFont;
    }
    
    self->_inputViewFont = [UIFont systemFontOfSize:17];;
    
    return self->_inputViewFont;
}

-(UIBarButtonItem*)emotionBarButtonItem
{
    if (self->_emotionBarButtonItem) {
        return self->_emotionBarButtonItem;
    }
    
    UIButton *emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [emotionButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [emotionButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    
    [emotionButton addTarget:self action:@selector(emotionBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self->_emotionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:emotionButton];
    
    return self->_emotionBarButtonItem;
}

-(void)emotionBarButtonItemClicked
{
    NSLog(@"emotionBarButtonItemClicked");
}

-(UIBarButtonItem*)keyBoardButtonItem
{
    if (self->_keyBoardButtonItem) {
        return self->_keyBoardButtonItem;
    }
    
    UIButton *keyBoardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [keyBoardButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
    [keyBoardButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    [keyBoardButton addTarget:self action:@selector(keyBoardButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self->_keyBoardButtonItem = [[UIBarButtonItem alloc] initWithCustomView:keyBoardButton];
    
    return self->_keyBoardButtonItem;
}

-(void)keyBoardButtonItemClicked
{
    [[self inputView] resignFirstResponder];
}

-(UIView*)inputAccessoryView
{
    if (self->_inputAccessoryView) {
        return self->_inputAccessoryView;
    }
    
    CGFloat toolBarWidth = [[[UIApplication sharedApplication] keyWindow] bounds].size.width;
    
    CGFloat toolBarHeight = 44;
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    
    UIBarButtonItem *flexBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:@[[self emotionBarButtonItem],flexBarButtonItem,[self keyBoardButtonItem]]];
    
    self->_inputAccessoryView = toolBar;
    
    
    return self->_inputAccessoryView;
}

-(EmotionKeyBoard*)emotionKeyBoard
{
    if (self->_emotionKeyBoard) {
        return self->_emotionKeyBoard;
    }
    self->_emotionKeyBoard = [EmotionKeyBoard keyBoard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:EmotionKeyBoardDidSelectedNotification object:self->_emotionKeyBoard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleButtonClicked) name:EmotionKeyBoardDeleButtonClcikedNotification object:self->_emotionKeyBoard];
    return self->_emotionKeyBoard;
}

-(void)emotionDidSelected:(NSNotification*)notification
{
    EmotionModel *model = [[notification userInfo] objectForKey:EmotionKeyBoardSelectedEmotionModel];
    
    //获取当前的字体
    if ([[self inputView] font] == nil) {
        [[self inputView] setFont:[self inputViewFont]];
    }
    UIFont *currentFont = [[self inputView] font];
    //获取当前的行高
    CGFloat currentLineHeight = [currentFont lineHeight];
    EmotionTextAttachment *textAttachemnt = [EmotionTextAttachment new];
    [textAttachemnt setImage:[UIImage imageNamed:[model png]]];
    [textAttachemnt setModel:model];
    //设置图片的bounds
    [textAttachemnt setBounds:CGRectMake(0, -4, currentLineHeight, currentLineHeight)];
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachemnt]];
    //设置attributedString的字体
    [attributedString addAttribute:NSFontAttributeName value:currentFont range:NSMakeRange(0, attributedString.length)];

    [[self inputView] insertAttributedText:attributedString];
    
    [self inputViewTextDidChanegd:[NSNotification notificationWithName:TimeLineEditTextDidChangedNotification object:self]];
}

-(void)deleButtonClicked
{
    [[self inputView] deleText];
}

-(TimeLineEditInputView*)inputView
{
    if (self->_inputView) {
        return self->_inputView;
    }
    self->_inputView = [TimeLineEditInputView new];
    [self->_inputView setFont:[self inputViewFont]];
    [self->_inputView setInputAccessoryView:[self inputAccessoryView]];
    [self->_inputView setInputView:[self emotionKeyBoard]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewTextDidChanegd:) name:UITextViewTextDidChangeNotification object:self->_inputView];
    
    return self->_inputView;
}

-(void)inputViewTextDidChanegd:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TimeLineEditTextDidChangedNotification object:self userInfo:notification.userInfo];
}

-(TimeLineEditPicture*)pitcureAlbum
{
    if (self->_pitcureAlbum) {
        return self->_pitcureAlbum;
    }
    self->_pitcureAlbum = [TimeLineEditPicture new];
    [self->_pitcureAlbum setDelegate:self];
    return self->_pitcureAlbum;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addSubview:[self inputView]];
        [self addSubview:[self pitcureAlbum]];
    }
    
    return self;
}



-(void)timeLineEditPictureDidNeedNewPicture:(TimeLineEditPicture *)timeLineEditPicture
{
    if ([self delegate]) {
        [[self delegate] timeLineEditCellNeedNewPicture:self];
    }
    
}

-(void)timeLineEditDidInsertImage:(TimeLineEditPicture *)timeLineEditPicture
{
    CGFloat pictureAlbumHeight = [[self pitcureAlbum] bounds].size.height;
    [self setBounds:CGRectMake(0, 0,[self bounds].size.width, [self inputView].bounds.size.height + pictureAlbumHeight)];
    
    if ([self delegate]) {
        [[self delegate] timeLineEditCellDidInsertImage:self];
    }
}

-(void)timeLineEdit:(TimeLineEditPicture*)timeLineEditPicture didSelectedImage:(UIImage*)image
{
    if ([self delegate]) {
        [[self delegate] timeLineEditCell:self didSelectedImage:image];
    }
}

-(NSArray<UIImage*>*)imageArray
{
    return [[self pitcureAlbum] imageArray];
}

-(void)insertNewImage:(UIImage*)newImage
{
    [[self pitcureAlbum] insertNewImage:newImage];
}

-(NSString*)placeholder
{
    return [[self inputView] placeholder];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    [[self inputView] setPlaceholder:placeholder];
}

-(NSString*)text
{
//    NSRange range;
//    range.location = 0;
//    range.length = [[[self inputView] attributedText] length];
//    NSMutableString *textString = [NSMutableString string];
//    [[[self inputView] attributedText] enumerateAttributesInRange:range options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//        
//        NSAttributedString *item = [[[self inputView] attributedText] attributedSubstringFromRange:range];
//        if ([[item string] isEqualToString:@""]) {
//            //说明为表情
//            
//        }else{
//            
//        }
//        
//    }];

    NSMutableString *emotionString = [NSMutableString new];
    
    [[[self inputView] attributedText] enumerateAttributesInRange:NSMakeRange(0, [[[self inputView] attributedText] length]) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        EmotionTextAttachment *emotionAttachment = (EmotionTextAttachment*)[attrs objectForKey:@"NSAttachment"];
        
        if (emotionAttachment) {//为图片表情
            [emotionString appendString:[[EmotionKeyBoard emotionModelToDict:[emotionAttachment model]] objectForKey:@"chs"]];
        }else{// 不为图片表情
            //获得这个范围内的NSAttributedText
            NSAttributedString *indexString =  [[[self inputView] attributedText] attributedSubstringFromRange:range];
            
            [emotionString appendString:indexString.string];
        }
    }];

    return emotionString;
}

-(void)setText:(NSString *)text
{
    [[self inputView] setText:text];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat inputViewHeight = 80;
    CGSize selfSize = [self bounds].size;
    
    [[self inputView] setFrame:CGRectMake(0, 0, selfSize.width, inputViewHeight)];
    
    [[self pitcureAlbum] setFrame:CGRectMake(0, inputViewHeight, selfSize.width, selfSize.height - inputViewHeight)];
    
}

//判断是否有文字
-(BOOL)isEmpty
{
    return [[self inputView] isEmpty];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
