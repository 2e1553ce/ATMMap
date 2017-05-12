//
//  AVGATMService.m
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMService.h"

@implementation AVGATMService

#pragma mark - initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    
    return self;
}


#pragma mark - AVGATMManager protocol

- (void)getATMsInfoFromServerWithCompletionHandler:(void(^)(NSArray *ATMs, NSError *error))completion {
    
}

@end
