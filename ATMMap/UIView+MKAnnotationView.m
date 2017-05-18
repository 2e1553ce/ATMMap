//
//  UIView+MKAnnotationView.m
//  ATMMap
//
//  Created by aiuar on 18.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MapKit.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]){
        return (MKAnnotationView*)self;
    }
    
    if (!self.superview){
        return nil;
    }
    
    return [self.superview superAnnotationView];
}

@end
