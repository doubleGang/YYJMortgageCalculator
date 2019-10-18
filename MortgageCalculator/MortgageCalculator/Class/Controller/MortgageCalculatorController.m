//
//  MortgageCalculatorController.m
//  MortgageCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "MortgageCalculatorController.h"
#import "CalculatorResultController.h"

#import "MortgageCalculator.h"
#import "MortgageCalculatorView.h"



@interface MortgageCalculatorController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
// 三种贷款类型 输入view
@property (nonatomic, copy) NSArray <MortgageCalculatorView *>*segControlArray;
// 计算按钮
@property (nonatomic, strong) UIButton *calculotorBtn;
// 计算器
@property (nonatomic, strong) MortgageCalculator *houseLoanCalcu;

@end

@implementation MortgageCalculatorController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房贷计算器";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.segmentControl];
    
    for (MortgageCalculatorView *view in self.segControlArray) {
        [self.view addSubview:view];
    }
    [self.view addSubview:self.calculotorBtn];

    
    [self jzy_layoutSubviews];
}

#pragma mark - event response
- (void)segmentControlValueChanged:(UISegmentedControl *)control {
    
    NSInteger selectedIndex = control.selectedSegmentIndex;
    
    self.segControlArray[0].hidden = selectedIndex != 0;
    self.segControlArray[1].hidden = selectedIndex != 1;
    self.segControlArray[2].hidden = selectedIndex != 2;
    
}

- (void)calculotorBtnAction {
    
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    if (index < self.segControlArray.count) {
        
        // 判断信息是否完整
        if (![self loanInfoIsComplete:index]) {
            [ToolObj showMessage:@"请填写完整"];
            return;
        }
        
        // 商贷金额 (万元)
        NSInteger shangDaiMoney = self.segControlArray[index].shangLoanAmount.integerValue;
        // 年利率
        CGFloat shangDaiRate = self.segControlArray[index].shangLoanRate.floatValue;

        // 公积金贷金额 (万元)
        NSInteger gjjDaiMoney = self.segControlArray[index].gjjLoanAmount.integerValue;
        CGFloat gjjDaiRate = self.segControlArray[index].gjjLoanRate.floatValue;

        // 贷款年限、计算方式
        NSInteger yearCount = self.segControlArray[index].loanOfYear.integerValue;
        CalculationMethod calculateMode = self.segControlArray[index].loanMode;
        
        CalculateResultModel *resultModel = nil;
        
        if (index == 2) { // 混合贷
            
            if (shangDaiMoney <= 0 || gjjDaiMoney <= 0) {
                [ToolObj showMessage:@"请输入有效贷款金额"];
                return;
            }
            
            if (yearCount <= 0) {
                [ToolObj showMessage:@"请输入有效贷款年限"];
                return;
            }
            
            resultModel = [MortgageCalculator zuheDaiCalculateWithGJJYearRate:gjjDaiRate shangYearRate:shangDaiRate gjjMoney:gjjDaiMoney shangMoney:shangDaiMoney yearCount:yearCount mortgageType:MortgageType_ZuHe calculateMethod:calculateMode];

        } else { // 商贷、公积金贷
                      
            if ((index == 0 && shangDaiMoney <= 0) || (index == 1 && gjjDaiMoney <= 0)) {
                [ToolObj showMessage:@"请输入有效贷款金额"];
                return;
            }
            
            if (yearCount <= 0) {
                [ToolObj showMessage:@"请输入有效贷款年限"];
                return;
            }
            
            // 总金额、贷款方式、年利率
            NSUInteger totalMoney = index == 0 ? shangDaiMoney : gjjDaiMoney;
            MortgageType mortgageType = index == 0 ? MortgageType_ShangDai : MortgageType_GJJDai;
            CGFloat rate = index == 0 ? shangDaiRate : gjjDaiRate;
            
            resultModel = [MortgageCalculator calculateMortgageInfoWithYearRate:rate yearCount:yearCount totalMoney:totalMoney mortgageType:mortgageType calculateMethod:calculateMode];
        }
        
        CalculatorResultController *vc = [[CalculatorResultController alloc] init];
        vc.resultModel = resultModel;
        [self.navigationController pushViewController:vc animated:YES];

    }
}


#pragma mark - private methods
// 判断贷款信息是否完整
- (BOOL)loanInfoIsComplete:(NSInteger)index {
    if (index == 0) { // 商贷
        if (!self.segControlArray[index].shangLoanAmount ||
            !self.segControlArray[index].loanOfYear ||
            !self.segControlArray[index].shangLoanRate) {
            return NO;
        }
    } else if (index == 1) { // 公积金贷
        if (!self.segControlArray[index].gjjLoanAmount ||
            !self.segControlArray[index].loanOfYear ||
            !self.segControlArray[index].gjjLoanRate) {
            return NO;
        }
    } else if (index == 2) { // 混合贷
        if (!self.segControlArray[index].gjjLoanAmount ||
            !self.segControlArray[index].loanOfYear ||
            !self.segControlArray[index].gjjLoanRate ||
            !self.segControlArray[index].shangLoanAmount ||
            !self.segControlArray[index].shangLoanRate) {
            return NO;
        }
    }
    return YES;
}


- (void)jzy_layoutSubviews {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(52);
    }];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(30);
    }];
    
    for (NSInteger i = 0; i < self.segControlArray.count; i++) {
    
        MortgageCalculatorView *view = self.segControlArray[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo((i == 2 ? 300 : 200));
        }];
    }

    [self.calculotorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-140);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(316, 50));
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - getters
- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = ColorFromRGB(0xB1EB54);
    }
    return _headerView;
}

- (UISegmentedControl *)segmentControl {

    if (_segmentControl == nil) {
        NSArray *titles = @[@"商业贷款", @"公积金贷款", @"组合贷款"];
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:titles];
        segControl.selectedSegmentIndex = 0;
        segControl.tintColor = ColorFromRGB(0x393939);
                
        [segControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentControl = segControl;
    }
    
    return _segmentControl;
}

- (NSArray<MortgageCalculatorView *> *)segControlArray {
    if (_segControlArray == nil) {
        NSMutableArray *muArr = @[].mutableCopy;
        for (NSInteger i = 0; i < 3; i++) {
            MortgageCalculatorView *seg = [[MortgageCalculatorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (i == 2 ? 300 : 200)) loansType:i];
            
            seg.hidden = (i != 0);
            [muArr addObject:seg];
        }
        _segControlArray = muArr.copy;
    }
    return _segControlArray;
}

- (UIButton *)calculotorBtn {
    if (_calculotorBtn == nil) {
        _calculotorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calculotorBtn setTitle:@"计 算" forState:UIControlStateNormal];
        [_calculotorBtn setBackgroundColor:ColorFromRGB(0xB1EB54)];
        [_calculotorBtn setTitleColor:ColorFromRGB(0x393939) forState:UIControlStateNormal];
        [_calculotorBtn addTarget:self action:@selector(calculotorBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _calculotorBtn.titleLabel.font = Font(18);
        _calculotorBtn.layer.masksToBounds = YES;
        _calculotorBtn.layer.cornerRadius = 6.0;
    }
    return _calculotorBtn;
}

- (MortgageCalculator *)houseLoanCalcu {
    if (_houseLoanCalcu == nil) {
        _houseLoanCalcu = [MortgageCalculator new];
    }
    return _houseLoanCalcu;
}

@end
