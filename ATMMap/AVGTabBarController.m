//
//  AVGTabBarController.m
//  ATMMap
//
//  Created by aiuar on 18.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGTabBarController.h"
#import "AVGATMTableViewController.h"
#import "AVGMapViewController.h"
#import "AVGATMService.h"
#import "AVGControllerService.h"

@interface AVGTabBarController ()

@end

@implementation AVGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation controllers
    UINavigationController *mapNavigationController = [UINavigationController new];
    mapNavigationController.tabBarItem.title = @"Карта";
    mapNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.f, -10.f);
    
    UINavigationController *tableNavigationController = [UINavigationController new];
    tableNavigationController.tabBarItem.title = @"Список";
    tableNavigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.f, -10.f);
    
    // Network service
    AVGATMService *service = [AVGATMService new];
    // Controller service
    AVGControllerService *controllerService = [AVGControllerService new];
    
    // Map view controller
    AVGMapViewController *mapViewController = [AVGMapViewController new];
    mapViewController.atmService = service;
    mapViewController.controllerService = controllerService;
    mapNavigationController.viewControllers = @[mapViewController];
    
    [mapViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-100, -100)];
    
    // Table view controller
    AVGATMTableViewController *atmTableViewController = [AVGATMTableViewController new];
    atmTableViewController.atmService = service;
    atmTableViewController.controllerService = controllerService;
    tableNavigationController.viewControllers = @[atmTableViewController];
    
    // Setting Tabbar controller
    self.viewControllers = @[mapNavigationController, tableNavigationController];
}

@end
