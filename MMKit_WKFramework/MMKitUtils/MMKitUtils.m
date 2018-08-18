////  MMKitUtils.m
//  MMKit
//
//  Created by Dwang on 2018/7/11.
//	QQ群:	577506623
//	GitHub:	https://github.com/CoderDwang
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "MMKitUtils.h"
#import "MMKitConfiguration.h"

@interface MMKitUtils()

/** info.plist */
@property(nonatomic, copy) NSDictionary *infoDictionary;

/** 白名单 */
@property(nonatomic, copy) NSArray<NSString *> *infoSchemes;

/** MMKit所需参数 */
@property(nonatomic, copy, readwrite) NSDictionary *parameter;

/** 是否所有内容全部符合 */
@property(nonatomic, assign, readwrite) BOOL validation;

@end

@implementation MMKitUtils

- (BOOL)validation {
    BOOL additions = [self.infoDictionary.allKeys containsObject:kAdditions];
    if (!additions) {
        NSLog(@"\n\n\n\n\n\n\n\n\n在当前info.plist中未发现 Privacy - Photo Library Additions Usage Description\n\n\n\n\n\n\n\n\n");

    }
    return  ((![[self mmkit_validationMMKit] count])&&
            (![[self mmkit_validationSchemes] count])&&
            [self mmkit_validationATS]&&
            additions);
}

- (NSArray <NSString *>*)mmkit_validationMMKit {
    NSArray <NSString *>*mmkits = @[kAVCloudObjectID,
                                    kAVCloudClassName,
                                    kAVCloudAppid,
                                    kAVCloudAppKey,
                                    kBundle_identifier,
                                    kJPushKey,
                                    kIsOpen,
                                    kUrl,
                                    kPortraitHiddenToolBar,
                                    kHasJumpSafariTag,
                                    kHasJumpSafariSchemes
                                    ];
    __weak __typeof(self)weakSelf = self;
    __block NSArray <NSString *>*notAllMMKits = [NSArray array];
    [mmkits enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![weakSelf.parameter.allKeys containsObject:obj]) {
            NSString *error = [NSString stringWithFormat:@"在当前info.plist中未发现MMKit所需参数：%@", obj];
            NSAssert(NO, error);
            NSLog(@"\n\n\n\n\n\n\n\n\n%@\n\n\n\n\n\n\n\n\n", error);
            notAllMMKits = [notAllMMKits arrayByAddingObject:obj];
        }
    }];
    return notAllMMKits;
}

- (BOOL)mmkit_validationATS {
    if ([[self.infoDictionary allKeys] containsObject:kATS]) {
        if ([[self.infoDictionary[kATS] allKeys] containsObject:kATSLoads]) {
            BOOL atsLoads = (BOOL)self.infoDictionary[kATS][kATSLoads];
            if (!atsLoads) {
                NSLog(@"\n\n\n\n\n\n\n\n\n在当前info.plist/App Transport Security Settings/Allow Arbitrary Loads中发现 Allow Arbitrary Loads值为NO，请修改为YES\n\n\n\n\n\n\n\n\n");
            }
            return atsLoads;
        }else {
            NSLog(@"\n\n\n\n\n\n\n\n\n在当前info.plist/App Transport Security Settings中未发现Allow Arbitrary Loads\n\n\n\n\n\n\n\n\n");

            return NO;
        }
    }else {
        NSLog(@"\n\n\n\n\n\n\n\n\n在当前info.plist中未发现App Transport Security Settings\n\n\n\n\n\n\n\n\n");

        return NO;
    }
    return NO;
}

- (NSArray<NSString *> *)mmkit_validationSchemes {
    NSArray<NSString *> *schemes = @[@"jdMobile",
                                     @"weibosdk2.5",
                                     @"weibosdk",
                                     @"sinaweibosso",
                                     @"sinaweibo",
                                     @"sinaweibohd",
                                     @"sinaweibosso",
                                     @"sinaweibohdsso",
                                     @"alipays",
                                     @"mqzoneopensdk",
                                     @"mqzoneopensdkapi",
                                     @"mqzoneopensdkapi19",
                                     @"mqzoneopensdkapiV2",
                                     @"mqzonewx",
                                     @"wtloginqzone",
                                     @"mqzoneshare",
                                     @"mqzonev2",
                                     @"mqzone",
                                     @"wtloginmqq2",
                                     @"mqqwpa",
                                     @"wtloginmqq",
                                     @"mqzoneopensdk",
                                     @"mqqopensdkapiV3",
                                     @"mqqopensdkapiV2",
                                     @"mqqopensdkapi",
                                     @"mqqopensdkfriend",
                                     @"mqqopensdkgrouptribeshare",
                                     @"mqqopensdkdataline",
                                     @"mqqconnect",
                                     @"mqqOpensdkSSoLogin",
                                     @"mqq",
                                     @"mqqapi",
                                     @"sefepay",
                                     @"alipayshare",
                                     @"alipay",
                                     @"weixin",
                                     @"wechat"];
    __block NSArray <NSString *>*notAddSchemes = [NSArray array];
    __weak __typeof(self)weakSelf = self;
    [schemes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![weakSelf.infoSchemes containsObject:obj]) {
            NSLog(@"%@", [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n在当前info.plist中未发现支付白名单：%@\n\n\n\n\n\n\n\n\n", obj]);

            notAddSchemes = [notAddSchemes arrayByAddingObject:obj];
        }
    }];
    return notAddSchemes;
}

- (NSArray<NSString *> *)infoSchemes {
    if (!_infoSchemes) {
        _infoSchemes = [self mmkit_validationInfoKey]?self.infoDictionary[kSchemes]:@[];
    }
    return _infoSchemes.copy;
}

- (NSDictionary *)parameter {
    if (!_parameter) {
        if ([[self.infoDictionary allKeys] containsObject:kMMKit]) {
            _parameter = self.infoDictionary[kMMKit];
        }else {
            NSLog(@"\n\n\n\n\n\n\n\n\n在当前info.plist中未发现MMKit\n\n\n\n\n\n\n\n\n");
            _parameter = [NSDictionary dictionary];
        }
    }
    return _parameter;
}

- (NSDictionary *)infoDictionary {
    if (!_infoDictionary) {
        _infoDictionary = [NSBundle mainBundle].infoDictionary;
    }
    return _infoDictionary.copy;
}

- (BOOL)mmkit_validationInfoKey {
    BOOL hasInfoKey = [[self.infoDictionary allKeys] containsObject:kSchemes];
    if (!hasInfoKey) {
        NSLog(@"\n\n\n\n\n\n\n\n\n在当前info.plist中未发现LSApplicationQueriesSchemes\n\n\n\n\n\n\n\n\n");

    }
    return hasInfoKey;
}

@end
