//
//  AVGATMTableViewController.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVGControllerService;

@interface AVGATMTableViewController : UITableViewController

@property (nonatomic, strong) AVGControllerService *controllerService;

@end