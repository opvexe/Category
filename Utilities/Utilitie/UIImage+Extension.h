//
//  UIImage+Extension.h
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 设置高斯模糊
 */
+(UIImage *)setGaussianBlur:(UIImage *)img;
/**
 设置高斯模糊
 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


//生成带水印的图片
+(UIImage *)GetWaterPrintedImageWithBackImage:(UIImage *)backImage
                                andWaterImage:(UIImage *)waterImage
                                       inRect:(CGRect)waterRect
                                        alpha:(CGFloat)alpha
                                   waterScale:(BOOL)waterScale;
@end
