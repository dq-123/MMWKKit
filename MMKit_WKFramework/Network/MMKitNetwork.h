////  MMKitNetwork.h
//  MMKit
//
//  Created by Dwang on 2018/8/18.
//	QQ群:	577506623
//	GitHub:	https://github.com/CoderDwang
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMKitNetwork : NSObject

/**
 网络请求

 @param appid LeanCloud服务id
 @param appKey LeanCloud服务key
 @param objectId LeanCloud查询的对象id
 @param className LeanCloud查询的对象名称
 
 @param callBack 返回结果
 */
+ (void)mmkit_requestWithAppid:(NSString *)appid appKey:(NSString *)appKey objectId:(NSString *)objectId className:(NSString *)className callBack:(void (^) (id object, NSError *error))callBack;

@end
