//
//  AVGATMManager.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#warning for CLLocationCoordinat2D fix? forward decl
#import <CoreLocation/CLLocation.h>

@protocol AVGATMManager <NSObject>

@required
- (void)getATMsWithName:(NSString *)name
           nearLocation:(CLLocationCoordinate2D)coordinate
  withCompletionHandler:(void(^)(NSArray *ATMs, NSError *error))completion;

@end
