//
//  NSString+HUTLife.m
//  HUTLife
//
//  Created by Lingyu on 16/4/17.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "NSString+HUTLife.h"

@implementation NSString (HUTLife)
-(BOOL)isNotEmpty
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedString isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}
-(NSInteger)toIntegetValue
{
     return [[[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""] integerValue];
}
@end
