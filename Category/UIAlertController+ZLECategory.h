//
//  UIAlertController+ZLECategory.h
//  UIAlertController类别
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ZLECategory)

+ (void)showAlert:(NSString*)title message:(NSString *)message;

+ (void)showAlert:(NSString*)title message:(NSString *)message okButtonClicked:(void (^)(void))OKBlock;

+ (void)showAlert:(NSString*)title message:(NSString *)message okButtonClicked:(void (^)(void))OKBlock cancelButtonClicked:(void (^)(void))CancelBlock;

@end
