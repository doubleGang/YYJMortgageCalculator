//
//  MortgageCalculator.m
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/28.
//  Copyright © 2019 JZY. All rights reserved.
//

#import "MortgageCalculator.h"

// 剩余还款，是否需要计入剩余利息
static BOOL SurplusNeedAddLixi = YES;

@interface MortgageCalculator ()

@end

@implementation MortgageCalculator

#pragma mark - 非组合贷
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
                                        calculateMethod:(CalculationMethod)calculateMethod {
    
    // 贷款月数
    NSUInteger monthCount = yearCount * 12;
    // 总金额 万元 转为 元
    CGFloat totalMoneyYuan = (CGFloat)totalMoney * 10000.f;
    // 月利率
    CGFloat monthRate = rate / 100.f / 12.f;
    // 创建 计算结果 model
    CalculateResultModel *resultModel = nil;
    
    // 等额本息
    if (calculateMethod == CalculationMethod_BenXi) {

        resultModel = [self benxiCalculateWithMonthRate:monthRate monthCount:monthCount totalMoney:totalMoneyYuan];
        
    } else { // 等额本金
        
        resultModel = [self benjinCalculateWithMonthRate:monthRate monthCount:monthCount totalMoney:totalMoneyYuan];
    }

    // 贷款方式
    resultModel.mortgageType = mortgageType;
    // 计算方法
    resultModel.calculationMethod = calculateMethod;

    // 赋值 利率、金额
    if (mortgageType == MortgageType_ShangDai) {
        
        resultModel.shangDaiRate = rate;
        resultModel.shangDaiRateString = [NSString stringWithFormat:@"%0.2f%@", rate, @"%"];
        
        resultModel.shangDaiMoney = totalMoney;
        resultModel.shangDaiMoneyString = [NSString stringWithFormat:@"%lu", (unsigned long)totalMoney];
        
    } else if (mortgageType == MortgageType_GJJDai) {
                    
        resultModel.gjjDaiRate = rate;
        resultModel.gjjDaiRateString = [NSString stringWithFormat:@"%0.2f%@", rate, @"%"];
        
        resultModel.gjjDaiMoney = totalMoney;
        resultModel.gjjDaiMoneyString = [NSString stringWithFormat:@"%lu", (unsigned long)totalMoney];
    }

    return resultModel;
}

