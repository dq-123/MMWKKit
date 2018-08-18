//
//  NSDate+MMKit.m
//  MMKit
//
//  Created by Dwang on 2018/5/8.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "NSDate+MMKit.h"

@implementation NSDate (MMKit)

+ (NSInteger)mmkit_currentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSString *)mmkit_timestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return [NSString stringWithFormat:@"%0.f", a];
}

@end
