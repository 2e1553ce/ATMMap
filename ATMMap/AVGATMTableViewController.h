//
//  AVGATMTableViewController.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGControllerService.h"

@class AVGATMService;

@interface AVGATMTableViewController : UITableViewController <AVGTableControllerDelegate>

@property (nonatomic, strong) AVGATMService *atmService;
@property (nonatomic, strong) AVGControllerService *controllerService;

@end
