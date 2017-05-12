//
//  AVGATMService.h
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVGATMManager.h"

@interface AVGATMService : NSObject <AVGATMManager>

@property (nonatomic, strong) NSURLSession *session;

@end
