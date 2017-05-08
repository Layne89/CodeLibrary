//
//  ZLEInterfaceMap.m
//  接口地址映射-单例
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "ZLEInterfaceMap.h"

@implementation ZLEInterfaceMap
#pragma mark - 单例
static ZLEInterfaceMap *sharedInstance = nil;

+ (instancetype)sharedInterfaceMap{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if(sharedInstance == nil){
        sharedInstance = [super allocWithZone:zone];
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _subURLs = @{@(ZLEInterfaceIDLogin):@"login.php",
                     @(ZLEInterfaceIDUploadCrashLog):@"crashlog.php"};
    }
    return self;
}

#pragma mark - 获取具体接口URL
- (NSString *)interfaceMap:(ZLEInterfaceID)iID{
    NSString *subURL = [_subURLs objectForKey:@(iID)];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@",HTTP_URL_COMMON,subURL];

    return fullURL;
}

@end
