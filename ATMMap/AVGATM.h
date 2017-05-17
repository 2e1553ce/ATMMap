//
//  AVGATM.h
//  ATMMap
//
//  Created by aiuar on 15.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@import Foundation;

@interface AVGATM : NSObject

@property (copy, nonatomic) NSString                    *name;
@property (copy, nonatomic) NSString                    *address;
@property (assign, nonatomic) CLLocationCoordinate2D    location;
@property (assign, nonatomic) BOOL                      isOpen;

@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSDate *time;

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                    location:(CLLocationCoordinate2D)location
                        open:(BOOL)open;

@end
