//
//  AppDelegate.m
//  ATMMap
//
//  Created by aiuar on 11.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AppDelegate.h"
#import "AVGTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    AVGTabBarController *tabBarController = [AVGTabBarController new];

    window.rootViewController = tabBarController;
    self.window = window;
    [window makeKeyAndVisible];
    
    return YES;
}

@end
