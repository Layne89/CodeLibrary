//
//  ZLEScanViewController.m
//  扫一扫
//
//  Created by layne on 16/11/30.
//  Copyright © 2016年 layne. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ZLEScanViewController.h"

@implementation ZLEScanCoverView
@synthesize focusRect;
@synthesize scanLineLayer;
@synthesize tipLabel;

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画背景和方框
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    CGMutablePathRef screenPath = CGPathCreateMutable();
    CGPathAddRect(screenPath, NULL, self.bounds);
    CGMutablePathRef scanPath = CGPathCreateMutable();
    CGPathAddRect(scanPath, NULL, focusRect);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddPath(path, NULL, screenPath);
    CGPathAddPath(path, NULL, scanPath);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    //方框border
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
    CGMutablePathRef borderPath = CGPathCreateMutable();
    CGPathAddRect(borderPath, NULL, focusRect);
    CGContextAddPath(context, borderPath);
    CGContextDrawPath(context, kCGPathStroke);
    //方框四个角
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGMutablePathRef cornerPath = CGPathCreateMutable();
    //左上
    CGPathMoveToPoint(cornerPath, NULL, focusRect.origin.x+15, focusRect.origin.y);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x, focusRect.origin.y);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x, focusRect.origin.y+15);
    
    //左下
    CGPathMoveToPoint(cornerPath, NULL, focusRect.origin.x, (focusRect.origin.y+focusRect.size.height)-15);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x, focusRect.origin.y+focusRect.size.height);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x+15, focusRect.origin.y+focusRect.size.height);
    //右下
    CGPathMoveToPoint(cornerPath, NULL, (focusRect.origin.x+focusRect.size.width)-15, focusRect.origin.y+focusRect.size.height);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x+focusRect.size.width, focusRect.origin.y+focusRect.size.height);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x+focusRect.size.width, (focusRect.origin.y+focusRect.size.height)-15);
    

    //右上
    CGPathMoveToPoint(cornerPath, NULL, focusRect.origin.x+focusRect.size.width, focusRect.origin.y+15);
    CGPathAddLineToPoint(cornerPath, NULL, focusRect.origin.x+focusRect.size.width, focusRect.origin.y);
    CGPathAddLineToPoint(cornerPath, NULL, (focusRect.origin.x+focusRect.size.width)-15, focusRect.origin.y);
    
    CGContextAddPath(context, cornerPath);
    CGContextDrawPath(context, kCGPathStroke);
    

    CGPathRelease(screenPath);
    CGPathRelease(scanPath);
    CGPathRelease(path);
    CGPathRelease(cornerPath);
    CGPathRelease(borderPath);
    
    //添加扫描线
    scanLineLayer = [[CAGradientLayer alloc] init];
    [scanLineLayer setFrame:CGRectMake(focusRect.origin.x, focusRect.origin.y+5, focusRect.size.width, 2)];
    scanLineLayer.startPoint = CGPointMake(0, 0);
    scanLineLayer.endPoint = CGPointMake(1, 0);
    scanLineLayer.colors = [NSArray arrayWithObjects:
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0] CGColor] ,
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.2] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.4] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.6] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.8] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:1.0] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.8] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.6] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.4] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0.2] CGColor],
                        (id)[[[UIColor blueColor] colorWithAlphaComponent:0] CGColor],
                        nil];
    [self.layer addSublayer:scanLineLayer];
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint:scanLineLayer.position];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(scanLineLayer.position.x,scanLineLayer.position.y + focusRect.size.height-5*2)];
    animation.duration = 2.0f;
    animation.repeatCount = MAXFLOAT;
    [scanLineLayer removeAllAnimations];
    [scanLineLayer addAnimation:animation forKey:@"scanAnimation"];
}

/* 重新setter方法 */
- (void)setFocusRect:(CGRect)rect{
    focusRect = rect;
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"将二维码或者条码放入框内，即可自动扫描";
    [tipLabel sizeToFit];
    [tipLabel setCenter:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height+25+tipLabel.frame.size.height/2)];
    [self addSubview:tipLabel];
    
}

/* 启动动画 */
- (void)startAnimation{
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint:scanLineLayer.position];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(scanLineLayer.position.x,scanLineLayer.position.y + focusRect.size.height-5*2)];
    animation.duration = 2.0f;
    animation.repeatCount = MAXFLOAT;
    [scanLineLayer removeAllAnimations];
    [scanLineLayer addAnimation:animation forKey:@"scanAnimation"];
}

