//
//  MortgageCalculatorView.m
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/25.
//  Copyright © 2019 JZY. All rights reserved.
//

#import "MortgageCalculatorView.h"
#import "MortgageCalculatorTCell.h"

@interface MortgageCalculatorView () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) MortgageType mode; // 贷款方式（商贷/公积金贷/组合贷）
@property (nonatomic, assign) CalculationMethod loanMode; // 贷款模式（本息/本金）

@property (nonatomic, copy) NSArray <NSDictionary *>*shangDaiTextArray;;
@property (nonatomic, copy) NSArray <NSDictionary *>*gongJJDaiTextArray;;
@property (nonatomic, copy) NSArray <NSDictionary *>*zuHeDaiTextArray;;

@end

@implementation MortgageCalculatorView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame loansType:(MortgageType)loansMode {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        self.mode = loansMode;
        self.loanMode = CalculationMethod_BenXi;

        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.mode == MortgageType_ShangDai) {
        return self.shangDaiTextArray.count;
    } else if (self.mode == MortgageType_GJJDai) {
        return self.gongJJDaiTextArray.count;
    } else if (self.mode == MortgageType_ZuHe) {
        return self.zuHeDaiTextArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MortgageCalculatorTCell *cell = [MortgageCalculatorTCell cellWithTableView:tableView];
    if (self.mode == MortgageType_ShangDai) {
        [cell setData:self.shangDaiTextArray[indexPath.row]];
    } else if (self.mode == MortgageType_GJJDai) {
        [cell setData:self.gongJJDaiTextArray[indexPath.row]];
    } else if (self.mode == MortgageType_ZuHe) {
        [cell setData:self.zuHeDaiTextArray[indexPath.row]];
    }
    
    if (indexPath.row == 0) {
        cell.cellType = HouseLoanCellType_Money;
    } else if (indexPath.row == 1) {
        cell.cellType = HouseLoanCellType_Rate;
    } else {
        
        if ((self.mode == MortgageType_ShangDai || self.mode == MortgageType_GJJDai) && indexPath.row == 2) {
            cell.cellType = HouseLoanCellType_Year;
        } else if (self.mode == MortgageType_ZuHe) {
            if (indexPath.row == 2) {
                cell.cellType = HouseLoanCellType_Money;
            } else if (indexPath.row == 3) {
                cell.cellType = HouseLoanCellType_Rate;
            } else if (indexPath.row == 4) {
                cell.cellType = HouseLoanCellType_Year;
            }
        }        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



#pragma mark - getters
#pragma mark - 商贷信息
// 商贷贷款金额
- (NSString *)shangLoanAmount {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MortgageCalculatorTCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.mode == MortgageType_ShangDai) {
                
        return cell.numberValue;
        
    } else if (self.mode == MortgageType_ZuHe) {
        
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        return cell.numberValue;
    }
    return nil;
}

- (NSString *)shangLoanRate {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    MortgageCalculatorTCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.mode == MortgageType_ShangDai) {
        
        return cell.numberValue;

    } else if (self.mode == MortgageType_ZuHe) {
        
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        return cell.numberValue;
    }
    return nil;
}

#pragma mark - 公积金贷信息
// 公积金贷款金额
- (NSString *)gjjLoanAmount {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MortgageCalculatorTCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.mode == MortgageType_GJJDai || self.mode == MortgageType_ZuHe) {
        return cell.numberValue;
    }
    return nil;
}

// 公积金贷款利率
- (NSString *)gjjLoanRate {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    MortgageCalculatorTCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.mode == MortgageType_GJJDai || self.mode == MortgageType_ZuHe) {
        return cell.numberValue;
    }
    return nil;
}


// 贷款年限
- (NSString *)loanOfYear {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    MortgageCalculatorTCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.mode == MortgageType_ShangDai || self.mode == MortgageType_GJJDai) {
        
        return cell.numberValue;
        
    } else if (self.mode == MortgageType_ZuHe) {
        
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        return cell.numberValue;
    }
    return nil;
}

// 贷款模式（本息/本金）
- (CalculationMethod)loanMode {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    MortgageCalculatorTCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.mode == MortgageType_ShangDai || self.mode == MortgageType_GJJDai) {
                
        return cell.segmentValue;
        
    } else if (self.mode == MortgageType_ZuHe) {
        
        indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        return cell.segmentValue;
    }
    return CalculationMethod_BenXi;
}

- (NSArray<NSDictionary *> *)shangDaiTextArray {
    if (_shangDaiTextArray == nil) {
        _shangDaiTextArray = @[@{@"mark" : @"商业贷款金额（万元）", @"input" : @""},
                               @{@"mark" : @"商业贷款利率（%）", @"input" : @"4.9"},
                               @{@"mark" : @"贷款年限", @"input" : @""},
                               @{@"mark" : @"贷款方式", @"input" : @"segment"}];
    }
    return _shangDaiTextArray;
}

- (NSArray<NSDictionary *> *)gongJJDaiTextArray {
    if (_gongJJDaiTextArray == nil) {
        _gongJJDaiTextArray = @[@{@"mark" : @"公积金贷款金额（万元）", @"input" : @""},
                               @{@"mark" : @"公积金款利率（%）", @"input" : @"3.25"},
                               @{@"mark" : @"贷款年限", @"input" : @""},
                               @{@"mark" : @"贷款方式", @"input" : @"segment"}];
    }
    return _gongJJDaiTextArray;
}

- (NSArray<NSDictionary *> *)zuHeDaiTextArray {
    if (_zuHeDaiTextArray == nil) {
        _zuHeDaiTextArray = @[@{@"mark" : @"公积金贷款金额（万元）", @"input" : @""},
                              @{@"mark" : @"公积金款利率（%）", @"input" : @"3.25"},
                              @{@"mark" : @"商业贷款金额（万元）", @"input" : @""},
                              @{@"mark" : @"商业贷款利率（%）", @"input" : @"4.9"},
                              @{@"mark" : @"贷款年限", @"input" : @""},
                              @{@"mark" : @"贷款方式", @"input" : @"segment"}];
    }
    return _zuHeDaiTextArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
         _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 44;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }
    }
    return _tableView;
}

@end
