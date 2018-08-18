//
//  UIBarButtonItem+MMKit.h
//  MMKit
//
//  Created by Dwang on 2018/5/5.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MMKit)

+ (UIBarButtonItem *)mmkit_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)mmkit_itemWithCancelTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)mmkit_flexibleSpace;

@end
