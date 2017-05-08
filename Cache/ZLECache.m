//
//  ZLECache.m
//  缓存类-操作FMDB
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "ZLECache.h"
#import "FMDB.h"


NSString * const ZLE_TABLE_EXAMPLE = @"Example";

@interface ZLECache()
@property (nonatomic, strong)FMDatabaseQueue *queue;//database queue
@property (nonatomic, copy)NSString *databasePath;
@end

@implementation ZLECache

static ZLECache *sharedInstance = nil;

+ (ZLECache *)sharedCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if(sharedInstance==nil){
        sharedInstance = [super allocWithZone:zone];
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init{
    self=[super init];
    if(self){
        [self initDatabase];
    }
    return self;
}

- (void)initDatabase{
    if([self createDatabaseDirectory]){
        _queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
        [self createTables];
    }else{
        NSLog(@"--Create Database Directory Failed!--");
    }
}

/* 创建数据库文件路径 */
- (BOOL)createDatabaseDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *dbDirectory =[NSString stringWithFormat:@"%@/ZLEDatabase",documentsPath];
    NSFileManager *fManager = [NSFileManager defaultManager];
    if(![fManager fileExistsAtPath:dbDirectory]){
        BOOL success = [fManager createDirectoryAtPath:dbDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(success){
            _databasePath = [dbDirectory stringByAppendingPathComponent:ZLE_DATABASE_FILENAME];
        }else{
            _databasePath = nil;
        }
        return success;
    }
    _databasePath = [dbDirectory stringByAppendingPathComponent:ZLE_DATABASE_FILENAME];
    return YES;
}

/* 创建表 */
- (void)createTables{
    [self checkDBVersion];
    
    if(![self hasTable:ZLE_TABLE_EXAMPLE]){
        NSString *DDL_SQL_TABLE_EXAMPLE = [NSString stringWithFormat:@"CREATE TABLE [%@](\
                                                                      [id]            INTEGER PRIMARY KEY AUTOINCREMENT,\
                                                                      [createdate]    VARCHAR(128),\
                                                                      [attid]         VARCHAR(128) UNIQUE,\
                                                                      [empid]         VARCHAR(128),\
                                                                      [cname]         VARCHAR(128),\
                                                                      [customercode]  VARCHAR(128),\
                                                                      [atttype]       VARCHAR(128),\
                                                                      [filename]      VARCHAR(128),\
                                                                      [idcard]        VARCHAR(128),\
                                                                      [ocridcard]     VARCHAR(128),\
                                                                      [memo]          VARCHAR(128))",ZLE_TABLE_EXAMPLE];
        [_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:DDL_SQL_TABLE_EXAMPLE];
        }];
    }
}

/* 判断是否有tableName的表 */
- (BOOL)hasTable:(NSString *)tableName{
    __block BOOL has = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        has = [db tableExists:tableName];
    }];
    return has;
}

#pragma mark - 数据库版本检查,升级增加column
- (void)checkDBVersion{
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"dbVersion"];
    if(previousVersion && [previousVersion isEqualToString:ZLE_DATABASE_VERSION]){//版本号未变
        return;
    }
    
    NSDictionary *fieldDict = [ZLECache upgradeFields];
    if(fieldDict.count<1){
        return;
    }
    [fieldDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tableName = (NSString *)key;
        NSArray *fields = (NSArray *)obj;
        if([self hasTable:tableName]){
            [fields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *field = (NSString *)obj;//nColume1 varchar(128)
                NSString *fieldName = [field componentsSeparatedByString:@" "].firstObject;//nColume1
                [_queue inDatabase:^(FMDatabase *db) {
                    NSString *checkSQL = [NSString stringWithFormat:@"select * from %@",tableName];
                    FMResultSet *rs = [db executeQuery:checkSQL];
                    if([rs columnIndexForName:fieldName]==-1){//不存在要增加的列
                        NSString *alterSQL = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@",tableName,field];
                        [db executeUpdate:alterSQL];
                    }
                    [rs close];
                    
                }];
            }];

        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:ZLE_DATABASE_VERSION forKey:@"dbVersion"];//更新数据库版本号
}

#pragma mark - 数据库升级增加字段
+ (NSDictionary *)upgradeFields{
    NSDictionary *fields=@{ZLE_TABLE_EXAMPLE:@[@"nColume1 varchar(128)",@"nColume2 INTEGER"]};//nColume1和varchar(128)之间必须有至少一个空格，用于解析
    return fields;
}

#pragma mark - 数据库操作函数 TODO


@end
