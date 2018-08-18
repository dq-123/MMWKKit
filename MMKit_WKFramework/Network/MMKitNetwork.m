////  MMKitNetwork.m
//  MMKit
//
//  Created by Dwang on 2018/8/18.
//	QQ群:	577506623
//	GitHub:	https://github.com/CoderDwang
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "MMKitNetwork.h"
#import "NSString+MMKit.h"
#import "NSDate+MMKit.h"
#import "MMKitConfiguration.h"

@implementation MMKitNetwork

+ (void)mmkit_requestWithAppid:(NSString *)appid appKey:(NSString *)appKey objectId:(NSString *)objectId className:(NSString *)className callBack:(void (^) (id object, NSError *error))callBack {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@classes/%@/%@", kBaseHost, className, objectId]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:appid forHTTPHeaderField:@"X-LC-Id"];
    NSString *timestamp = [NSDate mmkit_timestamp];
    [request addValue:[NSString stringWithFormat:@"%@,%@", [NSString stringWithFormat:@"%@%@", timestamp, appKey].mmkit_md5String, timestamp] forHTTPHeaderField:@"X-LC-Sign"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                callBack([NSJSONSerialization JSONObjectWithData:data options:0 error:nil], nil);
            }else {
                callBack(nil, error);
            }
        });
    }];
    [dataTask resume];
}

@end
