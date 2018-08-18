//
//  MMKitWaitViewController.m
//  MMKit
//
//  Created by Dwang on 2018/5/14.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "MMKitWaitViewController.h"

@interface MMKitWaitViewController ()

@end

@implementation MMKitWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UILabel *wait = [[UILabel alloc] initWithFrame:self.view.bounds];
        wait.text = @"请稍后...";
        wait.textAlignment = NSTextAlignmentCenter;
        wait.font = [UIFont systemFontOfSize:18];
        wait.textColor = [UIColor grayColor];
        [self.view addSubview:wait];
    }
    return self;
}

- (instancetype)initWithLaunchImage:(UIImage *)LaunchImage {
    self = [super init];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:self.view.bounds];
        img.image = LaunchImage;
        [self.view addSubview:img];
    }
    return self;
}

- (instancetype)initWithWaitString:(NSString *)waitString {
    self = [super init];
    if (self) {
        UILabel *wait = [[UILabel alloc] initWithFrame:self.view.bounds];
        wait.numberOfLines = 0;
        wait.text = waitString;
        wait.textAlignment = NSTextAlignmentCenter;
        wait.font = [UIFont systemFontOfSize:18];
        wait.textColor = [UIColor grayColor];
        [self.view addSubview:wait];
    }
    return self;
}

@end
