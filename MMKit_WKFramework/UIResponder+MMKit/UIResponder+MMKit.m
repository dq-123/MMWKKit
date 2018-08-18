//
//  AppDelegate+MMKit.m
//  MMKit
//
//  Created by Dwang on 2018/5/5.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "UIResponder+MMKit.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "MMKitWKViewController.h"
#import "NSDate+MMKit.h"
#import "MMKitWaitViewController.h"
#import "MMKitUtils.h"
#import "MMKitConfiguration.h"
#import "MMKitNetwork.h"

static BOOL _initializeJPUSH_LeanCloud = YES;
static UIViewController *_rootViewController = nil;
static MMKitUtils *utils;
@interface UIResponder ()<JPUSHRegisterDelegate>

@end

@implementation UIResponder (MMKit)

- (void)mmkit_JPUSHWithLaunchOptions:(NSDictionary *)launchOptions appKey:(NSString *)appKey {
    if (!_initializeJPUSH_LeanCloud)return;
    BOOL aps;
#ifdef DEBUG
    aps = NO;
#else
    aps = YES;
#endif
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:@"App Store"
                 apsForProduction:aps];
}

void mmkit_setup(UIResponder *selfClass, NSDictionary *launchOptions, id waitMsg, UIViewController *templateController, void (^templateBlock)(void)) {
    [selfClass mmkit_setUpWithLaunchOptions:launchOptions waitMsg:waitMsg templateController:templateController templateBlock:templateBlock];
}

- (void)mmkit_setUpWithLaunchOptions:(NSDictionary *)launchOptions waitMsg:(id)waitMsg templateController:(UIViewController *)templateController templateBlock:(void(^)(void))templateBlock {
    NSLog(@"\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t当前MMKit_WK版本 v1.2.5\n\n\n\n\n\n\n\n\n");
    utils = [[MMKitUtils alloc] init];
    _initializeJPUSH_LeanCloud = ([[utils.parameter allKeys] containsObject:kBeforeDate]?([[[utils.parameter[kBeforeDate] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] integerValue]<[NSDate mmkit_currentTime]):YES);
    if (templateController) {
        if (self.window) {
            [self mmkit_waitViewControllerWithWaitMsg:waitMsg];
        }else {
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.window.backgroundColor = UIColor.whiteColor;
            [self mmkit_waitViewControllerWithWaitMsg:waitMsg];
            [self.window makeKeyAndVisible];
        }
    }else {
        _rootViewController = self.window.rootViewController;
        [self mmkit_waitViewControllerWithWaitMsg:waitMsg];
    }
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:kAppleLanguages] objectAtIndex:0] hasPrefix:kZH] && _initializeJPUSH_LeanCloud && utils.validation) {
            __weak __typeof(self)weakSelf = self;
        [MMKitNetwork mmkit_requestWithAppid:utils.parameter[kAVCloudAppid] appKey:utils.parameter[kAVCloudAppKey] objectId:utils.parameter[kAVCloudObjectID] className:utils.parameter[kAVCloudClassName] callBack:^(id object, NSError *error) {
                if (object && !error) {
                    NSString *bundle_identifier = object[utils.parameter[kBundle_identifier]];
                    BOOL isOpen = [object[utils.parameter[kIsOpen]] intValue];
                    if ([bundle_identifier isEqualToString:[[NSBundle mainBundle] bundleIdentifier]] &&
                        isOpen) {
                        BOOL hasExit = YES;
                        BOOL hasWK = YES;
                        BOOL portraitHiddenToolBar = [object[utils.parameter[kPortraitHiddenToolBar]] boolValue];
                        BOOL autoHiddenToolBar = YES;
                        BOOL hasSaveImage = YES;
                        if (weakSelf.window) {
                            [weakSelf mmkit_applicationMMKitWebViewControllerWithHasExit:hasExit portraitHiddenToolBar:portraitHiddenToolBar autoHiddenToolBar:autoHiddenToolBar hasSaveImage:hasSaveImage hasWK:hasWK formUrl:object[utils.parameter[kUrl]] launchOptions:launchOptions jpushKey:object[utils.parameter[kJPushKey]] safariTag:object[utils.parameter[kHasJumpSafariTag]] safariSchemes:object[utils.parameter[kHasJumpSafariSchemes]]];
                        }else {
                            weakSelf.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                            weakSelf.window.backgroundColor = [UIColor whiteColor];
                            [weakSelf mmkit_applicationMMKitWebViewControllerWithHasExit:hasExit portraitHiddenToolBar:portraitHiddenToolBar autoHiddenToolBar:autoHiddenToolBar hasSaveImage:hasSaveImage hasWK:hasWK formUrl:object[utils.parameter[kUrl]] launchOptions:launchOptions jpushKey:object[utils.parameter[kJPushKey]] safariTag:object[utils.parameter[kHasJumpSafariTag]] safariSchemes:object[utils.parameter[kHasJumpSafariSchemes]]];
                            [weakSelf.window makeKeyAndVisible];
                        }
                    }else {
                        [weakSelf mmkit_applicationWithTemplateController:templateController];
                        if (templateBlock) {
                            templateBlock();
                        }
                    }
                }else {
                    if (error.code == -1009 &&
                        [NSDate mmkit_currentTime] > [utils.parameter[kBeforeDate] integerValue]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前设备似乎没有网络连接" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [weakSelf mmkit_setUpWithLaunchOptions:launchOptions waitMsg:waitMsg templateController:templateController templateBlock:templateBlock];
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                        [weakSelf.window.rootViewController presentViewController:alert animated:YES completion:nil];
                    }else {
                        [weakSelf mmkit_applicationWithTemplateController:templateController];
                        if (templateBlock) {
                            templateBlock();
                        }
                    }
                }
            }];
    }else {
        [self mmkit_applicationWithTemplateController:templateController];
        if (templateBlock) {
            templateBlock();
        }
    }
}

