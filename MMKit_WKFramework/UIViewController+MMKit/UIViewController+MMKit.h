//
//  UIViewController+MMKit.h
//  MMKit
//
//  Created by Dwang on 2018/5/5.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MMKit)

- (UIBarButtonItem *)mmkit_itemWithImageName:(NSString *)imageName action:(SEL)action;

- (UIBarButtonItem *)mmkit_itemWithCancelAction:(SEL)action;

@end
