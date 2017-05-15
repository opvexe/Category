//
//  Utilities.h
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject
// 将颜色作为图片的方法
+(UIImage *)imageWithRGB:(int)color alpha:(float)alpha;

//将图片转换成颜色
+(UIColor *)img2color:(NSString *)imgname;

// 检查手机号格式是否正确
+ (BOOL)checkTel:(NSString *)tel;

// 检查密码格式是否正确
+ (BOOL)checkPassword:(NSString *)password;

// 检查验证码格式是否正确
+ (BOOL)checkVerificationCode:(NSString *)verificationCode;

// 检查用户名格式是否正确
+ (BOOL)checkUserName:(NSString *)userName;

// 设置时间：精确到分
+ (NSString *)setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:(NSString *)time;

// 设置时间：精确到分：用xxxx年xx月xx日 xx时xx分表示
+ (NSString *)setYearMouthDayHourMinuteWithChineseYearMouthDayHourMinuteSecond:(NSString *)time;

// 设置时间：xx月xx日
+ (NSString *)setYearMouthDayHourMinuteWithChineseMouthDay:(NSString *)time;

// 获取当前帧数下，视频的图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;


// 获取视频文件的时长：单位是秒
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)URL;

// 获取视频文件的大小，返回的是单位是KB。
+ (CGFloat)getFileSizeWithPath:(NSString *)path;

// 压缩视频：返回压缩后视频的地址，该地址在沙盒目录中
+ (NSURL *)condenseVideoWithUrl:(NSURL *)url;

// 判断摄像头权限
+(bool)getMediaTypeVideo;

//麦克风权限
+(BOOL)canRecord;
@end
