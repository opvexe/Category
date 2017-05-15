//
//  NSString+Extension.h
//  Utilities
//
//  Created by jieku on 2017/5/15.
//  Copyright © 2017年 TSM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+(NSString *)guid ;

+(NSString*)DeviceVersion;

//    转化字符串
NSString *convertToString(id object);

BOOL is_null(id object);

BOOL isEmpty(NSString* str);

NSString *intervalSinceNow(NSString *theDate);

+(NSString *)GetCurrentTimeString;

NSString* getDocumentsFilePath(const NSString* fileName);

+ (NSString *)timeFromTimestamp:(NSInteger)timestamp;

+ (NSString *)timeFromTimestamp:(NSInteger)timestamp formtter:(NSString *)formtter;

+ (NSString *)timeIntervalGetFromNow;
@end
