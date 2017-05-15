//
//  Utilities.m
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface CPPlacemark : NSObject
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) int placemarkId;
@property (nonatomic, copy) NSString *type;

- (NSString *)getProvinceAndCity;

+ (CPPlacemark *)initWithCLPlacemark:(CLPlacemark *)placemark;
@end
