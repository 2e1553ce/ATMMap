//
//  AVGControllerService.h
//  ATMMap
//
//  Created by aiuar on 19.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AVGControllerServiceDelegate <NSObject>

@optional

- (void)scaleToAnnotationAtIndex:(NSInteger)index;
- (void)moveFromAnnotationToTable;

@end

@interface AVGControllerService : NSObject

@property (nonatomic, weak) id <AVGControllerServiceDelegate> mapDelegate;
@property (nonatomic, weak) id <AVGControllerServiceDelegate> tableDelegate;

- (void)someMethod:(NSInteger)index;

@end
