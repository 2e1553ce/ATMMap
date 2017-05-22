//
//  AVGControllerService.h
//  ATMMap
//
//  Created by aiuar on 19.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@protocol AVGMapControllerDelegate <NSObject>

@required
- (void)scaleToAnnotationAtIndex:(NSInteger)index;

@end

@protocol AVGTableControllerDelegate <NSObject>

@required
- (void)moveFromAnnotationToTableRowAtIndex:(NSInteger)index;

@end


@interface AVGControllerService : NSObject

@property (nonatomic, weak) id <AVGMapControllerDelegate> mapDelegate;
@property (nonatomic, weak) id <AVGTableControllerDelegate> tableDelegate;

@end
