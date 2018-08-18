//
//  AppDelegate+MMKit.h
//  MMKit
//
//  Created by Dwang on 2018/5/5.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (MMKit)<UIApplicationDelegate>

/**
 启动MMKit
 
 @param selfClass 启动对象,传self即可
 @param launchOptions 启动参数，极光推送需要
 @param waitMsg 网络请求时的展示内容，可为image对象或string对象。推荐使用image对象，将启动页图片设为waitMsg
 @param templateController 模版主控制器/不使用时传nil
 @param templateBlock 某些只在模版中启动的内容
 
 */
void mmkit_setup(UIResponder *selfClass, NSDictionary *launchOptions, id waitMsg, UIViewController *templateController, void (^templateBlock)(void));

@end
