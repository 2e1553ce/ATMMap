//
//  AVGATMTableViewController.m
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMTableViewController.h"
#import "AVGATMService.h"
#import "AVGATMCell.h"
#import "AVGATM.h"
#import "AVGMapViewController.h"
#import "AVGControllerService.h"

@interface AVGATMTableViewController ()

@end

@implementation AVGATMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Список банкоматов"];
    [self.tableView registerClass:[AVGATMCell class] forCellReuseIdentifier:AVGATMCellIdentifier];
    
    UIBarButtonItem *updateCellInfoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          target:self
                                                                                          action:@selector(updateCellInfo:)];
    self.navigationItem.rightBarButtonItem = updateCellInfoButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - AVGTableControllerDelegate

- (void)moveFromAnnotationToTableRowAtIndex:(NSInteger)index {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.atmService.atms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVGATMCell *cell = [tableView dequeueReusableCellWithIdentifier:AVGATMCellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[AVGATMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AVGATMCellIdentifier];
    }
    AVGATM *atm = self.atmService.atms[indexPath.row];
    [cell addATM:atm withCheckParameter:self.atmService.isDistanceSet];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.atmService.isDistanceSet) {
        return [AVGATMCell extendedHeightForCell];
    } else {
        return [AVGATMCell standartHeightForCell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Get views. controllerIndex is passed in as the controller we want to go to.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:0] view];
    
    NSInteger controllerIndex = 0;
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(controllerIndex > self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionCrossDissolve)
                    completion:^(BOOL finished) {
                        if (finished) {
                            
                            self.tabBarController.selectedIndex = controllerIndex;
                            [self.controllerService.mapDelegate scaleToAnnotationAtIndex:indexPath.row];
                        }
                    }];
}

#pragma mark - Actions

- (void)updateCellInfo:(UIBarButtonItem *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self.atmService calculateTimeForAtms:self.atmService.atms withCompletionHandler:^(NSArray *atms, NSError *error) {
            
            self.atmService.atms = [self.atmService.atms sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                float dist1Float;
                float dist2Float;
                
                NSString *distance1 = ((AVGATM *)obj1).distance;
                NSString *checkForMeters1 = [distance1 substringFromIndex:distance1.length - 2];
                if (![checkForMeters1 isEqualToString:@"km"]) {
                    distance1 = [distance1 substringToIndex:distance1.length - 2];
                    dist1Float = [distance1 floatValue] * 0.001;
                } else {
                    distance1 = [distance1 substringToIndex:distance1.length - 3];
                    dist1Float = [distance1 floatValue];
                }
                
                NSString *distance2 = ((AVGATM *)obj2).distance;
                NSString *checkForMeters2 = [distance2 substringFromIndex:distance2.length - 2];
                if (![checkForMeters2 isEqualToString:@"km"]) {
                    distance2 = [distance2 substringToIndex:distance2.length - 2];
                    dist2Float = [distance2 floatValue] * 0.001;
                } else {
                    distance2 = [distance2 substringToIndex:distance2.length - 3];
                    dist2Float = [distance2 floatValue];
                }
                
                if (dist1Float >= dist2Float) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [self.tableView beginUpdates];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
            });
            
        }];
    });
}

@end
