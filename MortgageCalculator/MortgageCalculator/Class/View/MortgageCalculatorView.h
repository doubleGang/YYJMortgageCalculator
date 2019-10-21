//
//  MortgageCalculatorView.h
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/25.
//  Copyright © 2019 JZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculateResultModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface MortgageCalculatorView : UIView

// 商贷贷款金额
@property (nonatomic, readonly) NSString *shangLoanAmount;
// 商贷利率
@property (nonatomic, readonly) NSString *shangLoanRate;

// 公积金贷款金额
@property (nonatomic, readonly) NSString *gjjLoanAmount;
// 公积金贷款利率
@property (nonatomic, readonly) NSString *gjjLoanRate;

// 贷款年限
@property (nonatomic, readonly) NSString *loanOfYear;
// 贷款模式（本息/本金）
@property (nonatomic, readonly) CalculationMethod loanMode;


///  贷款计算器view
/// @param loansMode 贷款模式
- (instancetype)initWithFrame:(CGRect)frame loansType:(MortgageType)loansMode;


@end

NS_ASSUME_NONNULL_END
