////  MMKitUtils.h
//  MMKit
//
//  Created by Dwang on 2018/7/11.
//	QQ群:	577506623
//	GitHub:	https://github.com/CoderDwang
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMKitUtils : NSObject

/**
 验证是否开启ATS

 @return 是否开启
 */
- (BOOL)mmkit_validationATS;

/**
 验证是否存在未添加的白名单

 @return 返回未添加的白名单名称，当白名单全部添加时，返回空数组
 */
- (NSArray<NSString *> *)mmkit_validationSchemes;

/**
 验证是否存在未添加的MMKit参数

 @return 返回未添加的MMKit参数，当参数全部添加时，返回空数组
 */
- (NSArray <NSString *>*)mmkit_validationMMKit;

/** MMKit所需参数 */
@property(nonatomic, copy, readonly) NSDictionary *parameter;

/** 是否所有内容全部符合 */
@property(nonatomic, assign, readonly) BOOL validation;

@end
