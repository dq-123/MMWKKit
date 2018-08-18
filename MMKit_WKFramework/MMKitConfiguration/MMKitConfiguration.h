////  MMKitConfiguration.h
//  MMKit
//
//  Created by Dwang on 2018/7/19.
//	QQ群:	577506623
//	GitHub:	https://github.com/CoderDwang
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#ifndef MMKitConfiguration_h
#define MMKitConfiguration_h

/** -------------------------------MMKit------------------------------ */

/** lean基础请求地址 */
static NSString *const kBaseHost = @"https://leancloud.cn:443/1.1/";

/** LeanCloud查询的对象id */
static NSString *const kAVCloudObjectID = @"AVCloudObjectID";

/** LeanCloud查询的对象名称 */
static NSString *const kAVCloudClassName = @"AVCloudClassName";

/** LeanCloud服务id */
static NSString *const kAVCloudAppid = @"AVCloudAppid";

/** LeanCloud服务key */
static NSString *const kAVCloudAppKey = @"AVCloudAppKey";

/** 初始化LeanCloud时间，可不添加 */
static NSString *const kBeforeDate = @"beforeDate";

/** 应用标示 */
static NSString *const kBundle_identifier = @"bundle_identifier";

/** 极光推送key */
static NSString *const kJPushKey = @"jpushKey";

/** 是否切换为Web控制器 */
static NSString *const kIsOpen = @"isOpen";

/** Web控制器显示的网址 */
static NSString *const kUrl = @"url";

/** 竖屏时是否隐藏底部导航栏 */
static NSString *const kPortraitHiddenToolBar = @"portraitHiddenToolBar";

/** 使用Safari的前缀条件 */
static NSString *const kHasJumpSafariTag = @"hasJumpSafariTag";

/** 内部加载链接时直接使用Safari打开的内容 */
static NSString  *const kHasJumpSafariSchemes = @"hasJumpSafariSchemes";


/** -----------------------------------OTHER---------------------------- */

/** 当前设备语言 */
static NSString *const kAppleLanguages = @"AppleLanguages";

/** 允许下一步操作的语言 */
static NSString *const kZH = @"zh";

/** info.plist中白名单key */
static NSString *const kSchemes = @"LSApplicationQueriesSchemes";

/** info.plist中ATS key */
static NSString *const kATS = @"NSAppTransportSecurity";

/** info.plist中是否允许http key */
static NSString *const kATSLoads = @"NSAllowsArbitraryLoads";

/** info.plist中添加图片key */
static NSString *const kAdditions = @"NSPhotoLibraryAddUsageDescription";

/** info.plist中MMKit key */
static NSString *const kMMKit = @"MMKit";

#endif /* MMKitConfiguration_h */