#pragma mark - 组合贷款
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
                                          calculateMethod:(CalculationMethod)calculateMethod {

    CGFloat totalMoney = gjjMoney + shangMoney;
    
    // 贷款月数
    NSUInteger monthCount = yearCount * 12;
    // 总金额 万元 转为 元
    CGFloat gjjMoneyYuan = (CGFloat)gjjMoney * 10000.f;
    CGFloat shangMoneyYuan = (CGFloat)shangMoney * 10000.f;
    // 月利率
    CGFloat gjjMonthRate = gjjYearRate / 100.f / 12.f;
    CGFloat shangMonthRate = shangYearRate / 100.f / 12.f;

    NSMutableArray <CalculateResultMonthModel *>* monthMDArray = [NSMutableArray array];
    
    // 创建 计算结果 model
    CalculateResultModel *resultModel = [[CalculateResultModel alloc] init];
    
    
    // 等额本息
    if (calculateMethod == CalculationMethod_BenXi) {

        // 分别按各自的贷款利率
        CalculateResultModel *gjjModel = [self benxiCalculateWithMonthRate:gjjMonthRate monthCount:monthCount totalMoney:gjjMoneyYuan];
        CalculateResultModel *shangModel = [self benxiCalculateWithMonthRate:shangMonthRate monthCount:monthCount totalMoney:shangMoneyYuan];
        
        CGFloat doneMoney = 0.0;
        CGFloat doneYueLixi = 0.0;
        CGFloat totalLixi = 0.0;
        
        for (int i = 0; i < gjjModel.monthResultArray.count; i++) {
            
            //
            CalculateResultMonthModel *gjjMonthModel = gjjModel.monthResultArray[i];
            CalculateResultMonthModel *shangMonthModel = shangModel.monthResultArray[i];
                
            CalculateResultMonthModel *monthModel = [[CalculateResultMonthModel alloc] init];
            
            // 期数
            monthModel.nper = gjjMonthModel.nper;
            monthModel.nperString = gjjMonthModel.nperString;
            
            // 月本金
            monthModel.benjin = gjjMonthModel.benjin + shangMonthModel.benjin;
            monthModel.benjinString = [NSString stringWithFormat:@"%0.2f", monthModel.benjin];
            // 累加已还款
            doneMoney += monthModel.benjin;

            // 月利息
            monthModel.lixi = gjjMonthModel.lixi + shangMonthModel.lixi;
            monthModel.lixiString = [NSString stringWithFormat:@"%0.2f", monthModel.lixi];
            doneYueLixi += monthModel.lixi;

            // 月本息
            monthModel.needPay = gjjMonthModel.needPay + shangMonthModel.needPay;
            monthModel.needPayString = [NSString stringWithFormat:@"%0.2f", monthModel.needPay];
            
            // 总利息、剩余还款
            if (totalLixi == 0.0) {
                // 总利息=还款月数×每月月供额-贷款本金
                totalLixi = monthCount * monthModel.needPay - totalMoney * 10000;
                resultModel.totalLixi = totalLixi;
                resultModel.totalLixiString = [NSString stringWithFormat:@"%0.2f", totalLixi];
            }
            
            // 剩余
            monthModel.surplusPay = (gjjMoneyYuan+shangMoneyYuan) - doneMoney + totalLixi - doneYueLixi;
            monthModel.surplusPayString = [NSString stringWithFormat:@"%0.2f", fabs(monthModel.surplusPay)];
            
            // 添加到数组
            [monthMDArray addObject:monthModel];
        }
        
                
    } else { // 等额本金
        
        // 分别按各自的贷款利率
        CalculateResultModel *gjjModel = [self benjinCalculateWithMonthRate:gjjMonthRate monthCount:monthCount totalMoney:gjjMoneyYuan];
        CalculateResultModel *shangModel = [self benjinCalculateWithMonthRate:shangMonthRate monthCount:monthCount totalMoney:shangMoneyYuan];

        CGFloat doneMoney = 0.0;
        CGFloat doneYueLixi = 0.0;
        CGFloat totalLixi = 0.0;
        
        // 月本金
        CGFloat yueBenJin = gjjModel.monthResultArray.firstObject.benjin + shangModel.monthResultArray.firstObject.benjin;
        NSString *yueBenJinStr = [NSString stringWithFormat:@"%0.2f", yueBenJin];
        
        for (int i = 0; i < gjjModel.monthResultArray.count; i++) {
            
            //
            CalculateResultMonthModel *gjjMonthModel = gjjModel.monthResultArray[i];
            CalculateResultMonthModel *shangMonthModel = shangModel.monthResultArray[i];
                
            CalculateResultMonthModel *monthModel = [[CalculateResultMonthModel alloc] init];
            // 期数
            monthModel.nper = gjjMonthModel.nper;
            monthModel.nperString = gjjMonthModel.nperString;
            
            // 月本金
            monthModel.benjin = yueBenJin;
            monthModel.benjinString = yueBenJinStr;
            // 累加已还款
            doneMoney += monthModel.benjin;

            // 月利息
            monthModel.lixi = gjjMonthModel.lixi + shangMonthModel.lixi;
            monthModel.lixiString = [NSString stringWithFormat:@"%0.2f", monthModel.lixi];
            doneYueLixi += monthModel.lixi;

            // 月本息
            monthModel.needPay = gjjMonthModel.needPay + shangMonthModel.needPay;
            monthModel.needPayString = [NSString stringWithFormat:@"%0.2f", monthModel.needPay];
            
            
            // 总利息、剩余还款
            if (totalLixi == 0.0) {
                // 总利息=还款月数×每月月供额-贷款本金
                totalLixi = gjjModel.totalLixi + shangModel.totalLixi;
                resultModel.totalLixi = totalLixi;
                resultModel.totalLixiString = [NSString stringWithFormat:@"%0.2f", totalLixi];
            }
            
            // 剩余
            monthModel.surplusPay = (gjjMoneyYuan+shangMoneyYuan) - doneMoney + totalLixi - doneYueLixi;
            monthModel.surplusPayString = [NSString stringWithFormat:@"%0.2f", fabs(monthModel.surplusPay)];
            
            // 添加到数组
            [monthMDArray addObject:monthModel];
        }
    }
    
    resultModel.mortgageType = MortgageType_ZuHe;
    resultModel.calculationMethod = calculateMethod;
    
    resultModel.monthResultArray = monthMDArray;
    
    resultModel.shangDaiRate = shangYearRate;
    resultModel.shangDaiRateString = [NSString stringWithFormat:@"%0.2f%@", shangYearRate, @"%"];
    resultModel.shangDaiMoney = shangMoney;
    resultModel.shangDaiMoneyString = [NSString stringWithFormat:@"%lu", (unsigned long)shangMoney];

    resultModel.gjjDaiRate = gjjYearRate;
    resultModel.gjjDaiRateString = [NSString stringWithFormat:@"%0.2f%@", gjjYearRate, @"%"];
    resultModel.gjjDaiMoney = gjjMoney;
    resultModel.gjjDaiMoneyString = [NSString stringWithFormat:@"%lu", (unsigned long)gjjMoney];

    resultModel.year = yearCount;
    
    // 总还款金额
    resultModel.totalMoney = totalMoney * 10000 + resultModel.totalLixi;
    resultModel.totalMoneyString = [NSString stringWithFormat:@"%0.2f", resultModel.totalMoney];

    return resultModel;
}



