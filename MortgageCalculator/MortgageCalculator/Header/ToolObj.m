//
//  ToolObj.m
//  MortgageCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "ToolObj.h"

@implementation ToolObj

+ (void)showMessage:(NSString *)message {
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = YES;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = Font(14);
    hud.detailsLabel.text = message;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.0];
}

@end
