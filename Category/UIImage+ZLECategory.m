//
//  UIImage+ZLECategory.m
//  UIImage类别
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "UIImage+ZLECategory.h"
#import <objc/runtime.h>

@implementation UIImage (ZLECategory)
#pragma mark - Setter
- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_COPY);
}

#pragma mark - Getter
- (NSString *)name{
    return objc_getAssociatedObject(self, @"name");
}

/* 创建纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    if(size.width == 0 || size.height == 0 || color == nil){
        return nil;
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(50, 50, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/* 生成二维码 */
+ (UIImage *)QRCode:(NSString *)info size:(CGFloat)width{
    if(!info || width<=0){
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//二维码纠错水平
    
    CIImage *outputImage = [filter outputImage];
    UIImage *QRImage = [self createNonInterpolatedUIImageFromCIImage:outputImage size:width];

    return QRImage;
}

/* 生成彩色二维码 */
+ (UIImage *)QRCode:(NSString *)info size:(CGFloat)width codeColor:(UIColor *)cdColor backgroundColor:(UIColor *)bgColor{
    if(!info || width<=0){
        return nil;
    }
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [QRFilter setDefaults];
    [QRFilter setValue:data forKeyPath:@"inputMessage"];
    [QRFilter setValue:@"H" forKey:@"inputCorrectionLevel"];//二维码纠错水平

    //默认白底黑字
    UIColor *codeColor = [UIColor blackColor];
    UIColor *backgroundColor = [UIColor whiteColor];
    if(cdColor){
        codeColor = cdColor;
    }
    if(bgColor){
        backgroundColor = bgColor;
    }
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:@"inputImage",[QRFilter outputImage],
                                                     @"inputColor0",[CIColor colorWithCGColor:codeColor.CGColor],
                                                     @"inputColor1",[CIColor colorWithCGColor:backgroundColor.CGColor],nil];
    
    CIImage *outputImage = [colorFilter outputImage];
    UIImage *QRImage = [self createNonInterpolatedUIImageFromCIImage:outputImage size:width];
    
    return QRImage;

}

/* 生成高清图片 */
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image size:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // create bitmap context;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;

    CGContextRef bitmapContextRef = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          width*4,
                                                          CGColorSpaceCreateDeviceRGB(),
                                                          kCGImageAlphaNoneSkipLast);
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [ciContext createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapContextRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapContextRef, scale, scale);
    CGContextDrawImage(bitmapContextRef, extent, bitmapImage);
    
    //generate CGImageRef
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapContextRef);
    CGContextRelease(bitmapContextRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/* 裁剪 */
- (UIImage*)cropImageWithRect:(CGRect)rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *resultImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return resultImage;
}

/* 旋转 */
- (UIImage *)rotate:(UIImageOrientation)orientation{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleX = rect.size.height/rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *resultPic = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘制否则会造成内存泄露
    UIGraphicsEndImageContext();
    
    return resultPic;
}

/* 调整图片大小 */
- (UIImage *)resizeImageWithSize:(CGSize)targetSize{
    if(targetSize.width == 0 || targetSize.height == 0){
        return nil;
    }
    CGRect targetRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:targetRect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(resultImage == nil){
        NSLog(@"Error!Could not resize image!");
    }
    return resultImage;
    
}

/* 调整图片Orientation */
- (UIImage *)fixOrientation{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


@end
