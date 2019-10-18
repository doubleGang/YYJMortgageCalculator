//
//  HouseLoanCalResultTableViewCell.m
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/28.
//  Copyright © 2019 JZY. All rights reserved.
//

#import "HouseLoanCalResultTableViewCell.h"

@interface HouseLoanCalResultTableViewCell ()

@property (nonatomic, strong) UILabel *monthLabel; // 月份
@property (nonatomic, strong) UILabel *monthNeedLabel; // 月供
@property (nonatomic, strong) UILabel *benJinLabel; // 本金
@property (nonatomic, strong) UILabel *lixiLabel; // 利息
@property (nonatomic, strong) UILabel *residueLabel; // 剩余

@end

@implementation HouseLoanCalResultTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.monthLabel = makeLabel()];
        [self.contentView addSubview:self.monthNeedLabel = makeLabel()];
        [self.contentView addSubview:self.benJinLabel = makeLabel()];
        [self.contentView addSubview:self.lixiLabel = makeLabel()];
        [self.contentView addSubview:self.residueLabel = makeLabel()];        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(60);
    }];
            
    [self.monthNeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(84);
        make.centerY.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
    
    [self.benJinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.monthNeedLabel.mas_right).mas_offset(0);
        make.centerY.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
    
    [self.lixiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.benJinLabel.mas_right).mas_offset(0);
        make.centerY.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
    
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lixiLabel.mas_right).mas_offset(0);
        make.centerY.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
}

#pragma mark - public methods

- (void)setData:(CalculateResultMonthModel *)data {

    _data = data;
    self.monthLabel.text = data.nperString;
    self.monthNeedLabel.text = data.needPayString;
    self.benJinLabel.text = data.benjinString;
    self.lixiLabel.text = data.lixiString;
    self.residueLabel.text = data.surplusPayString;    
}

#pragma mark - private methods


static inline UILabel *makeLabel() {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = ColorFromRGB(0x393939);
    label.font = Font(14);
    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


#pragma mark - getters



@end
