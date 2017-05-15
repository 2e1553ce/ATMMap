//
//  AVGATMService.m
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMService.h"
#import "AVGATM.h"
#import <CoreLocation/CLLocation.h>

static NSString *const kGoogleApiKey = @"AIzaSyBbB51DvwL8-KRuLyXT7O81XpGWBZyBmv4";

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

- (void)getATMsWithName:(NSString *)name
           nearLocation:(CLLocationCoordinate2D)coordinate
  withCompletionHandler:(void(^)(NSArray *ATMs, NSError *error))completion {
    
    NSString *urlBaseString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
    NSString *urlParametersString = [NSString stringWithFormat:@"location=%f,%f&keyword=%@&key=%@&type=atm&rankby=distance&language=ru",
                                     coordinate.latitude,
                                     coordinate.longitude,
                                     name,
                                     kGoogleApiKey];
    NSString *query = [NSString stringWithFormat:@"%@%@", urlBaseString, urlParametersString];
    NSURL *url = [NSURL URLWithString:[query stringByAddingPercentEncodingWithAllowedCharacters:
                                       [NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[self.session dataTaskWithRequest:request
                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                         
                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                         dict = dict[@"results"];
                         
                         NSMutableArray *atms = [NSMutableArray arrayWithCapacity:[dict count]];
                         for (id object in dict) {
                             CLLocationCoordinate2D atmLocation;
                            #warning et norm? - [][][]
                             atmLocation.latitude = [object[@"geometry"][@"location"][@"lat"] floatValue];
                             atmLocation.longitude = [object[@"geometry"][@"location"][@"lng"] floatValue];
                             
                             BOOL isOpen = object[@"opening_hours"][@"open_now"];
                             
                             AVGATM *atm = [[AVGATM alloc] initWithName:object[@"name"] address:object[@"vicinity"] location:atmLocation open:isOpen];
                             [atms addObject:atm];
                         }
                         
                         if (completion) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completion(atms, error);
                             });
                         }
    }] resume];
}

@end
