//
//  AppDelegate.m
//  ATMMap
//
//  Created by aiuar on 11.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AppDelegate.h"
#import "AVGATMTableViewController.h"
#import "AVGMapViewController.h"
#import "AVGControllerService.h"

@interface AppDelegate ()
{
    AVGControllerService *_controllerService;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UITabBarController *tabBarController = [UITabBarController new];
    
    
    UINavigationController *mapNavigationController = [UINavigationController new];
    mapNavigationController.tabBarItem.title = @"Карта";
    mapNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.f, -10.f);
    
    UINavigationController *tableNavigationController = [UINavigationController new];
    tableNavigationController.tabBarItem.title = @"Список";
    tableNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.f, -10.f);
    
    _controllerService = [AVGControllerService new];
    
    AVGMapViewController *mapViewController = [AVGMapViewController new];
    mapViewController.controllerService = _controllerService;
    mapNavigationController.viewControllers = @[mapViewController];
    
    [mapViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-100, -100)];
    
    AVGATMTableViewController *atmTableViewController = [AVGATMTableViewController new];
    atmTableViewController.controllerService = _controllerService;
    tableNavigationController.viewControllers = @[atmTableViewController];
    
    tabBarController.viewControllers = @[mapNavigationController, tableNavigationController];
    
    window.rootViewController = tabBarController;
    self.window = window;
    [window makeKeyAndVisible];
    
    return YES;
}

@end
