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
    
    self.userLocation = coordinate;
    self.isDistanceSet = NO;
    
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
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completion(nil, error);
                             });
                             return;
                         }
    }];
    [self.sessionDataTask resume];
}

- (void)calculateTimeForAtms:(NSArray *)atms withCompletionHandler:(void(^)(NSArray *atms, NSError *error))completion {
    
    for (AVGATM *atm in atms) {
        CGFloat atmLatitude = atm.location.latitude;
        CGFloat atmLongitude = atm.location.longitude;
        
        CGFloat userLatitude = self.userLocation.latitude;
        CGFloat userLongitude = self.userLocation.longitude;
        
        NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=%@key=%@", atmLatitude,  atmLongitude, userLatitude,  userLongitude, @"DRIVING", kGoogleApiKey];
        NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                           [NSCharacterSet URLFragmentAllowedCharacterSet]]];
        // sleep(1); // иначе ответы через 1 пустые хз
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if(jsonData != nil)
        {
            NSError *error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            NSMutableArray *arrDistance=[result objectForKey:@"routes"];
            if ([arrDistance count]==0) {
                //NSLog(@"N.A.");
            }
            else{
                NSMutableArray *arrLeg=[[arrDistance objectAtIndex:0]objectForKey:@"legs"];
                NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
                //NSLog(@"%@",[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]]);
                //NSLog(@"%@",[NSString stringWithFormat:@"Estimated distance %@",[[dictleg   objectForKey:@"distance"] objectForKey:@"text"]]);
                
                atm.time = [[dictleg   objectForKey:@"duration"] objectForKey:@"text"];
                atm.distance = [[dictleg   objectForKey:@"distance"] objectForKey:@"text"];
            }
        }
        else{
            //NSLog(@"N.A.");
        }
    }
    self.isDistanceSet = YES;
    completion(atms, nil);
}

@end
