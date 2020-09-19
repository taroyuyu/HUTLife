//
//  TimeTableItemDetaiilViewController.m
//  HUT
//
//  Created by Lingyu on 16/2/18.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "TimeTableItemDetaiilViewController.h"
#import "TimeTableItem.h"

@interface TimeTableItemDetaiilViewController ()
@property (weak, nonatomic) IBOutlet UITextField *courseNameField;
@property (weak, nonatomic) IBOutlet UITextField *coursePlaceField;
@property (weak, nonatomic) IBOutlet UITextField *courseTeacherField;
@property (weak, nonatomic) IBOutlet UITextField *courseTimeField;
@property (weak, nonatomic) IBOutlet UITextField *courseWeekField;
@property(nonatomic,strong)NSArray<NSString*> *weekDays;
@end

@implementation TimeTableItemDetaiilViewController


static NSString *weekDaysFileName = @"weekDays.plist";

+(instancetype)itemDetailViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"itemDetailViewController"];
}


-(NSArray<NSString*> *)weekDays
{
    if (self->_weekDays) {
        return self->_weekDays;
    }
    
    self->_weekDays = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:weekDaysFileName withExtension:nil]];
    
    return self->_weekDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadModelInformation];
}

-(void)loadModelInformation
{
    [self setTitle:[[self model] courseName]];
    [[self courseNameField] setText:[[self model] courseName]];
    [[self coursePlaceField] setText:[[self model] coursePlace]];
    [[self courseTeacherField] setText:[[self model] courseTeacher]];
    
    NSString *courseWeekDay = [[self weekDays] objectAtIndex:[[self model] courseDay] - 1];
    NSMutableString *courseTimeIndex = [NSMutableString new];
    for (NSUInteger index = 0; index < [[[self model] courseTime] count]-1; index++) {
        [courseTimeIndex appendFormat:@"%ld,",[[[[self model] courseTime] objectAtIndex:index] integerValue]];
    }
    [courseTimeIndex appendFormat:@"%ld节",[[[[self model] courseTime] lastObject] integerValue]];
    [[self courseTimeField] setText:[NSString stringWithFormat:@"%@ %@",courseWeekDay,courseTimeIndex]];
    
    NSString *courseWeek;
    switch ([[self model] courseFlag]) {
        case 0:
        {
            //不区分单双周
            courseWeek = [NSString stringWithFormat:@"%d-%d",[[self model] courseFrom],[[self model] courseTo]];
        }
            break;
        case 1:
        {
            //单周
            courseWeek = [NSString stringWithFormat:@"%d-%d(单周)",[[self model] courseFrom],[[self model] courseTo]];
        }
            break;
        case 2:
        {
            //双周
            courseWeek = [NSString stringWithFormat:@"%d-%d(双周)",[[self model] courseFrom],[[self model] courseTo]];
        }
            break;
    }
    
    [[self courseWeekField] setText:courseWeek];
    
}

-(void)setModel:(TimeTableItem *)model
{
    self->_model = model;
    
    [self loadModelInformation];
    
}

@end
