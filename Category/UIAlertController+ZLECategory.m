//
//  UIAlertController+ZLECategory.m
//  UIAlertController类别
//
//  Created by layne on 17/4/18.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "UIAlertController+ZLECategory.h"

@implementation UIAlertController (ZLECategory)

+ (void)showAlert:(NSString*)title message:(NSString *)message{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
    
    UIViewController *currentCtrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([currentCtrl isKindOfClass:[UINavigationController class]]) {
        currentCtrl = ((UINavigationController *)currentCtrl).visibleViewController;
    }
    [currentCtrl presentViewController:alertCtrl animated:YES completion:nil];

}

+ (void)showAlert:(NSString*)title message:(NSString *)message okButtonClicked:(void (^)(void))OKBlock{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if(OKBlock){
                                                        OKBlock();
                                                    }
                                                }]];
    
    UIViewController *currentCtrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([currentCtrl isKindOfClass:[UINavigationController class]]) {
        currentCtrl = ((UINavigationController *)currentCtrl).visibleViewController;
    }
    [currentCtrl presentViewController:alertCtrl animated:YES completion:nil];
}

+ (void)showAlert:(NSString*)title message:(NSString *)message okButtonClicked:(void (^)(void))OKBlock cancelButtonClicked:(void (^)(void))CancelBlock{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if(OKBlock){
                                                        OKBlock();
                                                    }
                                                }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if(CancelBlock){
                                                        CancelBlock();
                                                    }
                                                }]];
    
    UIViewController *currentCtrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([currentCtrl isKindOfClass:[UINavigationController class]]) {
        currentCtrl = ((UINavigationController *)currentCtrl).visibleViewController;
    }
    [currentCtrl presentViewController:alertCtrl animated:YES completion:nil];
}

@end
