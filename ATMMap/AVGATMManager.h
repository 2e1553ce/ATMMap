//
//  AVGATMManager.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@protocol AVGATMManager <NSObject>

@required
- (void)getATMsWithName:(NSString *)name
           nearLocation:(CLLocationCoordinate2D)coordinate
  withCompletionHandler:(void(^)(NSArray *atms, NSError *error))completion;

@optional
- (void)calculateTimeForAtms:(NSArray *)atms
                  withCompletionHandler:(void(^)(NSArray *atms, NSError *error))completion;

@end
