//
//  ZLECache.h
//  缓存类-操作FMDB
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ZLE_DATABASE_FILENAME @"zle_database_v001.db"

/*
 * 由于内置的sqlite只能对table的colume进行增加操作而不能修改和删除，因此这里仅考虑增加colume操作。
 * 问题：老版本升级到新版本，而database表结构又发生了改变（如增加一列）
 * 操作：1、修改下面的宏定义（ZLE_DATABASE_VERSION）增加1（其实只要和上一个版本不相同就行）
 *      2、在函数+ (NSDictionary *)upgradeFields定义好要增加的table和字段，如果没有增加任何字段，一定要记得清空！！！
 *      3、至于代码里，该怎么改怎么改
 * 另：如果表结构确实完全变掉了，直接修改上边的宏：ZLE_DATABASE_FILENAME @"zle_database_v001.db"，相当于定了新的数据库，老数据会全部丢失
 */
#define ZLE_DATABASE_VERSION @"1"//数据库版本号

@class FMDatabaseQueue;
@interface ZLECache : NSObject

+ (ZLECache *)sharedCache;

#pragma mark - 数据库操作函数 TODO

@end
