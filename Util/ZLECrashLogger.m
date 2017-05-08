//
//  ZLECrashLogger.m
//  Crash信息收集器
//
//  Created by layne on 17/3/7.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "ZLECrashLogger.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>

static NSString *uploadURL = @"";

NSString *iphoneType(){
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
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
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])     return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])   return @"iPhone Simulator";
    
    return platform;
    
}

void UncaughtExceptionHandler(NSException * exception) {;
    
    //系统版本
    NSString *system = [NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    
    //手机型号
    NSString *phonemodel =  iphoneType();
    
    //手机品牌
    NSString *phonebrand = @"iPhone";
    
    //屏幕宽度
    NSString *width = [NSString stringWithFormat:@"%ld",(long)[UIScreen mainScreen].bounds.size.width];
    
    //屏幕高度
    NSString *height = [NSString stringWithFormat:@"%ld",(long)[UIScreen mainScreen].bounds.size.height];
    
#warning 根据reachablity获取网络状态：2G/3G/4G、wifi等
    //网络类型
    NSString *nettype = @"";
    

    //手机时间戳
    NSDate *nTime = [NSDate date];
    NSTimeInterval interval = [nTime timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)interval];
    
    //App版本号
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //调用栈信息
    NSString *str =[NSString stringWithFormat:@"name:%@\nreason:%@\ncallStackSymbols:%@",[exception name],[exception reason],[[exception callStackSymbols] componentsJoinedByString:@"\r\n"]];
    
    NSMutableString *callstackInfo = [NSMutableString stringWithString:str];

    //接口可能对调用堆栈中的"<"和">"敏感报错，这里替换
//    [callstackInfo replaceOccurrencesOfString:@"<" withString:@"#lt;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [callstackInfo length])];
//    [callstackInfo replaceOccurrencesOfString:@">" withString:@"#gt;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [callstackInfo length])];


    NSDictionary *dict = @{@"system":system,
                           @"phonemodel":phonemodel,
                           @"phonebrand":phonebrand,
                           @"width":width,
                           @"height":height,
                           @"nettype":nettype,
                           @"timestamp":timestamp,
                           @"appversion":appversion,
                           @"callstackInfo":callstackInfo};
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *crashLogDirectory = [documentsPath stringByAppendingPathComponent:@"Crash"];
    NSFileManager *fManager = [NSFileManager defaultManager];
    if(![fManager fileExistsAtPath:crashLogDirectory]){
        [fManager createDirectoryAtPath:crashLogDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *logName = [[NSUUID UUID] UUIDString];
    NSString *logPath = [crashLogDirectory stringByAppendingPathComponent:logName];
    
    [NSKeyedArchiver archiveRootObject:dict toFile:logPath];
    
}

@implementation ZLECrashLogger

+ (void)start{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    [self uploadCrashLog];//上传Crash报告
}

+ (void)uploadCrashLog{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *crashLogDirectory = [documentsPath stringByAppendingPathComponent:@"Crash"];
    
    NSFileManager *fManager = [NSFileManager defaultManager];
    
    if([fManager fileExistsAtPath:crashLogDirectory]){
        NSArray *logs = [fManager contentsOfDirectoryAtPath:crashLogDirectory error:nil];
        if(logs.count>0){
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);//限制线程个数

            NSURLSession *session = [NSURLSession sharedSession];
            [logs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_semaphore_wait(semaphore, 60);
                NSString *logName = (NSString *)obj;
                NSString *logPath = [crashLogDirectory stringByAppendingPathComponent:logName];
                NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:logPath];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[NSKeyedArchiver archivedDataWithRootObject:dict]];
                
                NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if(data && !error){//成功则删除本地log
                        [fManager removeItemAtPath:logPath error:nil];
                    }
                    
                    dispatch_semaphore_signal(semaphore);
                }];
                [task resume];
            }];
        }
    }
}

@end
