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

@property (nonatomic, assign) BOOL isDistanceSet;

@end

@implementation AVGATMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[AVGATMCell class] forCellReuseIdentifier:AVGATMCellIdentifier];
    self.isDistanceSet = NO;
    
    UIBarButtonItem *updateCellInfoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          target:self
                                                                                          action:@selector(updateCellInfo:)];
    self.navigationItem.rightBarButtonItem = updateCellInfoButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", _atmService.atms);
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
    cell.textLabel.text = atm.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDistanceSet) {
        return [AVGATMCell extendedHeightForCell];
    } else {
        return [AVGATMCell standartHeightForCell];
    }
}

#pragma mark - Actions

- (void)updateCellInfo:(UIBarButtonItem *)sender {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
