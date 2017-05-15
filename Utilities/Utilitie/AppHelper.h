//
//  AppHelper.h
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSString

#pragma mark 生成UUID
+(NSString *)guid ;

#pragma mark 生成手机型号
+(NSString*)DeviceVersion;
@end
