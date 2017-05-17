//
//  AVGATMCell.m
//  ATMMap
//
//  Created by aiuar on 17.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMCell.h"

NSString *const AVGATMCellIdentifier = @"AVGATMCellIdentifier";

@implementation AVGATMCell

#pragma mark - initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self createSubviewsWithATM];
    }
    
    return self;
}

#pragma mark - Constraints
/*
 @property (nonatomic, strong) UILabel *nameLabel;
 @property (nonatomic, strong) UILabel *addressLabel;
 @property (nonatomic, strong) UIView  *isOpenView;
 
 @property (nonatomic, strong) UILabel *distanceToBankLabel;
 @property (nonatomic, strong) UILabel *timeToBankLabel;
 */



- (void)addATM:(AVGATM *)atm {
    
}

+ (CGFloat)standartHeightForCell {
    return 100.f;
}

+ (CGFloat)extendedHeightForCell {
    return 150.f;
}

@end
