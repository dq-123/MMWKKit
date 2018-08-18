////  NSString+MMKit.m
//  MMKit
//
//  Created by Dwang on 2018/8/18.
//	QQ群:	577506623
//	GitHub:	https://github.com/CoderDwang
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "NSString+MMKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MMKit)

- (NSString *)mmkit_md5String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *strOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [strOutput appendFormat:@"%02x", digest[i]];
    }
    return  strOutput;
}

@end
