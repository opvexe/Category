//
//  Utilities.m
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPPlacemark.h"
typedef void(^LocationCoorBlock)(CLLocationDegrees latitude, CLLocationDegrees longitude);

typedef void(^LocationPlacemarkBlock)(CPPlacemark *placemark);

typedef void(^LocationFailBlock)(NSError *error);

@interface CPLocationManger : NSObject
/// 定位回调
+ (void)getLocation:(LocationCoorBlock)complete;
/// 停止定位
+ (void)stop;
/// 是否启用定位服务
+ (BOOL)locationServicesEnabled;
/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithLatitude:(NSString *)latitude longitude:(NSString *)longitude completed:(LocationPlacemarkBlock)completed;
/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor complete:(LocationPlacemarkBlock)completed;
/// 地理编码获取经纬度
+ (void)getLocationWithAddress:(NSString *)address complete:(LocationCoorBlock)completed;
/// 获取定位失败
+ (void)getLocationFailComplete:(LocationFailBlock)FailComplete;
+(void)getLocationComplete:(LocationPlacemarkBlock)completed;
@end
