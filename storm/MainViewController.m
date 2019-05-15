//
//  MainViewController.m
//  storm
//
//  Created by kevin on 2019/5/15.
//  Copyright © 2019 jumu. All rights reserved.
//

#import "MainViewController.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import "NJKWebViewProgress/NJKWebViewProgress.h"
#import "NJKWebViewProgress/NJKWebViewProgressView.h"
#import "UIViewPlaceholderView/UIView+PlaceholderView.h"
#import <AFNetworking/AFNetworking.h>

@implementation JKCookie

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}

@end


@interface MainViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,strong)JKCookie *cookie;

@property(nonatomic,strong)NSMutableDictionary *mdic;
@property(nonatomic,strong)NJKWebViewProgress *progressProxy;
@property(nonatomic,strong)NJKWebViewProgressView *webViewProgressView;
@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)UIBarButtonItem *refreshBarButtonItem;
@property(nonatomic,strong)UIBarButtonItem *backBarButtonItem;
@end

@implementation MainViewController



#pragma mark getters && setters ++++++++++++++++++++++++++++++++++++



- (UIBarButtonItem *)refreshBarButtonItem {
    if (_refreshBarButtonItem) return _refreshBarButtonItem;
    _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (_backBarButtonItem) return _backBarButtonItem;
    _backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backClicked:)];
    return _backBarButtonItem;
}


-(NSURLRequest *)request{
    if (!_request) {
        NSString *url = @"http://taihaojie.cn/index.php/index/loanuser/userinfo.html";
        _request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    return _request;
}

-(NSMutableDictionary *)mdic{
    if (!_mdic) {
        _mdic = [NSMutableDictionary dictionary];
    }
    return _mdic;
}


-(NJKWebViewProgress *)progressProxy{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}


-(NJKWebViewProgressView *)webViewProgressView{
    if (!_webViewProgressView) {
        CGRect navBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
        _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_webViewProgressView setProgress:0 animated:YES];
    }
    return _webViewProgressView;
}


-(UIWebView *)webview{
    if (!_webview) {
        _webview = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webview.delegate = self.progressProxy;
    }
    return _webview;
}

static NSString *kCookieStoreKey = @"cookies";
#pragma mark view lifes ++++++++++++++++++++++++++++++++++++
- (void)viewDidLoad {
    [super viewDidLoad];
    //https://www.jb51.net/article/111709.htm  参考
    [self loadCookies];
    [self setupSubviews];
    [self.webview loadRequest:self.request];

}


#pragma mark views++++++++++++++++++++++++++++++++++++
-(void)setupSubviews{
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.navigationController.navigationBar addSubview:self.webViewProgressView];
    self.navigationItem.rightBarButtonItems = @[self.refreshBarButtonItem];
    [self reachability];
}



#pragma mark actions++++++++++++++++++++++++++++++++++++

/***
 监测网络状态
 */
- (void)reachability{
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                NSLog(@"没有网络(断网)");
                [self.view cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
                    [self.webview loadRequest:self.request];
                }];
            }
                
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [self.view cq_removePlaceholderView];
                [self.webview loadRequest:self.request];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                [self.view cq_removePlaceholderView];
                [self.webview loadRequest:self.request];
                
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}


- (void)reloadClicked:(UIBarButtonItem *)sender {
    [self.webview reload];
}

- (void)backClicked:(UIBarButtonItem *)sender {
    [self.webview goBack];
}

-(void)loadCookies{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kCookieStoreKey];
    if (dic) {
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:dic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
}


-(void)refrehsCookies{
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in nCookies){
        if ([cookie isKindOfClass:[NSHTTPCookie class]]){
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                [self.mdic removeAllObjects];
                [self.mdic setObject:cookie.name   forKey:NSHTTPCookieName  ];
                [self.mdic setObject:cookie.value  forKey:NSHTTPCookieValue ];
                [self.mdic setObject:cookie.domain forKey:NSHTTPCookieDomain];
                [self.mdic setObject:cookie.path   forKey:NSHTTPCookiePath  ];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:self.mdic] forKey:kCookieStoreKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            }
        }
    }
}


#pragma mark delegates ############################################
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // URL actions
    /***
     如果当前显示的是错误页面 点击刷新的时候去请求主页
     */
    if ([request.URL.absoluteString isEqualToString:@"ax_network_error"]) {
        [self.webview loadRequest:self.request];
        return NO;
    }
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    [self refrehsCookies];
    
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem];
    }else{
        self.navigationItem.leftBarButtonItems = @[];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError");
    if (error.code == NSURLErrorCancelled) {
        [webView reload];
        return;
    }
    [self didFailLoadWithError:error];
    
}

- (void)didFailLoadWithError:(NSError *)error{
    
    
    NSLog(@"错误码是==========> %ld",error.code);
    
    
    
    NSString *errorUrlPath = @"";
    
    
    switch (error.code) {
        case NSURLErrorCannotFindHost://404
            errorUrlPath = [[NSBundle bundleForClass:NSClassFromString(@"AXWebViewController")] pathForResource:@"AXWebViewController.bundle/html.bundle/404" ofType:@"html"];
            break;
        case NSURLErrorNotConnectedToInternet://没网
        {
            [self.view cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
                [self.webview loadRequest:self.request];
            }];
        }
            break;
            
        default:
            errorUrlPath = [[NSBundle bundleForClass:NSClassFromString(@"AXWebViewController")] pathForResource:@"AXWebViewController.bundle/html.bundle/neterror" ofType:@"html"];
            break;
    }
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:errorUrlPath]];
    request.timeoutInterval = 30.0;
    request.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    [self.webview loadRequest:request];
    //显示顶部状态栏的菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.webViewProgressView setProgress:0.9 animated:YES];
    self.navigationItem.title = @"网页加载失败";
    

    /*
    _backgroundLabel.text = [NSString stringWithFormat:@"%@%@",AXWebViewControllerLocalizedString(@"load failed:", nil) , error.localizedDescription];
    self.navigationItem.title = AXWebViewControllerLocalizedString(@"load failed", nil);
    if (_navigationType == AXWebViewControllerNavigationBarItem) {
        [self updateNavigationItems];
    }
    if (_navigationType == AXWebViewControllerNavigationToolItem) {
        [self updateToolbarItems];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webViewController:didFailLoadWithError:)]) {
        [_delegate webViewController:self didFailLoadWithError:error];
    }
     */
   
}



#pragma mark delegates NJKWebViewProgressDelegate ############################################
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [self.webViewProgressView setProgress:progress animated:YES];
    self.title = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
}


@end
