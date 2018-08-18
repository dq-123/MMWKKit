//
//  MMKitWKViewController.m
//  MMKit
//
//  Created by Dwang on 2018/5/13.
//  Copyright © 2018年 CoderDwang. All rights reserved.
//

#import "MMKitWKViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIBarButtonItem+MMKit.h"
#import "UIViewController+MMKit.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

#define ToolBarHeight (self.portraitHiddenToolBar?0:44)

@interface MMKitWKViewController ()<WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, copy) NSString *baseUrlString;

@property (nonatomic, strong) Reachability *reach;

@property(nonatomic, strong) WKWebView *webView;

@property(nonatomic, strong) UIProgressView *progressView;

@property(nonatomic, strong) UIToolbar *toolBar;

@end

@implementation MMKitWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self.reach startNotifier];
    [self mmkit_initWithWebUrlString:self.urlString];
}

- (void)reachabilityChanged:(NSNotification*)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        __weak __typeof(self)weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备当前似乎没有可用网络" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (weakSelf.webView.canGoBack) {
                [weakSelf.webView reload];
            }else {
                [self mmkit_resetConfig];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)mmkit_initWithWebUrlString:(NSString *)urlString {
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        self.baseUrlString = urlString;
    }else {
        self.baseUrlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    
    NSLog(@"开始加载地址:%@", self.baseUrlString);
    
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.webView];
    [self mmkit_resetConfig];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (WKWebView *)webView {
    if (!_webView) {
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [userContentController addUserScript:script];
        WKProcessPool *processPool = [[WKProcessPool alloc] init];
        WKWebViewConfiguration *webViewController = [[WKWebViewConfiguration alloc] init];
        webViewController.processPool = processPool;
        webViewController.allowsInlineMediaPlayback = YES;
        webViewController.userContentController = userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, SCREEN_BOUNDS.height-ToolBarHeight) configuration:webViewController];
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        if (self.saveImage) {
            UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mmkit_longPressed:)];
            longPressed.delegate = self;
            longPressed.minimumPressDuration = .5f;
            [_webView addGestureRecognizer:longPressed];
        }
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (![webView.backForwardList.currentItem.URL.absoluteString isEqualToString:webView.URL.absoluteString]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
        self.progressView.hidden = NO;
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view bringSubviewToFront:self.progressView];
    }
    [self mmkit_cancelToolBar];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self mmkit_defaultToolBar];
    [self mmkit_updateToolBar];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self mmkit_defaultToolBar];
    [self mmkit_updateToolBar];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = [NSString stringWithFormat:@"%@",navigationAction.request.URL.absoluteString];
    if ([self mmkit_jumpToAppWithUrlString:urlString] ||
        [self mmkit_jumpToAppStoreWithUrlString:urlString] ||
        [self mmkit_jumpToSafariWithUrlString:urlString]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {completionHandler(YES);}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){completionHandler(NO);}]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { completionHandler();}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential * card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{ decisionHandler(WKNavigationResponsePolicyAllow);}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}

- (void)mmkit_longPressed:(UIGestureRecognizer*)ges {
    CGPoint point = [ges locationInView:self.webView];
    __weak __typeof(self)weakSelf = self;
    NSString *jsStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src",point.x,point.y];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if ([obj length]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showHUDAddedTo:weakSelf.webView animated:YES];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj]]];
                if (image) {
                    UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }else {
                    [MBProgressHUD hideHUDForView:weakSelf.webView animated:YES];
                    UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"保存失败" message:@"图片保存失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                    [alertError addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [weakSelf presentViewController:alertError animated:YES completion:nil];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (error) {
        alert.title = @"图片保存失败，无法访问相册";
        alert.message = @"请在“设置>隐私>照片”打开相册访问权限";
    }else{
        alert.message = @"图片保存成功";
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height-ToolBarHeight, SCREEN_BOUNDS.width, ToolBarHeight)];
        NSMutableArray <UIBarButtonItem *>*items = [NSMutableArray array];
        [items addObject:[self mmkit_itemWithImageName:@"首页" action:@selector(mmkit_homeDidClick)]];
        [items addObject:[UIBarButtonItem mmkit_flexibleSpace]];
        [items addObject:[self mmkit_itemWithImageName:@"返回" action:@selector(mmkit_backDidClick)]];
        [items addObject:[UIBarButtonItem mmkit_flexibleSpace]];
        [items addObject:[self mmkit_itemWithImageName:@"前进" action:@selector(mmkit_forwardDidClick)]];
        [items addObject:[UIBarButtonItem mmkit_flexibleSpace]];
        [items addObject:[self mmkit_itemWithImageName:@"刷新" action:@selector(mmkit_reloadDidClick)]];
        if (self.exit) {
            [items addObject:[UIBarButtonItem mmkit_flexibleSpace]];
            [items addObject:[self mmkit_itemWithImageName:@"退出" action:@selector(mmkit_exitDidClick)]];
        }
        _toolBar.items = items;
    }
    return _toolBar;
}

