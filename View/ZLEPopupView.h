//
//  ZLEPopupView.h
//  PopupView
//
//  Created by layne on 16/12/14.
//  Copyright © 2016年 layne. All rights reserved.
//

#import <UIKit/UIKit.h>

/* popView伸出来的那个小三角位置 */
typedef NS_ENUM(NSInteger, kZLEPopViewTrianglePosition){
    kZLEPopViewTrianglePositionTopLeft,//顶部左侧
    kZLEPopViewTrianglePositionTopCenter,
    kZLEPopViewTrianglePositionTopRight,
    kZLEPopViewTrianglePositionBottomLeft,//下部左侧
    kZLEPopViewTrianglePositionBottomCenter,
    kZLEPopViewTrianglePositionBottomRight
};
@class ZLEPopupView;
@protocol ZLEPopupViewDelegate <NSObject>
//PopupView按钮点击事件
- (void)popupView:(ZLEPopupView *)popupView didSelectItemAtIndex:(NSUInteger)index;
@end


@interface ZLEButtonContainerView : UIView
@property (nonatomic, assign)NSInteger buttonCount;
@property (nonatomic, assign)kZLEPopViewTrianglePosition trianglePosition;
@property (nonatomic, assign)CGPoint trianglePoint;//三角顶点
@end


@interface ZLEPopupView : UIView <CAAnimationDelegate>
@property (nonatomic, strong)ZLEButtonContainerView *containerView;
@property (nonatomic, weak)id<ZLEPopupViewDelegate> delegate;
@property (nonatomic, strong)NSArray *buttonTitles;//button标题
@property (nonatomic, strong)NSArray *buttonIcons;//button图标
@property (nonatomic, assign)CGRect touchRect;//点击的rect，标识popview显示的位置
@property (nonatomic, assign)kZLEPopViewTrianglePosition position;
@property (nonatomic, strong)UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, assign)BOOL animated;//是否使用动画显示和隐藏popview

- (instancetype)initWithDelegate:(id<ZLEPopupViewDelegate>)aDelegate buttonTitles:(NSArray *)titles buttonIcons:(NSArray *)icons touchTarget:(UIView *)target  style:(kZLEPopViewTrianglePosition)style;

/* 以动画形式弹出 */
- (void)showWithAnimation:(BOOL)animated;

@end
