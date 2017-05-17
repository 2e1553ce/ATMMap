//
//  AVGATMCell.m
//  ATMMap
//
//  Created by aiuar on 17.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGATMCell.h"
#import "AVGATM.h"
#import <Masonry.h>

NSString *const AVGATMCellIdentifier = @"AVGATMCellIdentifier";

@implementation AVGATMCell

#pragma mark - initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviewsWithATM];
    }
    
    return self;
}

#pragma mark - Constraints

- (void)createSubviewsWithATM {
    self.nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:12];
    
    self.addressLabel = [UILabel new];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.font = [UIFont systemFontOfSize:10];
    _addressLabel.textColor = UIColor.grayColor;
    
    self.distanceToBankLabel = [UILabel new];
    _distanceToBankLabel.textAlignment = NSTextAlignmentLeft;
    _distanceToBankLabel.font = [UIFont systemFontOfSize:10];
    _distanceToBankLabel.textColor = UIColor.grayColor;
    
    self.timeToBankLabel = [UILabel new];
    _timeToBankLabel.textAlignment = NSTextAlignmentLeft;
    _timeToBankLabel.font = [UIFont systemFontOfSize:10];
    _timeToBankLabel.textColor = UIColor.grayColor;
    
    [self addSubview:_nameLabel];
    [self addSubview:_addressLabel];
    [self addSubview:_distanceToBankLabel];
    [self addSubview:_timeToBankLabel];
    
    // Masonry
    UIView *superview = self;
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.top.equalTo(superview).with.offset(10);
        make.left.equalTo(superview).with.offset(15);
        make.right.equalTo(superview.mas_right).with.offset(-5);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(2);
        make.left.equalTo(superview).with.offset(15);
        make.right.equalTo(superview).with.offset(-5);
    }];
    
    [_distanceToBankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.top.equalTo(_addressLabel.mas_bottom).with.offset(2);
        make.left.equalTo(superview).with.offset(15);
        make.right.equalTo(superview.mas_right).with.offset(-5);
    }];
    
    [_timeToBankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.top.equalTo(_distanceToBankLabel.mas_bottom).with.offset(2);
        make.left.equalTo(superview).with.offset(15);
        make.right.equalTo(superview.mas_right).with.offset(-5);
    }];
}

- (void)addATM:(AVGATM *)atm withCheckParameter:(BOOL)check {
    
    if (atm.isOpen) {
        _nameLabel.text = [NSString stringWithFormat:@"Название: %@ - открыт", atm.name];
    } else {
        _nameLabel.text = [NSString stringWithFormat:@"Название: %@ - закрыт", atm.name];
    }
    
    _addressLabel.text = [NSString stringWithFormat:@"Адрес: %@.", atm.address];
    
    if (check) {
        if (atm.distance) {
            _distanceToBankLabel.text = [NSString stringWithFormat:@"Расстояние до банкомата: %ld метров.", (long)atm.distance];
        } else {
            _distanceToBankLabel.text = @"Расстояние до банкомата не определено.";
        }
        
        if (atm.time) {
            _timeToBankLabel.text = [NSString stringWithFormat:@"Примерно за %@.", atm.time];
        } else {
            _timeToBankLabel.text = @"Время не определено.";
        }
        
        
    } else {
        _distanceToBankLabel.text = @"";
        _timeToBankLabel.text = @"";
    }
}

+ (CGFloat)standartHeightForCell {
    return 54.f;
}

+ (CGFloat)extendedHeightForCell {
    return 84.f;
}

@end