#pragma mark - private methods
#pragma mark - 等额本息 计算方法
+ (CalculateResultModel *)benxiCalculateWithMonthRate:(CGFloat)rate monthCount:(NSUInteger)monthCount totalMoney:(CGFloat)totalMoney {
    
    // 等额本息方式
    /**
    * 月还款本息=〔贷款本金×月利率×（1＋月利率）＾还款月数〕÷〔（1＋月利率）＾还款月数－1〕
    * 每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
    * 每月应还本金 = 贷款本金 × 月利率 × (1+月利率)^(还款月序号-1) ÷〔(1+月利率)^还款月数-1〕
    * 总利息=还款月数×每月月供额-贷款本金
    */

    // 总利息
    CGFloat totalLixi = 0.0;
    // 已完成的还款金额
    CGFloat doneMoney = 0.0;
    // 已完成的利息
    CGFloat doneYueLixi = 0.0;
    // 存储每月信息的数组
    NSMutableArray <CalculateResultMonthModel *>* monthMDArray = [NSMutableArray array];
    
    for (int i = 0; i < monthCount; i++) {
                
    
        CalculateResultMonthModel *monthModel = [[CalculateResultMonthModel alloc] init];
        // 第几期
        monthModel.nper = i+1;
        monthModel.nperString = [NSString stringWithFormat:@"第%d期", i+1];
        
        
        // 每月应还本金 = 贷款本金 ×月利率 × (1+月利率)^(还款月序号-1) ÷〔(1+月利率)^还款月数-1〕
        monthModel.benjin = totalMoney * rate * pow(1.0+rate, i) / (pow(1.0+rate, monthCount)-1);
        monthModel.benjinString = [NSString stringWithFormat:@"%0.2f", monthModel.benjin];
        // 累加已完成的还款
        doneMoney += monthModel.benjin;
        
        
        // 每月应还利息 = 贷款本金 × 月利率 ×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
        monthModel.lixi = totalMoney * rate * (pow(1.0+rate, monthCount) - pow(1.0+rate, i)) / (pow(1.0+rate, monthCount)-1);
        monthModel.lixiString = [NSString stringWithFormat:@"%0.2f", monthModel.lixi];
        // 累加已还的利息
        doneYueLixi += monthModel.lixi;
        
        
        // 月还款本息 =〔贷款本金×月利率×（1＋月利率）＾还款月数〕÷〔（1＋月利率）＾还款月数－1〕
        monthModel.needPay = totalMoney * rate * pow(1.0+rate, monthCount) / (pow(1.0+rate, monthCount)-1);
        monthModel.needPayString = [NSString stringWithFormat:@"%0.2f", monthModel.needPay];

        
        // 剩余还款
        if (totalLixi == 0.0) {
            // 总利息 = 还款月数×每月月供额 - 贷款本金
            totalLixi = (CGFloat)monthCount * monthModel.needPay - totalMoney;
        }
        
        // 剩余
        if (SurplusNeedAddLixi) {
            monthModel.surplusPay = totalMoney - doneMoney + totalLixi - doneYueLixi;
        } else {
            monthModel.surplusPay = totalMoney - doneMoney;
        }
        monthModel.surplusPayString = [NSString stringWithFormat:@"%0.2f", fabs(monthModel.surplusPay)];
        
        // 添加到数组
        [monthMDArray addObject:monthModel];
    }
        
        
    // 创建计算结果 model
    CalculateResultModel *resultModel = [[CalculateResultModel alloc] init];
    resultModel.monthResultArray = monthMDArray;
    
    // 总利息
    resultModel.totalLixi = totalLixi;
    resultModel.totalLixiString = [NSString stringWithFormat:@"%0.2f", totalLixi];

    // 总还款金额
    resultModel.totalMoney = totalMoney + totalLixi;
    resultModel.totalMoneyString = [NSString stringWithFormat:@"%0.2f", resultModel.totalMoney];
    
    // 贷款年限、计算方式
    resultModel.year = monthCount / 12;
    resultModel.calculationMethod = CalculationMethod_BenXi;

    return resultModel;
}

