//
//  MMKitWaitViewController.h
//  MMKit
//
//  Created by Dwang on 2018/5/14.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMKitWaitViewController : UIViewController


/**
 模拟启动页，用于隐藏网络请求的耗时

 @param LaunchImage 推荐与启动页图片相同
 @return self
 */
- (instancetype)initWithLaunchImage:(UIImage *)LaunchImage;

/**
 模拟启动页，用于隐藏网络请求的耗时

 @param waitString 提示文字
 @return self
 */
- (instancetype)initWithWaitString:(NSString *)waitString;

@end
