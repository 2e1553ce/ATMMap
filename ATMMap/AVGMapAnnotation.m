//
//  AVGMapAnnotation.m
//  ATMMap
//
//  Created by aiuar on 15.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGMapAnnotation.h"

@implementation AVGMapAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
