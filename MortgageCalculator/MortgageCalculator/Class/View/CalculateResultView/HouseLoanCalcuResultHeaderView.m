
//
//  HouseLoanCalcuResultHeaderView.m
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/28.
//  Copyright © 2019 JZY. All rights reserved.
//

#import "HouseLoanCalcuResultHeaderView.h"

@interface HouseLoanCalcuResultHeaderView ()

@property (nonatomic, strong) UILabel *monthNeedLabel; // 首月月供
@property (nonatomic, strong) UILabel *monthNeedValueLabel; // 首月月供

@property (nonatomic, strong) UIView *gjjBgView;
@property (nonatomic, strong) UILabel *gjjMoneyLabel;
@property (nonatomic, strong) UILabel *gjjMoneyValueLabel;
@property (nonatomic, strong) UILabel *gjjRateLabel;
@property (nonatomic, strong) UILabel *gjjRateValueLabel;
@property (nonatomic, strong) UILabel *gjjYearLabel;
@property (nonatomic, strong) UILabel *gjjYearValueLabel;

@property (nonatomic, strong) UIView *shBgView;
@property (nonatomic, strong) UILabel *shMoneyLabel;
@property (nonatomic, strong) UILabel *shMoneyValueLabel;
@property (nonatomic, strong) UILabel *shRateLabel;
@property (nonatomic, strong) UILabel *shRateValueLabel;
@property (nonatomic, strong) UILabel *shYearLabel;
@property (nonatomic, strong) UILabel *shYearValueLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *totalLixiLabel;
@property (nonatomic, strong) UILabel *totalMoneyLabel;

@property (nonatomic, assign) MortgageType type; //
@property (nonatomic, assign) CalculationMethod mode; //

@property (nonatomic, strong) CalculateResultModel *data;


@end

@implementation HouseLoanCalcuResultHeaderView


#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame mortgageType:(MortgageType)mortgageType calculateMethod:(CalculationMethod)calculateMethod
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ColorFromRGB(0xB1EB54);
        self.type = mortgageType;
        self.mode = calculateMethod;
    
        
        [self addSubview:self.monthNeedLabel = makeLabel(@"每月月供", 12)];
        [self addSubview:self.monthNeedValueLabel = makeLabel(nil, 40)];
        
        [self addSubview:self.gjjBgView];
        [self.gjjBgView addSubview:self.gjjMoneyLabel = makeLabel(@"公积金贷款总金额", 12)];
        [self.gjjBgView addSubview:self.gjjMoneyValueLabel = makeLabel(nil, 20)];
        [self.gjjBgView addSubview:self.gjjRateLabel = makeLabel(@"公积金贷利率", 12)];
        [self.gjjBgView addSubview:self.gjjRateValueLabel = makeLabel(nil, 20)];
        [self.gjjBgView addSubview:self.gjjYearLabel = makeLabel(@"公积贷款年限", 12)];
        [self.gjjBgView addSubview:self.gjjYearValueLabel = makeLabel(nil, 20)];
        
        [self addSubview:self.shBgView];
        [self.shBgView addSubview:self.shMoneyLabel = makeLabel(@"商业贷款总金额", 12)];
        [self.shBgView addSubview:self.shMoneyValueLabel = makeLabel(nil, 20)];
        [self.shBgView addSubview:self.shRateLabel = makeLabel(@"商业贷利率", 12)];
        [self.shBgView addSubview:self.shRateValueLabel = makeLabel(nil, 20)];
        [self.shBgView addSubview:self.shYearLabel = makeLabel(@"商业贷款年限", 12)];
        [self.shBgView addSubview:self.shYearValueLabel = makeLabel(nil, 20)];
        
        [self addSubview:self.lineView];
        [self addSubview:self.totalLixiLabel = makeLabel(nil, 18)];
        [self addSubview:self.totalMoneyLabel = makeLabel(nil, 18)];
        self.totalLixiLabel.textAlignment = NSTextAlignmentLeft;
        self.totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
                
        [self jzy_layoutSubviews];
    }
    return self;
}


