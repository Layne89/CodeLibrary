//
//  UIImage+ZLECategory.h
//  UIImage类别
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZLECategory)
@property (nonatomic, copy)NSString *name;//图片名称

/* 创建纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/* 生成二维码 */
+ (UIImage *)QRCode:(NSString *)info size:(CGFloat)width;

/* 生成彩色二维码 */
+ (UIImage *)QRCode:(NSString *)info size:(CGFloat)width codeColor:(UIColor *)cdColor backgroundColor:(UIColor *)bgColor;

/* 裁剪 */
- (UIImage*)cropImageWithRect:(CGRect)rect;

/* 旋转 */
- (UIImage *)rotate:(UIImageOrientation)orientation;

/* 调整图片大小 */
- (UIImage *)resizeImageWithSize:(CGSize)targetSize;

/* 
 * 由于iphone传感器的问题，拍出来的图片包含orientation信息
 * 显示出来的图片会跟实际朝向有差别，因此这里要进行fix
 */
- (UIImage *)fixOrientation;

@end
