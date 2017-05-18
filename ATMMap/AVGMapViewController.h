//
//  AVGMapViewController.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class AVGATMService;

@interface AVGMapViewController : UIViewController

@property (nonatomic, strong) AVGATMService *atmService;

- (void)scaleToAnnotationAtIndex:(NSInteger)index;

@end
