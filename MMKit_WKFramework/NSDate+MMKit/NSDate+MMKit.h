//
//  NSDate+MMKit.h
//  MMKit
//
//  Created by Dwang on 2018/5/8.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MMKit)


/** 获取当前时间 */
+ (NSInteger)mmkit_currentTime;

/** 获取当前时间戳 */
+ (NSString *)mmkit_timestamp;

@end
