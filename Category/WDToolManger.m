//
//  WDToolManger.m
//  Mine
//
//  Created by Facebook on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "WDToolManger.h"
#import <AVFoundation/AVFoundation.h>
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
@end
