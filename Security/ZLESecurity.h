//
//  ZLESecurity.h
//  加密类
//
//  Created by layne on 17/3/6.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

#define ZLEDESKey @"12345678"

@interface ZLESecurity : NSObject

/* DES加密 */
+ (NSString *)encryptWithDES:(NSString *)plainText key:(NSString *)key;

/* DES解密 */
+ (NSString *)decryptWithDES:(NSString *)cipherText key:(NSString *)key;

@end
