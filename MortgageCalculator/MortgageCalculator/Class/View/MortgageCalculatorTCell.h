//
//  HouseLoanCalculatorTCell.h
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/25.
//  Copyright © 2019 JZY. All rights reserved.
//


typedef NS_ENUM(NSUInteger, HouseLoanCellType) {
    HouseLoanCellType_Money = 1, // 贷款金额
    HouseLoanCellType_Year, // 贷款年限
    HouseLoanCellType_Rate // 贷款利率
};

NS_ASSUME_NONNULL_BEGIN
@interface MortgageCalculatorTCell : UITableViewCell

@property (nonatomic, readonly) NSString *numberValue;
@property (nonatomic, readonly) NSInteger segmentValue;

// 根据该type 限制输入
@property (nonatomic, assign) HouseLoanCellType cellType;

@property (nonatomic, copy) NSDictionary *data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
