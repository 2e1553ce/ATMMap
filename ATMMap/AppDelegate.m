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
    
    // Navigation controllers
    UINavigationController *mapNavigationController = [UINavigationController new];
    mapNavigationController.tabBarItem.title = @"Карта";
    mapNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.f, -10.f);
    
    UINavigationController *tableNavigationController = [UINavigationController new];
    tableNavigationController.tabBarItem.title = @"Список";
    tableNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.f, -10.f);
    
    _controllerService = [AVGControllerService new];
    
    // Map view controller
    AVGMapViewController *mapViewController = [AVGMapViewController new];
    mapViewController.controllerService = _controllerService;
    mapNavigationController.viewControllers = @[mapViewController];
    
    [mapViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-100, -100)];
    
    // Table view controller
    AVGATMTableViewController *atmTableViewController = [AVGATMTableViewController new];
    atmTableViewController.controllerService = _controllerService;
    tableNavigationController.viewControllers = @[atmTableViewController];
    
    // Setting Tabbar controller
    tabBarController.viewControllers = @[mapNavigationController, tableNavigationController];
    
    window.rootViewController = tabBarController;
    self.window = window;
    [window makeKeyAndVisible];
    
    return YES;
}

@end
