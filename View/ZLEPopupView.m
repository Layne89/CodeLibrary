//
//  ZLEPopupView.m
//  PopupView
//
//  Created by layne on 16/12/14.
//  Copyright © 2016年 layne. All rights reserved.
//

#import "ZLEPopupView.h"
#define ZLEDefaultCornerRadius 5 //角半径
#define ZLEDefaultTriangleHeight 10 //小三角的高度
#define ZLEDefaultButtonHeight 40 //按钮高度
#define ZLEDefaultButtonWidth 150 //按钮宽度
#define ZLEDefaultDistance 5//popupview距离点击的button的距离

@implementation ZLEButtonContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _buttonCount = 0;
        _trianglePosition = kZLEPopViewTrianglePositionTopLeft;
        _trianglePoint = CGPointMake(frame.size.width/2.0f, 0);//默认中点
    }
    return self;
}

/* 添加按钮 */
- (void)addButton:(UIButton *)button{
    [self addSubview:button];
    _buttonCount++;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    if(_trianglePosition == kZLEPopViewTrianglePositionTopLeft ||
       _trianglePosition == kZLEPopViewTrianglePositionTopCenter ||
       _trianglePosition == kZLEPopViewTrianglePositionTopRight){
        CGContextMoveToPoint(context, ZLEDefaultCornerRadius, ZLEDefaultTriangleHeight);
        CGContextAddLineToPoint(context, _trianglePoint.x-ZLEDefaultTriangleHeight/2.0f, ZLEDefaultTriangleHeight);
        CGContextAddLineToPoint(context, _trianglePoint.x, 0);
        CGContextAddLineToPoint(context, _trianglePoint.x+ZLEDefaultTriangleHeight/2.0f, ZLEDefaultTriangleHeight);
        CGContextAddLineToPoint(context, rect.size.width- 2*ZLEDefaultCornerRadius, ZLEDefaultTriangleHeight);
        CGContextAddArcToPoint(context,rect.size.width,ZLEDefaultTriangleHeight , rect.size.width, ZLEDefaultTriangleHeight+ZLEDefaultCornerRadius, ZLEDefaultCornerRadius);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-ZLEDefaultCornerRadius);
        CGContextAddArcToPoint(context, rect.size.width, rect.size.height, rect.size.width-ZLEDefaultCornerRadius, rect.size.height, ZLEDefaultCornerRadius);
        CGContextAddLineToPoint(context, ZLEDefaultCornerRadius, rect.size.height);
        CGContextAddArcToPoint(context, 0, rect.size.height, 0, rect.size.height-ZLEDefaultCornerRadius, ZLEDefaultCornerRadius);
        CGContextAddLineToPoint(context, 0, ZLEDefaultCornerRadius+ZLEDefaultTriangleHeight);
        CGContextAddArcToPoint(context, 0, ZLEDefaultTriangleHeight, ZLEDefaultCornerRadius, ZLEDefaultTriangleHeight, ZLEDefaultCornerRadius);

    }else{
        CGContextMoveToPoint(context, ZLEDefaultCornerRadius, 0);
        CGContextAddLineToPoint(context, rect.size.width- 2*ZLEDefaultCornerRadius, 0);
        CGContextAddArcToPoint(context, rect.size.width, 0, rect.size.width, ZLEDefaultCornerRadius, ZLEDefaultCornerRadius);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-ZLEDefaultTriangleHeight-ZLEDefaultCornerRadius);
        CGContextAddArcToPoint(context, rect.size.width, rect.size.height-ZLEDefaultTriangleHeight, rect.size.width-ZLEDefaultCornerRadius, rect.size.height-ZLEDefaultTriangleHeight, ZLEDefaultCornerRadius);
        CGContextAddLineToPoint(context, _trianglePoint.x+ZLEDefaultTriangleHeight/2.0f, rect.size.height-ZLEDefaultTriangleHeight);
        CGContextAddLineToPoint(context, _trianglePoint.x, rect.size.height);
        CGContextAddLineToPoint(context, _trianglePoint.x-ZLEDefaultTriangleHeight/2.0f, rect.size.height-ZLEDefaultTriangleHeight);
        
        CGContextAddLineToPoint(context, ZLEDefaultCornerRadius, rect.size.height-ZLEDefaultTriangleHeight);
        CGContextAddArcToPoint(context, 0, rect.size.height-ZLEDefaultTriangleHeight, 0, rect.size.height-ZLEDefaultTriangleHeight-ZLEDefaultCornerRadius, ZLEDefaultCornerRadius);
        CGContextAddLineToPoint(context, 0, ZLEDefaultCornerRadius);
        CGContextAddArcToPoint(context, 0, 0, ZLEDefaultCornerRadius, 0, ZLEDefaultCornerRadius);

    }

    CGContextFillPath(context);
    
    
    BOOL isTop = YES;
    if(_trianglePosition == kZLEPopViewTrianglePositionTopLeft ||
       _trianglePosition == kZLEPopViewTrianglePositionTopCenter ||
       _trianglePosition == kZLEPopViewTrianglePositionTopRight){
        isTop = YES;
    }else{
        isTop = NO;
    }
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    

    for(int i=0;i<_buttonCount-1;++i){
        CGContextMoveToPoint(context, 0, (isTop?ZLEDefaultTriangleHeight:0)+(i+1)*ZLEDefaultButtonHeight);
        CGContextAddLineToPoint(context, rect.size.width, (isTop?ZLEDefaultTriangleHeight:0)+(i+1)*ZLEDefaultButtonHeight);
    }
    CGContextStrokePath(context);
    
}

