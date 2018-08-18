//
//  UIViewController+MMKit.m
//  MMKit
//
//  Created by Dwang on 2018/5/5.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "UIViewController+MMKit.h"
#import "UIBarButtonItem+MMKit.h"

@implementation UIViewController (MMKit)

- (UIBarButtonItem *)mmkit_itemWithImageName:(NSString *)imageName action:(SEL)action {
    return [UIBarButtonItem mmkit_itemWithImageName:imageName target:self action:action];
}

- (UIBarButtonItem *)mmkit_itemWithCancelAction:(SEL)action {
    return [UIBarButtonItem mmkit_itemWithCancelTarget:self action:action];
}

@end
