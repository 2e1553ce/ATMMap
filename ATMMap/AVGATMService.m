//
//  AVGATMService.m
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMService.h"
#import "AVGATM.h"

static NSString *const kGoogleApiKey = @"AIzaSyBbB51DvwL8-KRuLyXT7O81XpGWBZyBmv4";

@interface AVGATMService ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

@end

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
  withCompletionHandler:(void(^)(NSArray *atms, NSError *error))completion {
    
    if (self.sessionDataTask) {
        [self.sessionDataTask cancel];
    }
    
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

    self.sessionDataTask = [self.session dataTaskWithRequest:request
                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                         
                         if (data) {
                             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                             dict = dict[@"results"];
                             
                             NSMutableArray *atms = [NSMutableArray arrayWithCapacity:[dict count]];
                             for (id object in dict) {
                                 CLLocationCoordinate2D atmLocation;
                                 NSDictionary *geometry = object[@"geometry"];
                                 NSDictionary *location = geometry[@"location"];
                                 atmLocation.latitude   = [location[@"lat"] floatValue];
                                 atmLocation.longitude  = [location[@"lng"] floatValue];
                                 
                                 NSDictionary *openingHours = object[@"opening_hours"];
                                 BOOL isOpen = openingHours[@"open_now"];
                                 
                                 AVGATM *atm = [[AVGATM alloc] initWithName:object[@"name"] address:object[@"vicinity"] location:atmLocation open:isOpen];
                                 [atms addObject:atm];
                             }
                             self.atms = atms;
                             
                             if (completion) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     completion(self.atms, error);
                                 });
                             }
                         } else {
                             #warning надо ли?
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completion(nil, error);
                             });
                             return;
                         }
    }];
    [self.sessionDataTask resume];
}

- (void)calculateDistanceAndTimeForAtms:(NSArray *)atms withCompletionHandler:(void(^)(NSArray *atms, NSError *error))completion {
    
    
}

@end
