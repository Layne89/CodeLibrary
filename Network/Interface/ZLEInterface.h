//
//  ZLEInterface.h
//  接口处理类
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

/* 增加新接口步骤：
* 1、ZLEInterfaceMap.h - #define定义接口域名
* 2、ZLEInterfaceMap.h - 枚举类型增加新的ZLEInterfaceID
* 3、ZLEInterfaceMap.m - init函数里数组增加ZLEInterfaceID和接口地址的映射
* 4、ZLEInterfaceMap.m - interface:函数里增加ifself判断拼接完整接口
* 5、ZLEInterface.h - 增加对应操作函数的声明（如login:）
* 6、ZLEInterface.m - 增加对应操作函数的实现
*/

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class ZLEInterface;

@protocol ZLEInterfaceDelegate <NSObject>
@optional
//接口正常
- (void) interface:(ZLEInterface *)sender didInterfaceReceive:(NSInteger)iID object:(id)object;

//接口错误
- (void) interface:(ZLEInterface *)sender didInterfaceError:(NSInteger)iID error:(NSError *)error;
@end

@interface ZLEInterface : NSObject
@property (nonatomic, weak)id<ZLEInterfaceDelegate> delegate;
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;

- (instancetype)initWithDelegate:(id)iDelegate;

#pragma mark - 接口函数
/* 例如：登录 */
- (void)login:(NSDictionary *)dict;


@end
