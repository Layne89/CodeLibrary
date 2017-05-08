//
//  UIColor+ZLECategory.m
//  UIColor类别
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "UIColor+ZLECategory.h"

@implementation UIColor (ZLECategory)

+ (UIColor *)colorWithString:(NSString *)hexColor{
    if(hexColor == nil){
        return nil;
    }
    if(hexColor.length != 7 || ![hexColor hasPrefix:@"#"]){
        return nil;
    }
    NSString *correction = @"0123456789abcdef";
    for(int i = 1;i<7;++i){
        NSString *c = [hexColor substringWithRange:NSMakeRange(i, 1)];
        if(![correction containsString:c]){
            return nil;
        }
    }
    
    NSString *colorStr = [hexColor substringFromIndex:1];
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (UIColor *)colorWithString:(NSString *)hexColor alpha:(CGFloat)alpha{
    UIColor *color = [self colorWithString:hexColor];
    UIColor *resultColor=nil;
    if(color && alpha>=0 && alpha<=1){
        const CGFloat *colors = CGColorGetComponents(color.CGColor);
        resultColor = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:alpha];
    }
    return  resultColor;
}

+ (UIColor *)randomColor {
    //arc4random_uniform(N):0~N-1随机数
    CGFloat red = arc4random_uniform(256)/255.0f;
    CGFloat green = arc4random_uniform(256)/255.0f;
    CGFloat blue = arc4random_uniform(256)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