/* 停止动画 */
-(void)stopAnimation{
    [scanLineLayer removeAllAnimations];
}

- (void)dealloc{
    [scanLineLayer removeAllAnimations];//停止动画
}

@end



@interface ZLEScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)UIView  *bgView;
@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureDevice *device;
@property (nonatomic, strong)AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong)AVCaptureMetadataOutput *deviceOutput;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;//相机预览视图的layer
@property (nonatomic, strong)ZLEScanCoverView *coverView;//扫码中间的方框
@property (nonatomic, strong)UITapGestureRecognizer *tapRecognizer;
@end

@implementation ZLEScanViewController

- (instancetype)init{
    if(self = [super init]){
        [self customSettings];
    }
    return self;
}

- (void)dealloc{
    if(_session){
        [_session stopRunning];
        _session = nil;
    }
    _device = nil;
    _deviceInput = nil;
    _deviceOutput = nil;
    _previewLayer = nil;
    _coverView = nil;

    [_bgView removeGestureRecognizer:_tapRecognizer];
    _tapRecognizer = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已为该App关闭摄像头使用权限"
                                                                       message:@"您可以在”设置“中为此应用打开摄像头使用权限"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        _deviceOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }

    [self startReading];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopReading];
}

- (void)customSettings{
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    //扫码界面初始化
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _deviceOutput = [[AVCaptureMetadataOutput alloc] init];
    [_deviceOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if([_session canAddInput:_deviceInput]){
        [_session addInput:_deviceInput];
    }
    if([_session canAddOutput:_deviceOutput]){
         [_session addOutput:_deviceOutput];
    }
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [_previewLayer setFrame:_bgView.bounds];
    
    [_bgView.layer addSublayer:_previewLayer];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    deviceOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //设置扫码范围-方块
    _deviceOutput.rectOfInterest = [self defaultRectForMetadataOutput];
    
    _coverView = [[ZLEScanCoverView alloc] initWithFrame:_bgView.frame];
    _coverView.focusRect = [self defaultRectForNormal];
    _coverView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_coverView];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventHandler:)];
    [_bgView addGestureRecognizer:_tapRecognizer];
    
    [self.view addSubview:_bgView];

}

/* 开始读取 */
- (void)startReading{
    [self.coverView startAnimation];
    [_session startRunning];
    
}

/* 停止读取 */
- (void)stopReading{
    [self.coverView stopAnimation];
    [_session stopRunning];
}

/* 扫描区域默认Rect 
 * MetadataOutput rectOfInterest是以左上角为（0，0），向下为x正，向右为y正
 * 即与正常坐标系相反，且范围为0~1（eg.CGRectMake(0.5,0,0.5,1)表示下半屏幕） 2016-11-30 Layne
 */
- (CGRect)defaultRectForMetadataOutput{
    CGFloat superWith = _bgView.frame.size.width;
    CGFloat superHeight = _bgView.frame.size.height;
    
    CGFloat width = _bgView.frame.size.width *2/3;
    CGFloat height = width;
    CGFloat x = (superWith - width)/2.0f;
    CGFloat y = (superHeight - height)/2.0f;
    
    return CGRectMake(y/superHeight, x/superWith, height/superHeight, width/superWith);
    
}

/* 扫码框默认Rect */
- (CGRect)defaultRectForNormal{
    CGFloat superWith = _bgView.frame.size.width;
    CGFloat superHeight = _bgView.frame.size.height;
    
    CGFloat width = _bgView.frame.size.width *2/3;
    CGFloat height = width;
    CGFloat x = (superWith - width)/2.0f;
    CGFloat y = (superHeight - height)/2.0f;
    
    return CGRectMake(x, y, width, height);
}

/* 自动对焦 */
- (void)autoFocusAtPoint:(CGPoint)point {
    if ([_device isFocusPointOfInterestSupported] && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([_device lockForConfiguration:&error]) {
            [_device setFocusPointOfInterest:point];
            [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [_device unlockForConfiguration];
        }
    }
    
}

#pragma mark - Gesture Event
/* Tap */
- (void)tapEventHandler:(UITapGestureRecognizer *)tap{
    [self autoFocusAtPoint:[tap locationInView:_bgView]];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if(metadataObjects.count>0) {
        [self stopReading];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString *resultStr = metadataObject.stringValue;
        NSLog(@"%@",resultStr);
        [self startReading];
    }
}

@end
