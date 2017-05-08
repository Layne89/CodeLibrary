//
//  ZLEPathManager.m
//  path管理类
//
//  Created by layne on 16/11/21.
//  Copyright © 2016年 layne. All rights reserved.
//

#import "ZLEPathManager.h"

@implementation ZLEPathManager
/* ~ */
+ (NSString *)homePath{
    return NSHomeDirectory();
}

/* ~/Documents */
+ (NSString *)documentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/* ~/tmp */
+ (NSString *)tmpPath{
    return NSTemporaryDirectory();
}

/* ~/Library */
+ (NSString *)libraryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/* ~/Applications */
+ (NSString *)appPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/* ~/Library/Caches */
+ (NSString *)cachesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Caches"];
}

/* ~/Library/Preferences */
+ (NSString *)preferencesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Preferences"];
}


@end