@end



@implementation ZLEPopupView

- (instancetype)initWithDelegate:(id<ZLEPopupViewDelegate>)aDelegate
                    buttonTitles:(NSArray *)titles
                     buttonIcons:(NSArray *)icons
                       touchTarget:(UIView *)target
                           style:(kZLEPopViewTrianglePosition)style{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        _delegate = aDelegate;
        _buttonTitles = (titles?[titles copy]:@[]);
        _buttonIcons = (icons?[icons copy]:@[]);
        _touchRect = [target.superview convertRect:target.frame toView:[UIApplication sharedApplication].keyWindow];
        _position = style;
        [self customSettings];
    }
    return self;
}

- (void)dealloc{
    [self removeGestureRecognizer:_tapRecognizer];
    _tapRecognizer = nil;
    _containerView = nil;
    _delegate = nil;
}

- (void)customSettings{
    //半透明背景
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //点击手势
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopupView)];
    [self addGestureRecognizer:_tapRecognizer];
    
    
    BOOL isTop = YES;//三角是否在顶部，否则在底部
    if(_position == kZLEPopViewTrianglePositionTopLeft ||
       _position == kZLEPopViewTrianglePositionTopCenter ||
       _position == kZLEPopViewTrianglePositionTopRight){
        isTop = YES;
    }else{
        isTop = NO;
    }
    //button container
    CGRect rect = CGRectZero;
    rect.size.width = ZLEDefaultButtonWidth;
    rect.size.height = ZLEDefaultButtonHeight * MAX(_buttonTitles.count,_buttonIcons.count) + ZLEDefaultTriangleHeight;//button container高度
    _containerView = [[ZLEButtonContainerView alloc] initWithFrame:rect];
    [_containerView setTrianglePosition:_position];//设置popview的三角位置
    
    NSInteger maxNum = MAX(_buttonTitles.count,_buttonIcons.count);//取最大值
    for(int i = 0;i<maxNum;++i){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+i;//设置tag进行区分
        btn.layer.cornerRadius = ZLEDefaultCornerRadius;
        btn.clipsToBounds = YES;
        CGRect rect = CGRectZero;
        rect.origin.x = 0;
        rect.origin.y = (isTop?ZLEDefaultTriangleHeight:0)+ZLEDefaultButtonHeight * i;
        rect.size.width = ZLEDefaultButtonWidth;
        rect.size.height = ZLEDefaultButtonHeight;
        [btn setFrame:rect];
        [btn setTitle:(_buttonTitles[i]?_buttonTitles[i]:@"")  forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];//调整文字位置
        
        if(_buttonIcons.count !=0 && _buttonIcons.count>i){
            [btn setImage:_buttonIcons[i] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];//调整图片位置
        }
        
        [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addButton:btn];
    }
    [self addSubview:_containerView];
    
    //设置containerView的位置
    CGRect cRect = _containerView.frame;
    if(cRect.size.width<_touchRect.size.width){//popview的宽度比点击的按钮宽度窄，则将popview居中显示
        if(isTop){
            _position = kZLEPopViewTrianglePositionTopCenter;
        }else{
            _position = kZLEPopViewTrianglePositionBottomCenter;
        }
        [_containerView setTrianglePosition:_position];
    }
    CGPoint point = CGPointZero;//设置三角顶点
    switch(_position){
        case kZLEPopViewTrianglePositionTopLeft:{
            cRect.origin.x = _touchRect.origin.x;
            cRect.origin.y = _touchRect.origin.y + _touchRect.size.height + ZLEDefaultDistance;
            point.x = _touchRect.size.width/2.0f;
            point.y = 0;
            break;
        }
        case kZLEPopViewTrianglePositionTopCenter:{
            cRect.origin.x = (_touchRect.origin.x+_touchRect.size.width/2.0f)-cRect.size.width/2.0f;
            cRect.origin.y = _touchRect.origin.y+ _touchRect.size.height+ZLEDefaultDistance;
            point.x = cRect.size.width/2.0f;
            point.y = 0;
            break;
        }
        case kZLEPopViewTrianglePositionTopRight:{
            cRect.origin.x = _touchRect.origin.x+_touchRect.size.width-cRect.size.width;
            cRect.origin.y = _touchRect.origin.y+ _touchRect.size.height+ZLEDefaultDistance;
            point.x = cRect.size.width - _touchRect.size.width/2.0f;
            point.y = 0;
            break;
        }
        case kZLEPopViewTrianglePositionBottomLeft:{
            cRect.origin.x = cRect.origin.x = _touchRect.origin.x;
            cRect.origin.y = _touchRect.origin.y-(ZLEDefaultDistance+cRect.size.height);
            point.x = _touchRect.size.width/2.0f;
            point.y = cRect.size.height;
            break;
        }
        case kZLEPopViewTrianglePositionBottomCenter:{
            cRect.origin.x = (_touchRect.origin.x+_touchRect.size.width/2.0f)-cRect.size.width/2.0f;
            cRect.origin.y = _touchRect.origin.y-(ZLEDefaultDistance+cRect.size.height);
            point.x = cRect.size.width/2.0f;
            point.y = cRect.size.height;
            break;
        }
        case kZLEPopViewTrianglePositionBottomRight:{
            cRect.origin.x = _touchRect.origin.x+_touchRect.size.width-cRect.size.width;
            cRect.origin.y = _touchRect.origin.y-(ZLEDefaultDistance+cRect.size.height);
            point.x = cRect.size.width - _touchRect.size.width/2.0f;
            point.y = cRect.size.height;
            break;
        }
        default:{
            break;
        }
    }
    [_containerView setTrianglePoint:point];//设置三角顶点的位置,主要是使用其x值
    [_containerView setFrame:cRect];
}

