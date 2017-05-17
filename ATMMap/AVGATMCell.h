//
//  AVGATMCell.h
//  ATMMap
//
//  Created by aiuar on 17.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVGATM;

extern NSString *const AVGATMCellIdentifier;

@interface AVGATMCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView  *isOpenView;

@property (nonatomic, strong) UILabel *distanceToBankLabel;
@property (nonatomic, strong) UILabel *timeToBankLabel;

- (void)addATM:(AVGATM *)atm;

+ (CGFloat)standartHeightForCell;
+ (CGFloat)extendedHeightForCell;

@end
