//
//  UIColor+WDTheme.m
//  Mine
//
//  Created by Facebook on 2018/8/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "UIColor+WDTheme.h"

@implementation UIColor (WDTheme)

+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex alpha:1.f];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

/**
 *  主色调
 */
+(UIColor *)WD_mainColor{
    return [UIColor colorWithHex:0x51ac33];
}
/**
 *  整体背景颜色
 */
+(UIColor *)WD_bgColor {
    return [UIColor colorWithHex:0xffffff];
}


/**
 * 辅助线颜色
 */
+(UIColor *)WD_bgLineColor{
    return [UIColor colorWithHex:0xe1e1e1];
}

/**
 *  主文字颜色
 */
+(UIColor *)WD_textColor{
    return [UIColor colorWithHex:0x323232];
}

/**
 *  文字副标题颜色
 */
+(UIColor *)WD_textSubTitleColor{
    return [UIColor colorWithHex:0x999999];
}

/**
 *  文字辅助灰色颜色
 */
+(UIColor *)WD_textGrayColor{
    return [UIColor colorWithHex:0x777777];
}

/**
 *  TableView整体背景颜色
 */
+(UIColor *)WD_bgTableViewColor{
    return [UIColor colorWithHex:0xf4f4f4];
}

@end
