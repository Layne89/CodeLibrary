//
//  ZLESecurity.m
//  加密类
//
//  Created by layne on 17/3/6.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "ZLESecurity.h"

@implementation ZLESecurity

/* DES加密 */
+ (NSString *)encryptWithDES:(NSString *)plainText key:(NSString *)key{
    const void *dataIn;
    size_t dataInLength;
    
    NSData* encryptData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    dataInLength = [encryptData length];
    dataIn = (const void *)[encryptData bytes];

    /*  DES加密 ：用CCCrypt函数加密一下，然后转换为16进制数，传过去 */
    size_t dataOutMoved = 0;
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [key UTF8String];
    
    //CCCrypt函数 加密/解密
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmDES,
                                       kCCOptionPKCS7Padding,
                                       vkey,  //密钥
                                       kCCKeySizeDES,
                                       iv, //  可选的初始矢量
                                       dataIn, // 数据的存储单元
                                       dataInLength,// 数据的大小
                                       (void *)dataOut,// 用于返回数据
                                       dataOutAvailable,
                                       &dataOutMoved);
    NSString *result = nil;
    if(ccStatus == kCCSuccess){
        //编码 转16进制
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        NSMutableString *str = [NSMutableString string];
        Byte *byte = (Byte *)[data bytes];
        for (int i = 0; i<[data length]; i++) {
            [str appendString:[self stringFromByte:*(byte+i)]];
        }
        result = str;
    }
    
    return result;

}

/* DES解密 */
+ (NSString *)decryptWithDES:(NSString *)cipherText key:(NSString *)key{
    //解码 16进制转换data
    if (!cipherText || [cipherText length] == 0) {
        return nil;
    }
    
    const void *dataIn;
    size_t dataInLength;
    NSMutableData *decryptData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([cipherText length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [cipherText length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [cipherText substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [decryptData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    dataInLength = [decryptData length];
    dataIn = [decryptData bytes];

    /* DES解密 ：把收到的数据根据16进制转data，然后再用CCCrypt函数解密，得到原本的数据 */
    CCCryptorStatus ccStatus;

    size_t dataOutMoved = 0;
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [key UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(kCCDecrypt,//  解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    if(ccStatus == kCCSuccess){
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }

    return result;
}

/* byte to string */
+ (NSString *)stringFromByte:(Byte)byteVal{
    NSMutableString *str = [NSMutableString string];
    
    //取高四位
    Byte byte1 = byteVal>>4;
    //取低四位
    Byte byte2 = byteVal & 0xf;
    //拼接16进制字符串
    [str appendFormat:@"%x",byte1];
    [str appendFormat:@"%x",byte2];
    return str;
}

@end
