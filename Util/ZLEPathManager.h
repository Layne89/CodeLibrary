//
//  ZLEPathManager.h
//  path管理类
//
//  Created by layne on 16/11/21.
//  Copyright © 2016年 layne. All rights reserved.
//

/* 沙盒目录结构：
 * MyApp.app (即mainBundle)
 * Documents
 * Library
 *        Caches
 *        Preferences
 * tmp
 */


#import <Foundation/Foundation.h>

@interface ZLEPathManager : NSObject

+ (NSString *)homePath;

+ (NSString *)documentsPath;

+ (NSString *)tmpPath;

+ (NSString *)libraryPath;

+ (NSString *)appPath;

+ (NSString *)cachesPath;

+ (NSString *)preferencesPath;


@end