#pragma mark - 等额本金 计算方法
+ (CalculateResultModel *)benjinCalculateWithMonthRate:(CGFloat)rate monthCount:(NSUInteger)monthCount totalMoney:(CGFloat)totalMoney {

    //等额本金方式
    /**
    * 每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
    *
    * 每月应还本金=贷款本金÷还款月数
    *
    * 每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率。
    *
    * 每月月供递减额=每月应还本金×月利率=贷款本金÷还款月数×月利率
    *
    * 总利息=还款月数×(总贷款额×月利率-月利率×(总贷款额÷还款月数)*(还款月数-1)÷2+总贷款额÷还款月数)-贷款本金
    */
    
    // 月本金
    CGFloat yueBenJin = (CGFloat)totalMoney / (CGFloat)monthCount;
    NSString *yueBenJinStr = [NSString stringWithFormat:@"%0.2f", yueBenJin];
    // 总利息
    CGFloat totalLixi = 0.0;
    // 已完成的利息
    CGFloat doneYueLixi = 0.0;
    // 存储每月信息的数组
    NSMutableArray <CalculateResultMonthModel *>* monthMDArray = [NSMutableArray array];
    
    for (int i = 0; i < monthCount; i++) {

        CalculateResultMonthModel *monthModel = [[CalculateResultMonthModel alloc] init];
        // 期数
        monthModel.nper = i+1;
        monthModel.nperString = [NSString stringWithFormat:@"第%d期", i+1];

        // 月本金
        monthModel.benjin = yueBenJin;
        monthModel.benjinString = yueBenJinStr;
        
      
        // 每月应还利息 = 剩余本金×月利率 = (贷款本金-已归还本金累计额)×月利率。
        monthModel.lixi = (yueBenJin * (monthCount - i)) * rate;
        monthModel.lixiString = [NSString stringWithFormat:@"%0.2f", monthModel.lixi];
        // 累加 完成的利息
        doneYueLixi += monthModel.lixi;

        // 月供 (本+息)
        monthModel.needPay = yueBenJin + monthModel.lixi;
        monthModel.needPayString = [NSString stringWithFormat:@"%0.2f", monthModel.needPay];
              
        
        // 总利息
        if (totalLixi == 0.0) {
            // 总利息 = 还款月数 × (总贷款额×月利率 - 月利率×(总贷款额÷还款月数) * (还款月数-1)÷2 + 总贷款额÷还款月数) - 贷款本金
            totalLixi = (CGFloat)monthCount * ((CGFloat)totalMoney*rate - rate*((CGFloat)totalMoney/(CGFloat)monthCount) * ((CGFloat)monthCount-1.f)/2.f + (CGFloat)totalMoney/(CGFloat)monthCount) - (CGFloat)totalMoney;
        }
 
        // 剩余
        if (SurplusNeedAddLixi) {
            monthModel.surplusPay = totalMoney - (yueBenJin * (i + 1)) + totalLixi - doneYueLixi;
        } else {
            monthModel.surplusPay = totalMoney - (yueBenJin * (i + 1));
        }
        monthModel.surplusPayString = [NSString stringWithFormat:@"%0.2f", fabs(monthModel.surplusPay)];
                
        // 添加到数组
        [monthMDArray addObject:monthModel];
    }
    
    
    // 创建计算结果 model
    CalculateResultModel *resultModel = [[CalculateResultModel alloc] init];
    resultModel.monthResultArray = monthMDArray;
    
    // 总利息
    resultModel.totalLixi = totalLixi;
    resultModel.totalLixiString = [NSString stringWithFormat:@"%0.2f", totalLixi];

    // 总还款金额
    resultModel.totalMoney = totalMoney + totalLixi;
    resultModel.totalMoneyString = [NSString stringWithFormat:@"%0.2f", resultModel.totalMoney];
    
    // 贷款年限、计算方式
    resultModel.year = monthCount / 12;
    resultModel.calculationMethod = CalculationMethod_BenJin;

    return resultModel;
}

@end
