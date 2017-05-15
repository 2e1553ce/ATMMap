//
//  AVGATM.m
//  ATMMap
//
//  Created by aiuar on 15.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATM.h"

@implementation AVGATM

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                    location:(CLLocationCoordinate2D)location
                        open:(BOOL)open {
    self = [super init];
    if (self) {
        _name       = name;
        _address    = address;
        _location   = location;
        _isOpen     = open;
    }
    return self;
}

@end
