//
//  ZLECrashLogger.h
//  Crash信息收集器
//
//  Created by layne on 17/3/7.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZLECrashLogger : NSObject

+ (void)start;

+ (void)uploadCrashLog;

@end
