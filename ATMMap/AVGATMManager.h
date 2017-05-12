//
//  AVGATMManager.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@import Foundation;

@protocol AVGATMManager <NSObject>

@required
- (void)getATMsInfoFromServerWithCompletionHandler:(void(^)(NSArray *ATMs, NSError *error))completion;


@end
