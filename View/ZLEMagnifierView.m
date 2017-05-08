//
//  ZLEMagnifierView.m
//  放大镜
//
//  Created by layne on 16/12/2.
//  Copyright © 2016年 layne. All rights reserved.
//

#import "ZLEMagnifierView.h"
#define ZLEDefaultScale 2.0f //默认放大倍率
#define ZLEDefaultRadius 60 //半径

@interface ZLEMagnifierView ()
@property (nonatomic, strong)UIView *viewToMagnify;
@end

@implementation ZLEMagnifierView

+ (instancetype)magnifierViewWithTarget:(UIView *)targetView{
    ZLEMagnifierView *magnifierView = [[self alloc] initWithFrame:CGRectMake(0, 0, ZLEDefaultRadius * 2, ZLEDefaultRadius * 2)];
    magnifierView.viewToMagnify = targetView;
    return magnifierView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = ZLEDefaultRadius;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

/* 更新 */
- (void)update:(CGPoint)touchPoint{
    //更新位置
    CGFloat scopeWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scopeHeight = [UIScreen mainScreen].bounds.size.height;
    if(_viewToMagnify){
        scopeWidth = _viewToMagnify.frame.size.width;
        scopeHeight = _viewToMagnify.frame.size.height;
    }
    CGFloat dx = 0;
    CGFloat dy = -100;
    if(scopeWidth-touchPoint.x < 100){
        dx =-100;
    }else if(touchPoint.x<100){
        dx = 100;
    }
    
    if(touchPoint.y<100){
        dy=200;
    }else if(scopeHeight - touchPoint.y<100){
        dy = -100;
    }
    self.center = CGPointMake(touchPoint.x+dx, touchPoint.y+dy);
    
    //更新内容
    CGSize size= CGSizeMake(_viewToMagnify.frame.size.width*ZLEDefaultScale, _viewToMagnify.frame.size.height*ZLEDefaultScale);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, ZLEDefaultScale, ZLEDefaultScale);//放大两倍
    //方法1和方法2都可以，但是！实际操作中，方法1曾造成CPU飙升，方法2很完美。再但是！在我写这个代码库的时候发现，方法1却比方法2好。
    //因此，以后使用的时候俩方法都测测吧。
    //区别在于，实际操作中，ZLEMagnifier继承自UIWindow，而当前继承自UIImageView,这个可能有影响 Layne 2017-4-20
    [_viewToMagnify.layer renderInContext:context];//方法1
//    [_viewToMagnify drawViewHierarchyInRect:_viewToMagnify.bounds afterScreenUpdates:YES];//方法2
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//截屏
    UIGraphicsEndImageContext();
    
    CGPoint point;
    point.x = touchPoint.x * ZLEDefaultScale;
    point.y = touchPoint.y * ZLEDefaultScale;
    
    CGFloat width = ZLEDefaultRadius*2;
    CGFloat height = width;
    CGRect rect1 = CGRectMake(point.x-0.5*width, point.y-0.5*height, width, height);
    
    //截取rect范围的图片
    UIImage *result = [self imageFromRect:rect1 image:image];
    self.image = result;
}

- (UIImage *)imageFromRect:(CGRect)rect image:(UIImage *)image {
    if (CGRectEqualToRect(rect, CGRectNull) || CGRectEqualToRect(rect, CGRectZero)) {
        return image;
    }
    CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [[UIImage alloc] initWithCGImage:ref];
    CGImageRelease(ref);
    return result;
}

#pragma mark - 放大镜的显示、更新和隐藏
- (void)showAtPoint:(CGPoint)point{
    [self update:point];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)dealloc{
    _viewToMagnify = nil;
    
}

@end
