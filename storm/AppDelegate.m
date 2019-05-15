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

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString *kStoreKey = @"StoreKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    

    
    BOOL userHasOnboard = [[NSUserDefaults standardUserDefaults] boolForKey:kStoreKey];
    
   [self onboardStartup];
    
//    if (userHasOnboard) {
//        [self normalStartup];
//    }else{
//        [self onboardStartup];
//    }
//
    
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)onboardStartup{
   
    
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"What A Beautiful Photo" body:@"This city background image is so beautiful." image:[UIImage imageNamed:@"blue"] buttonText:@"Enable Location Services" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions, providing them useful information about why you'd like those permissions to enhance their experience, increasing your chances they will grant those permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:[UIImage imageNamed:@"red"] buttonText:@"Connect With Facebook" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup. As you can see, hitting the action button on the prior page brought you automatically to the next page. Cool, huh?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    secondPage.movesToNextViewController = YES;
    secondPage.viewDidAppearBlock = ^{
//        [[[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"You've arrived on the second page, and this alert was displayed from within the page's viewDidAppearBlock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    };
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStoreKey];
        [self normalStartup];
    }];
    
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;
    
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStoreKey];
        [self normalStartup];
    };
    
    self.window.rootViewController = onboardingVC;
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
}


@end
