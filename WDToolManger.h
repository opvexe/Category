//
//  WDToolManger.h
//  Mine
//
//  Created by Facebook on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WDToolManger : NSObject
/**
 *  将图片转换成颜色
 */
+(UIColor *)img2color:(UIImage *)image;
/**
 *  获取当前视频帧图片
 */
+(nullable UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
/**
 *  获取当前视频第一帧
 */
+(nullable UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;
/**
 *  获取视频文件的时长
 */
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)URL;
/**
 *  压缩视频，返回压缩地址
 */
+ (NSURL *)condenseVideoWithUrl:(NSURL *)url;
/**
 *  获取视频文件的大小，返回的是单位是KB
 */
+ (CGFloat)getFileSizeWithPath:(NSString *)path;
/**
 *  获取当前时间
 */
+ (NSString *)getCurrentTime;
/**
 *  判断摄像头权限
 */
+(BOOL)getMediaTypeVideo;
/**
 *  判断麦克风权限
 */
+(BOOL)canRecord;
/**
 *  64base字符串转图片
 */
+ (UIImage *)stringToImage:(NSString *)str;
/**
 *  图片转64base字符串
 */
+ (NSString *)imageToString:(UIImage *)image;

#pragma mark  Equipment Information
/**
 *  获取APP  BunddleID
 */
NSString *zcGetAppBunddleID(void);
/**
 *  获取当前手机设置的语言  BOOL
 *  返回是否是英语
 */
int  zcGetAppLanguages(void);
/**
 *  获取手机设置语言
 */
NSString *zcGetLanguages(void);
/**
 *  获取APP名称
 */
NSString *zcGetAppName(void);
/**
 *  获取APP版本号
 */
NSString *zcGetAppVersion(void);
/**
 *  获取手机型号
 */
NSString *zcGetIphoneType(void);
/**
 *   获取当前手机的分辨率
 */
NSString *zcGetScreenScale(void);
/**
 *   获取运营商信息
 */
NSString *zcGetIphoneOperators(void);
/**
 *   获取设备UUID
 */
NSString *zcGetIphoneUUID(void);
#pragma mark  GetHeightContain
/**
 *  获取对应高度
 */
+(CGFloat)getHeightContain:(NSString *)string font:(UIFont *)font Width:(CGFloat) width;

/**
 *  获取对应宽度
 */
+(CGFloat)getWidthContain:(NSString *)string font:(UIFont *)font Height:(CGFloat) height;
/**
 *  获取对应宽度 (中文 + 数字 组合 计算高度)
 */
+ (CGRect)getTextRectWith:(NSString *)str WithMaxWidth:(CGFloat)width  WithlineSpacing:(CGFloat)LineSpacing AddLabel:(UILabel *)label;
+(CGRect)getTextRectWith:(NSString *)str WithMaxWidth:(CGFloat)width WithTextFont:(UIFont*)font  WithlineSpacing:(CGFloat)LineSpacing AddLabel:(UILabel *)label;
@end
