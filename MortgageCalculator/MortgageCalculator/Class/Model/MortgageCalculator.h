//
//  MortgageCalculator.h
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/28.
//  Copyright © 2019 JZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateResultModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MortgageCalculator : NSObject


/// 非组合贷 计算方法
/// @param rate 年利率
/// @param yearCount 贷款总年限
/// @param totalMoney 总金额 （单位：万元）
/// @param mortgageType 贷款类型 （商贷/公积金贷）
/// @param calculateMethod 计算方法（等额本金/等额本息）
+ (CalculateResultModel *)calculateMortgageInfoWithYearRate:(CGFloat)rate
                                                  yearCount:(NSUInteger)yearCount
                                                 totalMoney:(NSUInteger)totalMoney
                                               mortgageType:(MortgageType)mortgageType
                                            calculateMethod:(CalculationMethod)calculateMethod;



/// 组合贷款
/// @param gjjYearRate 公积金贷款年利率
/// @param shangYearRate 商贷款年利率
/// @param gjjMoney 公积金贷款金额 （单位：万元）
/// @param shangMoney 商贷款金额 （单位：万元）
/// @param yearCount 贷款总年数
/// @param mortgageType 贷款类型 （商贷/公积金贷）
/// @param calculateMethod 计算方法（等额本金/等额本息）
+ (CalculateResultModel *)zuheDaiCalculateWithGJJYearRate:(CGFloat)gjjYearRate
                                            shangYearRate:(CGFloat)shangYearRate
                                                 gjjMoney:(NSUInteger)gjjMoney
                                               shangMoney:(NSUInteger)shangMoney
                                                yearCount:(NSInteger)yearCount
                                             mortgageType:(MortgageType)mortgageType
                                          calculateMethod:(CalculationMethod)calculateMethod;




@end

NS_ASSUME_NONNULL_END
