//
//  UIBarButtonItem+MMKit.m
//  MMKit
//
//  Created by Dwang on 2018/5/5.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "UIBarButtonItem+MMKit.h"

@implementation UIBarButtonItem (MMKit)

+ (UIBarButtonItem *)mmkit_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[NSClassFromString(@"MMKit") class]].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"MMKitResouce.bundle/%@@2x.png", imageName]]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:target action:action];
    return item;
}

+ (UIBarButtonItem *)mmkit_itemWithCancelTarget:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:target action:action];
}

+ (UIBarButtonItem *)mmkit_flexibleSpace {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

@end
