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

@interface AVGATMTableViewController ()

@end

@implementation AVGATMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - Actions

- (void)updateCellInfo:(UIBarButtonItem *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        for (AVGATM *atm in self.atmService.atms) {
            CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.atmService.userLocation.latitude longitude:self.atmService.userLocation.longitude];
            CLLocation *atmLocation = [[CLLocation alloc] initWithLatitude:atm.location.latitude longitude:atm.location.longitude];
            NSInteger distanceInMeters = [userLocation distanceFromLocation:atmLocation];
            NSLog(@"%ld", (long)distanceInMeters);
            atm.distance = distanceInMeters;
        }
        [self.atmService calculateTimeForAtms:self.atmService.atms withCompletionHandler:^(NSArray *atms, NSError *error) {
            
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
