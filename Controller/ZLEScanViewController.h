//
//  ZLEScanViewController.h
//  扫一扫
//
//  Created by layne on 16/11/30.
//  Copyright © 2016年 layne. All rights reserved.
//

#import <UIKit/UIKit.h>
/* 扫码框所在的view */
@interface ZLEScanCoverView : UIView
@property (nonatomic, assign)CGRect focusRect;//扫描框
@property (nonatomic, strong)CAGradientLayer *scanLineLayer;//扫码线
@property (nonatomic, strong)UILabel *tipLabel;//扫描框下方提示
/* 启动动画 */
- (void)startAnimation;

/* 停止动画 */
-(void)stopAnimation;

@end


@interface ZLEScanViewController : UIViewController

@end
