//
//  MMKitWKViewController.h
//  MMKit
//
//  Created by Dwang on 2018/5/13.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMKitWKViewController : UIViewController

/** 是否显示退出按钮 */
@property(nonatomic, assign) BOOL exit;

/** 跳转地址 */
@property(nonatomic, copy) NSString *urlString;

/** 竖屏时是否隐藏toolBar */
@property(nonatomic, assign) BOOL portraitHiddenToolBar;

/** 横屏是否自动隐藏toolBar */
@property(nonatomic, assign) BOOL autoHiddenToolBar;

/** 是否开启长按图片保存功能 */
@property(nonatomic, assign) BOOL saveImage;

/** 跳转标示 */
@property(nonatomic, copy) NSString *safariTag;

/** 需直接跳转Safari的字段 */
@property(nonatomic, copy) NSArray<NSString *> *safariSchemes;

@end
