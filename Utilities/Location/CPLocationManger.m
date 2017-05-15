//
//  Utilities.m
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import "CPLocationManger.h"

@interface CPLocationManger()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) LocationCoorBlock coorComplete;
@property (nonatomic, copy) LocationFailBlock  failComplete;
@end
@implementation CPLocationManger

+ (CPLocationManger *)manger {
    static CPLocationManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CPLocationManger alloc] init];
    });
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // iOS8.0以上，使用应用程序期间允许访问位置数据
            [_locationManager requestWhenInUseAuthorization];
        }

        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}
-(void)getLocation:(LocationCoorBlock)complete{

    if ([CLLocationManager locationServicesEnabled] == NO) {
        return;
    }
    _coorComplete = complete;
    // 停止上一次定位
    [_locationManager stopUpdatingLocation];
    // 开始新一次定位
    [_locationManager startUpdatingLocation];

}
/// 停止定位
- (void)stop {
    [_locationManager stopUpdatingLocation];
}
-(void)getLocationFailComplete:(LocationFailBlock)FailComplete{

    _failComplete  =FailComplete;

}
/// 反向地理编码获取地址信息
- (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor complete:(LocationPlacemarkBlock)completed{

    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.lastObject;
            CPPlacemark *mark = [CPPlacemark initWithCLPlacemark:placemark];
            if (completed) {
                completed(mark);
            }
        }
    }];

}
/// 地理编码获取经纬度
- (void)getLocationWithAddress:(NSString *)address complete:(LocationCoorBlock)completed{
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.lastObject;

            if (completed) {
                completed(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            }
        }
    }];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    NSLog(@"当前更新位置: 纬度: (%lf), 经度: (%lf)", lat, lng);

    if (_coorComplete) {
        _coorComplete(lat, lng);
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    } else if (error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    if (_failComplete) {

        _failComplete(error);
    }
}
#pragma mark 公用方法
/// 定位回调
+ (void)getLocation:(LocationCoorBlock)complete{

    [[CPLocationManger manger] getLocation:complete];

}
/// 停止定位
+ (void)stop{
    [[CPLocationManger manger] stop];
}
/// 是否启用定位服务
+ (BOOL)locationServicesEnabled{

    return [CLLocationManager locationServicesEnabled];
}
+(void)getLocationComplete:(LocationPlacemarkBlock)completed{
    
  
    [CPLocationManger getLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
        [CPLocationManger getPlacemarkWithLatitude:[NSString stringWithFormat:@"%f",latitude] longitude:[NSString stringWithFormat:@"%f",longitude] completed:^(CPPlacemark *placemark) {
            if (completed) {
              completed(placemark);
            }
        }];
    }];
    
    
}
/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithLatitude:(NSString *)latitude longitude:(NSString *)longitude completed:(LocationPlacemarkBlock)completed{

    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);

    [[CPLocationManger manger]getPlacemarkWithCoordinate2D:coor complete:completed];

}
/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor complete:(LocationPlacemarkBlock)completed{

    [[CPLocationManger manger]getPlacemarkWithCoordinate2D:coor complete:completed];

}
/// 地理编码获取经纬度
+ (void)getLocationWithAddress:(NSString *)address complete:(LocationCoorBlock)completed{

    [[CPLocationManger manger]getLocationWithAddress:address complete:completed];

}
/// 获取定位失败
+ (void)getLocationFailComplete:(LocationFailBlock)FailComplete{
    
    [[CPLocationManger manger]getLocationFailComplete:FailComplete];
    
}
@end