- (void)mmkit_homeDidClick {
    [self mmkit_resetConfig];
}

- (void)mmkit_backDidClick {
    [self.webView goBack];
    [self mmkit_updateToolBar];
}

- (void)mmkit_forwardDidClick {
    [self.webView goForward];
    [self mmkit_updateToolBar];
}

- (void)mmkit_reloadDidClick {
    if ([self.webView canGoBack]) {
        [self.webView reload];
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
    }
}

- (void)mmkit_cancelDidClick {
    [self.webView stopLoading];
    [self mmkit_defaultToolBar];
}

- (void)mmkit_exitDidClick {
    exit(0);
}

- (void)mmkit_resetConfig {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
}

- (void)mmkit_updateToolBar {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self mmkit_dismis];
    self.toolBar.items[0].enabled = self.webView.canGoBack;
    self.toolBar.items[2].enabled = self.webView.canGoBack;
    self.toolBar.items[4].enabled = self.webView.canGoForward;
}

- (void)mmkit_cancelToolBar {
    NSMutableArray <UIBarButtonItem *>*toolItems = [NSMutableArray arrayWithArray:self.toolBar.items];
    [toolItems replaceObjectAtIndex:6 withObject:[self mmkit_itemWithCancelAction:@selector(mmkit_cancelDidClick)]];
    self.toolBar.items = toolItems;
}

- (void)mmkit_defaultToolBar {
    NSMutableArray <UIBarButtonItem *>*toolItems = [NSMutableArray arrayWithArray:self.toolBar.items];
    [toolItems replaceObjectAtIndex:6 withObject:[self mmkit_itemWithImageName:@"刷新" action:@selector(mmkit_reloadDidClick)]];
    self.toolBar.items = toolItems;
}

- (BOOL)mmkit_jumpToAppWithUrlString:(NSString *)urlString {
    if ([urlString hasPrefix:@"mqq"] ||
        [urlString hasPrefix:@"weixin"] ||
        [urlString hasPrefix:@"alipay"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            NSString *appurl = [urlString hasPrefix:@"alipay"]?@"https://itunes.apple.com/cn/app/%E6%94%AF%E4%BB%98%E5%AE%9D-%E8%AE%A9%E7%94%9F%E6%B4%BB%E6%9B%B4%E7%AE%80%E5%8D%95/id333206289?mt=8":([urlString hasPrefix:@"weixin"]?@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8":@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"该设备未安装%@客户端", [urlString hasPrefix:@"mqq"]?@"QQ":([urlString hasPrefix:@"weixin"]?@"微信":@"支付宝")] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"立即安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appurl]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
                }else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"前往App Store失败，请稍后再试。" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return YES;
    }
    return NO;
}

- (BOOL)mmkit_jumpToSafariWithUrlString:(NSString *)urlString {
    __weak __typeof(self)weakSelf = self;
    __block BOOL result = NO;
    if (self.safariSchemes.count) {
        [self.safariSchemes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([urlString containsString:obj]) {
                [weakSelf mmkit_jumpSafariWithUrlString:urlString];
                result = YES;
                *stop = YES;
            }else {
                result = NO;
            }
        }];
    }
    if ([urlString containsString:self.safariTag]) {
        [self mmkit_jumpSafariWithUrlString:[urlString stringByReplacingOccurrencesOfString:self.safariTag withString:@""]];
        result = YES;
    }
    return result;
}

- (void)mmkit_jumpSafariWithUrlString:(NSString *)urlString {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"即将前往 Safari，是否同意？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"前往 %@ 失败，请稍后再试。", urlString] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)mmkit_jumpToAppStoreWithUrlString:(NSString *)urlString {
    if([urlString containsString:@"itunes.apple.com"] ||
       [urlString containsString:@"itms-services:"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"即将前往 App Store，是否前往？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"前往App Store失败，请稍后再试。" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return YES;
    }
    return NO;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, 1)];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)mmkit_dismis {
    self.progressView.hidden = YES;
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (self.autoHiddenToolBar) {
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight) {
            self.webView.frame = CGRectMake(0, 0, size.width, size.height-ToolBarHeight);
            self.toolBar.frame = CGRectMake(0, size.height-ToolBarHeight, size.width, ToolBarHeight);
            self.toolBar.hidden = NO;
        }else {
            self.webView.frame = CGRectMake(0, 0, size.width, size.height);
            self.toolBar.hidden = YES;
        }
    }else {
        self.webView.frame = CGRectMake(0, 0, size.width, size.height-ToolBarHeight);
        self.toolBar.frame = CGRectMake(0, size.height-ToolBarHeight, size.width, ToolBarHeight);
    }
}

@end

