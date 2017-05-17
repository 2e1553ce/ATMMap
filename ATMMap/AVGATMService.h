//
//  AVGATMService.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMManager.h"

@interface AVGATMService : NSObject <AVGATMManager>

@property (nonatomic, copy) NSArray *atms;

@end