- (void)mmkit_applicationMMKitWebViewControllerWithHasExit:(BOOL)exit portraitHiddenToolBar:(BOOL)portraitHiddenToolBar autoHiddenToolBar:(BOOL)autoHiddenToolBar hasSaveImage:(BOOL)hasSaveImage hasWK:(BOOL)hasWK formUrl:(NSString *)urlString launchOptions:(NSDictionary *)launchOptions jpushKey:(NSString *)jpushKey safariTag:(NSString *)safariTag safariSchemes:(NSString *)safariSchemes {
    [self mmkit_JPUSHWithLaunchOptions:launchOptions appKey:jpushKey];
    jpushKey = jpushKey?jpushKey:@"";
    safariTag = safariTag?safariTag:@"";
    safariSchemes = safariSchemes?safariSchemes:@"";
    NSArray <NSString *>*schemes = [safariSchemes componentsSeparatedByString:@"、"];
        MMKitWKViewController *mmkitWK = [[MMKitWKViewController alloc] init];
        mmkitWK.safariTag = safariTag;
        mmkitWK.exit = exit;
        mmkitWK.portraitHiddenToolBar = portraitHiddenToolBar;
        mmkitWK.autoHiddenToolBar = autoHiddenToolBar;
        mmkitWK.saveImage = hasSaveImage;
        mmkitWK.urlString = urlString;
        mmkitWK.safariSchemes = schemes;
        self.window.rootViewController = mmkitWK;
}

- (void)mmkit_waitViewControllerWithWaitMsg:(id)waitMsg {
    MMKitWaitViewController *waitViewController;
    if ([waitMsg isKindOfClass:[UIImage class]]) {
        waitViewController = [[MMKitWaitViewController alloc] initWithLaunchImage:waitMsg];
    }else if ([waitMsg isKindOfClass:[NSString class]]) {
        waitViewController = [[MMKitWaitViewController alloc] initWithWaitString:waitMsg];
    }else {
        waitViewController = [[MMKitWaitViewController alloc] init];
    }
    self.window.rootViewController = waitViewController;
}

- (void)mmkit_applicationWithTemplateController:(UIViewController *)templateController {
    if (templateController) {
        self.window.rootViewController = templateController;
    }else {
        self.window.rootViewController = _rootViewController;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler   API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}
#pragma clang diagnostic pop

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end



