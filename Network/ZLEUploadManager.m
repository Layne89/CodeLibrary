//
//  ZLEUploadManager.m
//  上传类（图片、文件等）
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "ZLEUploadManager.h"
#import "AFNetworking.h"

/* 并行上传的线程个数 */
NSInteger const CONCURRENT_THREAD_NUM=3;

@interface ZLEUploadManager ()
@property (nonatomic, weak)id<ZLEUploadManagerDelegate> delegate;
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;
@end

@implementation ZLEUploadManager

- (instancetype)initWithDelegate:(id<ZLEUploadManagerDelegate>)aDelegate{
    if(self = [super init]){
        _delegate = aDelegate;
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30.f;//超时时间为30s
    }
    return self;
}

- (void)uploadComplete:(NSArray *)results{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_delegate && [_delegate respondsToSelector:@selector(upload:results:)]){
            [_delegate  upload:self results:results];
        }
    });
}

#pragma mark - 上传图片
- (void)uploadImages:(NSArray *)images{
    NSString *url = HTTP_URL_UPLOAD;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:images.count];
    //初始值为0
    for(int i=0;i<images.count;++i){
        resultArray[i]=@"0";
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(CONCURRENT_THREAD_NUM);//限制线程个数
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i=0;i<images.count;++i){
            dispatch_group_enter(group);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
            [_sessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *data = UIImageJPEGRepresentation(images[i],0);
                [formData appendPartWithFileData:data name:@"imgfile" fileName:fileName mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dict = (NSDictionary *)responseObject;
                @synchronized (resultArray) {//MutabelArray为线程不安全，这里要加锁
                    if([dict[@"result"] intValue]==1){
                        resultArray[i]=@"1";
                    }else{
                        resultArray[i]=@"0";
                    }
                }
                dispatch_semaphore_signal(semaphore);
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                @synchronized (resultArray) {
                    resultArray[i] = @"0";
                }
                dispatch_semaphore_signal(semaphore);
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self uploadComplete:resultArray];
        });
   });

}



@end
