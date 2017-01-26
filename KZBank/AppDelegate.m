//
//  AppDelegate.m
//  KZBank
//
//  Created by Dymov, Yuri on 4/16/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//  This demo was developed in a very short time due to
//  inadequate deadline. Source code is not intended
//  for production use. Source code quality is the
//  worst I've developed for years and I am not proud of it.
//

#import "AppDelegate.h"
#import "SyncEngine.h"
#import "ViewController.h"
#import "KZDatabase.h"
#import "Cache.h"
#import <ADNavigationControllerDelegate.h>

@interface AppDelegate ()

@property (nonatomic, strong) ADNavigationControllerDelegate *_del;

@end

@implementation AppDelegate
@synthesize _del;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [KZDatabase getInstance];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[Cache viewController]];
    _del = [[ADNavigationControllerDelegate alloc] init];
    nc.delegate = _del;
    nc.navigationBarHidden = YES;
    self.window.rootViewController = nc;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[SyncEngine getInstance] syncAll];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
