//
//  CalculatorResultController.m
//  MortgageCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "CalculatorResultController.h"
#import "HouseLoanCalcuResultHeaderView.h"
#import "HouseLoanCalResultTableViewCell.h"

static NSString *cellID = @"cellID";


@interface CalculatorResultController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HouseLoanCalcuResultHeaderView *headerView;
@property (nonatomic, strong) UIView *sectionHeadView;


@end

@implementation CalculatorResultController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计算结果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView bindData:self.resultModel];
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultModel.monthResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HouseLoanCalResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HouseLoanCalResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row < self.resultModel.monthResultArray.count) {
        [cell setData:self.resultModel.monthResultArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.sectionHeadView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}


#pragma mark - getters
- (HouseLoanCalcuResultHeaderView *)headerView {
    if (_headerView == nil) {

        CGFloat height = 196;
        if (self.resultModel.mortgageType == MortgageType_ZuHe) {
            height = 236;
        }
        CGRect frame = CGRectMake(0, 0, ScreenWidth, height);
        _headerView = [[HouseLoanCalcuResultHeaderView alloc] initWithFrame:frame mortgageType:self.resultModel.mortgageType calculateMethod:self.resultModel.calculationMethod];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect frame = self.view.bounds;//CGRectMake(0, 0, ScreenWidth, ScreenHeight-TopOffset);
         UITableView *_shotTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView = _shotTableView;
        _shotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _shotTableView.delegate = self;
        _shotTableView.dataSource = self;
        _shotTableView.backgroundColor = [UIColor clearColor];
        _shotTableView.estimatedRowHeight = 44;
        _shotTableView.estimatedSectionHeaderHeight = 0;
        _shotTableView.estimatedSectionFooterHeight = 0;
        _shotTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shotTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        if (@available(iOS 11.0, *)) {
            _shotTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _shotTableView.scrollIndicatorInsets = _shotTableView.contentInset;
        }
        
        [_tableView registerClass:HouseLoanCalResultTableViewCell.class forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

- (UIView *)sectionHeadView {
    if (_sectionHeadView == nil) {
                
        _sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, 30)];
        _sectionHeadView.backgroundColor = ColorFromRGB(0xF7F7F7);

        UILabel *(^makeLabel)(NSString *) = ^UILabel *(NSString *text){
            UILabel *label = [[UILabel alloc] init];
            label.textColor = ColorFromRGB(0x393939);
            label.text = text;
            label.font = Font(13);
            return label;
        };

        UILabel *label1 = makeLabel(@"期数");
        UILabel *label2 = makeLabel(@"月供(元)");
        UILabel *label3 = makeLabel(@"本金(元)");
        UILabel *label4 = makeLabel(@"利息(元)");
        UILabel *label5 = makeLabel(@"剩余(元)");
        [_sectionHeadView addSubview:label1];
        [_sectionHeadView addSubview:label2];
        [_sectionHeadView addSubview:label3];
        [_sectionHeadView addSubview:label4];
        [_sectionHeadView addSubview:label5];

        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.height.mas_equalTo(_sectionHeadView);
            make.width.mas_equalTo(60);
        }];

        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(84);
            make.centerY.height.mas_equalTo(_sectionHeadView);
            make.width.mas_equalTo(70);
        }];

        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label2.mas_right).mas_offset(0);
            make.centerY.height.mas_equalTo(_sectionHeadView);
            make.width.mas_equalTo(70);
        }];

        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label3.mas_right).mas_offset(0);
            make.centerY.height.mas_equalTo(_sectionHeadView);
            make.width.mas_equalTo(70);
        }];

        [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label4.mas_right).mas_offset(0);
            make.centerY.height.mas_equalTo(_sectionHeadView);
            make.width.mas_equalTo(70);
        }];
    }
    return _sectionHeadView;
}

@end