/* 各个item点击事件 */
- (void)itemClicked:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(popupView:didSelectItemAtIndex:)]){
        [_delegate popupView:self didSelectItemAtIndex:sender.tag - 1000];
    }
    [self hidePopupView];
}

#pragma mark - Tap Recognizer Handler
- (void)hidePopupView{
    if(_animated){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.2; // 动画持续时间
        animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:0.01]; // 结束时的倍率
        //必须要有以下两句，才能保持最终动画状态
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        
        animation.delegate = self;
        [_containerView.layer removeAllAnimations];
        [_containerView.layer addAnimation:animation forKey:@"scale-layer"];
    }else{
        [self removeFromSuperview];
    }
}

/* 以动画形式弹出 */
- (void)showWithAnimation:(BOOL)animated{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _animated = animated;
    if(_animated){
        [self adjustContainerView];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.2; // 动画持续时间
        animation.fromValue = [NSNumber numberWithFloat:0.01]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
        
        [_containerView.layer removeAllAnimations];
        [_containerView.layer addAnimation:animation forKey:@"scale-layer"];
    }

}

/* 调整anchor值 */
- (void)adjustContainerView{
    CGPoint nAnchorPoint = CGPointMake(_containerView.trianglePoint.x/_containerView.frame.size.width, _containerView.trianglePoint.y/_containerView.frame.size.height);
    [_containerView.layer setAnchorPoint:nAnchorPoint];
    CGPoint oAnchorPoint = CGPointMake(0.5, 0.5);
    CGRect rect = _containerView.frame;
    rect.origin.x = rect.origin.x + rect.size.width * (nAnchorPoint.x - oAnchorPoint.x);
    rect.origin.y = rect.origin.y + rect.size.height * (nAnchorPoint.y - oAnchorPoint.y);    
    
    [_containerView setFrame:rect];

}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_containerView.layer removeAllAnimations];//为防止retain cycle,在代理方法里移除animation
    
    CGPoint oAnchorPoint = _containerView.layer.anchorPoint;
    CGPoint nAnchorPoint = CGPointMake(0.5, 0.5);
    [_containerView.layer setAnchorPoint:nAnchorPoint];
    CGRect rect = _containerView.frame;
    rect.origin.x = rect.origin.x - rect.size.width * (oAnchorPoint.x - nAnchorPoint.x);
    rect.origin.y = rect.origin.y - rect.size.height * (oAnchorPoint.y - nAnchorPoint.y);
    [_containerView setFrame:rect];

    [self removeFromSuperview];
}

@end
