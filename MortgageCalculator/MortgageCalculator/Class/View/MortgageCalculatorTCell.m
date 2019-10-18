//
//  HouseLoanCalculatorTCell.m
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/25.
//  Copyright © 2019 JZY. All rights reserved.
//

#import "MortgageCalculatorTCell.h"

@interface MortgageCalculatorTCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *markLabel; //
@property (nonatomic, strong) UITextField *inputTf; // 输入框
@property (nonatomic, strong) UISegmentedControl *segControl; // 贷款方式

@end


@implementation MortgageCalculatorTCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.markLabel];
        [self.contentView addSubview:self.inputTf];
        [self.contentView addSubview:self.segControl];
        self.segControl.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(155, 30));
    }];
    
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.inputTf.mas_left).mas_offset(-10);
        make.centerY.height.mas_equalTo(self.contentView);
    }];
    
    [self.segControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(155, 30));
    }];
}

#pragma mark - public methods
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MortgageCalculatorTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
    }
    return cell;
}

- (void)setData:(id)data {    
    
    self.markLabel.text = data[@"mark"];
        
    if ([self.markLabel.text containsString:@"利率"]) {
        self.inputTf.keyboardType = UIKeyboardTypeDecimalPad;
    } else {
        self.inputTf.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    NSString *inputText = data[@"input"];
    self.inputTf.text = inputText;

    BOOL hideSegment = ![inputText isEqualToString:@"segment"];
    self.segControl.hidden = hideSegment;
    self.inputTf.hidden = !hideSegment;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *allText = [textField.text stringByAppendingString:string];
    
    if (self.cellType == HouseLoanCellType_Money) {
        return (textField.text.length < 4) || (string.length == 0);;
    } else if (self.cellType == HouseLoanCellType_Year) {
        NSInteger year = allText.integerValue;
        return (year < 31) || (string.length == 0);
    } else if (self.cellType == HouseLoanCellType_Rate) {
        CGFloat rate = allText.floatValue;
        if (rate > 99.99999) {
            return (rate < 100.f) || (string.length == 0);
        }
        return (allText.length < 9) || (string.length == 0);
    }
    
    return (textField.text.length < 4) || (string.length == 0);;
}


#pragma mark - getters
- (NSInteger)segmentValue {
    if (!self.segControl.isHidden) {
        return self.segControl.selectedSegmentIndex;
    }
    return 0;
}

- (NSString *)numberValue {
    if (self.inputTf.hasText) {
        return self.inputTf.text;
    }
    return nil;
}

- (UILabel *)markLabel {
    if (_markLabel == nil) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.font = Font(16);
        _markLabel.textColor = ColorFromRGB(0x393939);
    }
    return _markLabel;
}

- (UITextField *)inputTf {
    if (_inputTf == nil) {
        _inputTf = [[UITextField alloc] init];
        _inputTf.borderStyle = UITextBorderStyleRoundedRect;
        _inputTf.textColor = ColorFromRGB(0x393939);
        _inputTf.font = Font(16);
        _inputTf.delegate = self;
    }
    return _inputTf;
}

- (UISegmentedControl *)segControl {

    if (_segControl == nil) {
    
        NSArray *titles = @[@"等额本息", @"等额本金"];
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:titles];
        segControl.selectedSegmentIndex = 0;
        segControl.tintColor = ColorFromRGB(0x393939);
                
//        [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        _segControl = segControl;
    }
    return _segControl;
}


@end
