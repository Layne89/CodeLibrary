//
//  ZLEUploadManager.h
//  上传类（图片、文件等）
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_URL_UPLOAD @"www.example.com/upload.php"

@class ZLEUploadManager;
@protocol ZLEUploadManagerDelegate <NSObject>
- (void)upload:(ZLEUploadManager *)manager results:(NSArray *)results;
@end


@interface ZLEUploadManager : NSObject

- (instancetype)initWithDelegate:(id<ZLEUploadManagerDelegate>)aDelegate;

/* 上传图片 */
- (void)uploadImages:(NSArray *)images;

@end
