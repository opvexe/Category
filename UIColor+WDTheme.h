//
//  UIColor+WDTheme.h
//  Mine
//
//  Created by Facebook on 2018/8/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WDTheme)
/**
 *  主色调
 */
+(UIColor *)WD_mainColor;
/**
 *  整体背景颜色
 */
+(UIColor *)WD_bgColor;
/**
 * 辅助线颜色
 */
+(UIColor *)WD_bgLineColor;
/**
 *  主文字颜色
 */
+(UIColor *)WD_textColor;
/**
 *  文字辅助灰色颜色
 */
+(UIColor *)WD_textGrayColor;
/**
 *  文字副标题颜色
 */
+(UIColor *)WD_textSubTitleColor;
/**
 *  TableView整体背景颜色
 */
+(UIColor *)WD_bgTableViewColor;
@end
