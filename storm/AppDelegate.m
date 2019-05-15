//
//  AppDelegate.m
//  storm
//
//  Created by kevin on 2019/5/13.
//  Copyright © 2019 jumu. All rights reserved.
//

#import "AppDelegate.h"
#import "AXWebViewController.h"
#import <JWCacheURLProtocol.h>
#import "MainViewController.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
#import "THNewFeatureController.h"

@interface AppDelegate ()

@end

static NSString *kCookieStoreKey = @"cookies";

@implementation AppDelegate

static NSString *kStoreKey = @"StoreKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    

    [self loadCookies];
    
    BOOL userHasOnboard = [[NSUserDefaults standardUserDefaults] boolForKey:kStoreKey];
    if (userHasOnboard) {
        [self normalStartup];
    }else{
        [self onboardStartup];
    }

    
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)onboardStartup{
   
    
    THNewFeatureController *vc = [THNewFeatureController new];
    vc.operation = ^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStoreKey];
        [self normalStartup];
    };
    self.window.rootViewController = vc;
}


-(void)normalStartup{
    //        NSString *url = @"http://taihaojie.cn/index.php/index/loanuser/userinfo.html";
    ////    NSString *url = @"http://taihaojie.cn/index.php/index/loanuser/login.html";
    //    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
    //    webVC.showsToolBar = YES;
    //    webVC.hidesBottomBarWhenPushed = YES;
    //    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
    //        webVC.webView.allowsLinkPreview = YES;
    //    }
    MainViewController *vc = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //    [self.navigationController pushViewController:webVC animated:YES];
    self.window.rootViewController = nav;
}

-(void)loadCookies{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kCookieStoreKey];
    if (dic) {
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:dic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
}


-(void)saveCookies{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in nCookies){
        if ([cookie isKindOfClass:[NSHTTPCookie class]]){
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                [mdic removeAllObjects];
                [mdic setObject:cookie.name   forKey:NSHTTPCookieName  ];
                [mdic setObject:cookie.value  forKey:NSHTTPCookieValue ];
                [mdic setObject:cookie.domain forKey:NSHTTPCookieDomain];
                [mdic setObject:cookie.path   forKey:NSHTTPCookiePath  ];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:mdic] forKey:kCookieStoreKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            }
        }
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveCookies];
}


@end
