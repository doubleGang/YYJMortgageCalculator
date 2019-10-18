//
//  HouseLoanCalcuResultHeaderView.h
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/28.
//  Copyright © 2019 JZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculateResultModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HouseLoanCalcuResultHeaderView : UIView


/// 初始化方法
/// @param frame frame
/// @param mortgageType 贷款类型
/// @param calculateMethod 计算方式
- (instancetype)initWithFrame:(CGRect)frame mortgageType:(MortgageType)mortgageType calculateMethod:(CalculationMethod)calculateMethod;

// 绑定数据
- (void)bindData:(CalculateResultModel *)data;

@end

NS_ASSUME_NONNULL_END
