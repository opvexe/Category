//
//  WDToolManger.m
//  Mine
//
//  Created by Facebook on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "WDToolManger.h"
#import <sys/utsname.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UIScreen.h>
#import <Foundation/NSString.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#define iOS7        ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)? NO:YES)
@implementation WDToolManger

+(UIColor *)img2color:(UIImage *)image{
    return [UIColor colorWithPatternImage:image];
}

+(nullable UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    return thumbnailImage;
}

+(nullable UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    if (error == nil){
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)URL{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    NSLog(@"CMTime.time.value:%lld",time.value);
    NSLog(@"CMTime.time.timescale:%d",time.timescale);
    float second = ceil(time.value/time.timescale);
    return second;
}

+ (NSURL *)condenseVideoWithUrl:(NSURL *)url{
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *destFilePath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyh%@.MOV",[self getCurrentTime]]];
    NSURL *destUrl = [NSURL fileURLWithPath:destFilePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager copyItemAtURL:url toURL:destUrl error:&error];
    NSLog(@"压缩前--%.2fk",[self getFileSizeWithPath:destFilePath]);
    
    /*  播放视频
     NSURL *videoURL = [NSURL fileURLWithPath:destFilePath];
     AVPlayer *player = [AVPlayer playerWithURL:videoURL];
     AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
     playerLayer.frame = self.view.bounds;
     [self.view.layer addSublayer:playerLayer];
     [player play];
     */
    // 进行压缩
    AVAsset *asset = [AVAsset assetWithURL:destUrl];
    //创建视频资源导出会话
    /**
     NSString *const AVAssetExportPresetLowQuality; // 低质量
     NSString *const AVAssetExportPresetMediumQuality;
     NSString *const AVAssetExportPresetHighestQuality; //高质量
     */
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    NSString *resultPath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyhg%@.MOV",[self getCurrentTime]]];
    session.outputURL = [NSURL fileURLWithPath:resultPath];
    session.outputFileType = @"com.apple.quicktime-movie";
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"压缩后---%.2fk",[self getFileSizeWithPath:resultPath]);
        NSLog(@"视频导出完成");
    }];
    return session.outputURL;
}

+ (CGFloat)getFileSizeWithPath:(NSString *)path{
    NSLog(@"filePath：%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}


+ (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}





+(CGFloat)getHeightContain:(NSString *)string font:(UIFont *)font Width:(CGFloat) width{
    if (string ==nil) {
        return 0;
    }
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    CGSize contanSize = CGSizeMake(width, CGFLOAT_MAX);
    if (iOS7) {
        CGRect rect =[astr boundingRectWithSize:contanSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        return rect.size.height;
    }else{
        CGSize s=[string sizeWithFont:font constrainedToSize:contanSize lineBreakMode:NSLineBreakByCharWrapping];
        return s.height;
    }
}

+(CGFloat)getWidthContain:(NSString *)string font:(UIFont *)font Height:(CGFloat) height{
    if (string ==nil) {
        return 0;
    }
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    CGSize contanSize = CGSizeMake(CGFLOAT_MAX,height );
    if (iOS7) {
        CGRect rect =[astr boundingRectWithSize:contanSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        return rect.size.width;
    }else{
        CGSize s=[string sizeWithFont:font constrainedToSize:contanSize lineBreakMode:NSLineBreakByCharWrapping];
        return s.width;
    }
}



+(BOOL)getMediaTypeVideo{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

+ (UIImage *)stringToImage:(NSString *)str{
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *photo = [UIImage imageWithData:imageData];
    return photo;
}

+ (NSString *)imageToString:(UIImage *)image{
    NSData *imagedata = UIImagePNGRepresentation(image);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return image64;
}

#pragma mark  Equipment Information
NSString *zcGetAppBunddleID(void){
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    return identifier;
}

int  zcGetAppLanguages(void){
    NSString * lanStr  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ([lanStr hasPrefix:@"en"]) {
        return 1;
    }else if ([lanStr hasPrefix:@"zh-Hans"]){
        return 0;
    }
    return 0;
}

NSString *zcGetLanguages(void){
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

NSString *zcGetAppName(void){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

NSString *zcGetAppVersion(void){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString *zcGetIphoneType(void){
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
    // http://www.jianshu.com/p/02bba9419df8   参考资料
    // https://www.cnblogs.com/weiming4219/p/7693304.html
}

NSString *zcGetScreenScale(void){
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"640x960";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"640x960";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"1242x2208";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"750x1334";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"750x1334";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"1242x2208";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"750x1334";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"1242x2208";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"320x480";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"640x960";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"640x1136";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"1024x768";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"2048x1536";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
}

NSString *zcGetIphoneOperators(void){
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *imsi = [NSString stringWithFormat:@"%@%@", [carrier mobileCountryCode], [carrier mobileNetworkCode]];
    if ([imsi isEqualToString:@"46000"] || [imsi isEqualToString:@"46002"] || [imsi isEqualToString:@"46007"]) {
        return  @"中国移动";
    }else if([imsi isEqualToString:@"46001"] || [imsi isEqualToString:@"46006"] || [imsi isEqualToString:@"46009"]){
        return @"中国联通";
    }else if ([imsi isEqualToString:@"46003"] || [imsi isEqualToString:@"46005"] || [imsi isEqualToString:@"46011"]){
        return @"中国电信";
    }else if ([imsi isEqualToString:@"46020"]){
        return @"铁通";
    }
    return @"未知";
}

NSString *zcGetIphoneUUID(void){
    NSString * retrieveuuid;
    retrieveuuid =  [[UIDevice currentDevice].identifierForVendor UUIDString];
    retrieveuuid = [NSString stringWithFormat:@"2%@",retrieveuuid];
    retrieveuuid = [retrieveuuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return retrieveuuid;
}

#pragma mark  GetHeightContain
+ (CGRect)getTextRectWith:(NSString *)str WithMaxWidth:(CGFloat)width  WithlineSpacing:(CGFloat)LineSpacing AddLabel:(UILabel *)label{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * parageraphStyle = [[NSMutableParagraphStyle alloc]init];
    [parageraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:parageraphStyle range:NSMakeRange(0, [str length])];
    [attributedString addAttribute:NSFontAttributeName value:label.font range:NSMakeRange(0, str.length)];
    
    label.attributedText = attributedString;
    CGSize size = [self autoHeightOfLabel:label with:width];
    
    CGRect labelF = label.frame;
    labelF.size.height = size.height;
    label.frame = labelF;
    return labelF;
}

/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度   type 是否从新设置宽，1设置，0不设置
 */
+(CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}


+(CGRect)getTextRectWith:(NSString *)str WithMaxWidth:(CGFloat)width WithTextFont:(UIFont*)font  WithlineSpacing:(CGFloat)LineSpacing AddLabel:(UILabel *)label{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * parageraphStyle = [[NSMutableParagraphStyle alloc]init];
    [parageraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:parageraphStyle range:NSMakeRange(0, [str length])];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    if ((rect.size.height - font.lineHeight) <= parageraphStyle.lineSpacing) {
        if ([self containChinese:str]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-parageraphStyle.lineSpacing);
        }
    }
    label.attributedText = attributedString;
    return rect;
}

+ (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
