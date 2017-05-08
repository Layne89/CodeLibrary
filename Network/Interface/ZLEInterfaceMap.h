//
//  ZLEInterfaceMap.h
//  接口地址映射-单例
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_URL_COMMON @"http://www.example.com"//域名定义

typedef NS_ENUM(NSInteger,ZLEInterfaceID){
    ZLEInterfaceIDLogin = 10001,//登录接口
    ZLEInterfaceIDUploadCrashLog = 99999//上传闪退记录接口
};

@interface ZLEInterfaceMap : NSObject
@property (nonatomic, strong)NSDictionary *subURLs;

+ (instancetype)sharedInterfaceMap;

#pragma mark - 获取具体接口URL
- (NSString *)interfaceMap:(ZLEInterfaceID)iID;

@end
