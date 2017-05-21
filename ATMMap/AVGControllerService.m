//
//  AVGControllerService.m
//  ATMMap
//
//  Created by aiuar on 19.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGControllerService.h"

@implementation AVGControllerService

- (void)someMethod:(NSInteger)index {
    [self.mapDelegate scaleToAnnotationAtIndex:index];
}

@end