#pragma mark - public methods
- (void)bindData:(CalculateResultModel *)data {
    _data = data;
        
    if (data.calculationMethod == CalculationMethod_BenJin) {
        self.monthNeedLabel.text = @"首月月供";
    }
    
    self.monthNeedValueLabel.text = data.monthResultArray.firstObject.needPayString;
    
    if (self.type == MortgageType_ZuHe) {        
        
        self.gjjMoneyValueLabel.text = [NSString stringWithFormat:@"%@万元", data.gjjDaiMoneyString];
        self.gjjRateValueLabel.text = data.gjjDaiRateString;
        self.gjjYearValueLabel.text = [NSString stringWithFormat:@"%lu年", (unsigned long)data.year];

        self.shMoneyValueLabel.text = [NSString stringWithFormat:@"%@万元", data.shangDaiMoneyString];
        self.shRateValueLabel.text = data.shangDaiRateString;
        self.shYearValueLabel.text = [NSString stringWithFormat:@"%lu年", (unsigned long)data.year];

    } else if (self.type == MortgageType_ShangDai) {
        
        self.gjjBgView.hidden = YES;
        self.shBgView.hidden = NO;
        self.shMoneyValueLabel.text = [NSString stringWithFormat:@"%@万元", data.shangDaiMoneyString];
        self.shRateValueLabel.text = data.shangDaiRateString;
        self.shYearValueLabel.text = [NSString stringWithFormat:@"%lu年", (unsigned long)data.year];

    } else if (self.type == MortgageType_GJJDai) {

        self.gjjBgView.hidden = NO;
        self.shBgView.hidden = YES;
        self.gjjMoneyValueLabel.text = [NSString stringWithFormat:@"%@万元", data.gjjDaiMoneyString];
        self.gjjRateValueLabel.text = data.gjjDaiRateString;
        self.gjjYearValueLabel.text = [NSString stringWithFormat:@"%lu年", (unsigned long)data.year];
    }
    

    NSString *totalLixi = [NSString stringWithFormat:@"累计利息（元）：%@", data.totalLixiString];
    NSString *totalMoney = [NSString stringWithFormat:@"累计还款金额（元）：%@", data.totalMoneyString];
    self.totalLixiLabel.attributedText = makeAttriText(totalLixi);
    self.totalMoneyLabel.attributedText = makeAttriText(totalMoney);
}

static inline NSAttributedString *makeAttriText(NSString *text) {

    NSArray *textArr = [text componentsSeparatedByString:@"："];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        
    NSRange range = [text rangeOfString:textArr.firstObject];
    range.length += 1;
    [attributedStr addAttribute:NSFontAttributeName value:Font(12) range:range];

    [attributedStr addAttribute:NSFontAttributeName value:Font(16) range:[text rangeOfString:textArr.lastObject]];
    return attributedStr.copy;
}



#pragma mark - private methods
static inline UILabel *makeLabel(NSString *text, CGFloat fontSize) {
    UILabel *label = [[UILabel alloc] init];
    label.font = Font(fontSize);
    label.textColor = ColorFromRGB(0x393939);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
}



#pragma mark - getters
- (UIView *)lineView  {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UIView *)gjjBgView {
    if (_gjjBgView == nil) {
        _gjjBgView = [[UIView alloc] init];
    }
    return _gjjBgView;
}

- (UIView *)shBgView {
    if (_shBgView == nil) {
        _shBgView = [[UIView alloc] init];
    }
    return _shBgView;
}



- (void)jzy_layoutSubviews {
//    [super layoutSubviews];
      
    [self.monthNeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 17));
    }];
    [self.monthNeedValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthNeedLabel.mas_bottom).mas_offset(0);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 48));
    }];
        
    [self.gjjBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.monthNeedValueLabel.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    [self.gjjMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(self.gjjBgView.mas_width).multipliedBy(0.33);
    }];
    [self.gjjMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.gjjMoneyLabel.mas_bottom);
        make.width.mas_equalTo(self.gjjBgView.mas_width).multipliedBy(0.33);
    }];
    [self.gjjRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.mas_equalTo(self.gjjMoneyLabel);
        make.centerX.mas_equalTo(self.gjjBgView);
    }];
    [self.gjjRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.bottom.mas_equalTo(self.gjjMoneyValueLabel);
        make.centerX.mas_equalTo(self.gjjBgView);
    }];
    [self.gjjYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.mas_equalTo(self.gjjMoneyLabel);
        make.right.mas_equalTo(self.gjjBgView);
    }];
    [self.gjjYearValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.bottom.mas_equalTo(self.gjjMoneyValueLabel);
        make.right.mas_equalTo(self.gjjBgView);
    }];

    
        
    if (self.type == MortgageType_ZuHe) {
        [self.shBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.gjjBgView.mas_bottom).mas_offset(0);
            make.height.mas_equalTo(40);
        }];
    } else {
        [self.shBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.monthNeedValueLabel.mas_bottom).mas_offset(0);
            make.height.mas_equalTo(40);
        }];
    }
    
    [self.shMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(self.shBgView.mas_width).multipliedBy(0.33);
    }];
    [self.shMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.shMoneyLabel.mas_bottom);
        make.width.mas_equalTo(self.shBgView.mas_width).multipliedBy(0.33);
    }];
    [self.shRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.mas_equalTo(self.shMoneyLabel);
        make.centerX.mas_equalTo(self.shBgView);
    }];
    [self.shRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.bottom.mas_equalTo(self.shMoneyValueLabel);
        make.centerX.mas_equalTo(self.shBgView);
    }];
    [self.shYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.mas_equalTo(self.shMoneyLabel);
        make.right.mas_equalTo(self.shBgView);
    }];
    [self.shYearValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.bottom.mas_equalTo(self.shMoneyValueLabel);
        make.right.mas_equalTo(self.shBgView);
    }];

    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(300, 17));
    }];
    
    [self.totalLixiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.totalMoneyLabel.mas_top).mas_offset(-13);
        make.size.mas_equalTo(CGSizeMake(300, 17));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.6);
        make.bottom.mas_equalTo(self.totalLixiLabel.mas_top).mas_offset(-17);
    }];
}


@end
