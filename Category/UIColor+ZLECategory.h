//
//  UIColor+ZLECategory.h
//  UIColor类别
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZLECategory)

+ (UIColor *)colorWithString:(NSString *)hexColor;

+ (UIColor *)colorWithString:(NSString *)hexColor alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;

@end
