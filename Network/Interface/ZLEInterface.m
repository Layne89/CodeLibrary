//
//  ZLEInterface.m
//  接口处理类
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "ZLEInterface.h"
#import "ZLEInterfaceMap.h"

@implementation ZLEInterface

- (instancetype)initWithDelegate:(id)iDelegate{
    if(self = [super init]){
        _delegate = iDelegate;
        [self customSettings];
    }
    return self;
}

- (void)customSettings{
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;//设置超时时间，默认60s
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/plain",nil];//设置可接受的数据类型，不符合的response会报错
    
}

#pragma mark - 网络请求
/* 异步请求 */
- (void)startAsyncRequest:(NSDictionary *)requestDic iID:(ZLEInterfaceID)iID method:(NSString *)method{
    NSString *url = [[ZLEInterfaceMap sharedInterfaceMap] interfaceMap:iID];
    
    __weak typeof(*&self) weakSelf = self;
    if([method isEqualToString:@"GET"]){//GET
        [_sessionManager GET:url parameters:requestDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf requestSuccess:iID data:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf requestFailure:iID error:error];
        }];
    }else{//POST
        [_sessionManager POST:url parameters:requestDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf requestSuccess:iID data:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf requestFailure:iID error:error];
        }];
    }
}

- (void)requestSuccess:(ZLEInterfaceID)iID data:(id)data{
    if(_delegate && [_delegate respondsToSelector:@selector(interface:didInterfaceReceive:object:)]){
        [_delegate interface:self didInterfaceReceive:iID object:data];
    }
}

- (void)requestFailure:(ZLEInterfaceID)iID error:(id)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interface:didInterfaceError:error:)]){
        [_delegate interface:self didInterfaceError:iID error:error];
    }
}

#pragma mark - 接口函数
/* 例如：登录 */
- (void)login:(NSDictionary *)dict{
    [self startAsyncRequest:dict iID:ZLEInterfaceIDLogin method:@"POST"];
}




@end
