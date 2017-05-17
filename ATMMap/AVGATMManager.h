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
- (void)calculateDistanceAndTimeForAtms:(NSArray *)atms
                  withCompletionHandler:(void(^)(NSArray *atms, NSError *error))completion;

@end
/*
ToDo:
 4. 20 bankomatov cherez gcd sortirovat po udalennosti + pokazat skoko km , vremeni itd
 5. multi delegate + obshiy service?
 6. tableview
 6. cahche image v itunes - url hash ili md5
 7. check tetrad
 8. sberLogo v krug i ischezaet - potom poyavlyaetsya
 9. routes + dispatch + time + km
 12. vk+fb
 11. gcd foto telefon
 13. my idea for my application - APIIIIII
*/
