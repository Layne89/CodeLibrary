//
//  ZLEMagnifierView.h
//  放大镜
//
//  Created by layne on 16/12/2.
//  Copyright © 2016年 layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLEMagnifierView : UIImageView

+ (instancetype)magnifierViewWithTarget:(UIView *)targetView;

#pragma mark - 放大镜的显示、更新和隐藏
- (void)showAtPoint:(CGPoint)point;

/* 更新内容和位置 */
- (void)update:(CGPoint)touchPoint;

- (void)hide;

@end
