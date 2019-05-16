//
//  DetectViewController.m
//  storm
//
//  Created by kevin on 2019/5/16.
//  Copyright © 2019 jumu. All rights reserved.
//

#import "DetectViewController.h"
#import <AVFoundation/AVFoundation.h>


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define lxy(x, y, w, h)                    CGRectMake(x, y, w, h)



@interface DetectViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation DetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    
    
    [self initUII];
    [self setupCamera];
   
}


- (void)initUII{
    
    //    (SCREEN_WIDTH-220)/2+220;
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-110, SCREEN_HEIGHT)];
    leftView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+110, 0, SCREEN_WIDTH/2-110, SCREEN_HEIGHT)];
    rightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-110, 0, 220, 100)];
    upView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-110, 100+220, 220, SCREEN_HEIGHT-220-100)];
    downView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    [self.view addSubview:downView];
    
    
    
    
    
    
}


- (void)setupCamera
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    
    //扫描区域控制
    //    AVCaptureMetadataOutput 中的属性rectOfInterest 看起来是CGRect类型, 填写一个比例。加入屏幕的frame 为 x , y, w, h, 要设置的矩形快的frame 为 x1, y1, w1, h1. 那么rectOfInterest 应该设置为 CGRectMake(y1/y, x1/x, h1/h, w1/w)。
    CGSize size = self.view.bounds.size;
//    CGRect cropRect = CGRectMake(SCREEN_WIDTH/2-110,100,220,220);
    CGRect cropRect = CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    output.rectOfInterest =  CGRectMake(cropRect.origin.y/SCREEN_HEIGHT,
                                        cropRect.origin.x/size.width,
                                        cropRect.size.height/size.height,
                                        cropRect.size.width/size.width);
    
    
    
    
    
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式
    //    output.metadataObjectTypes =@[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        NSLog(@"--%@",stringValue);
    }
    
    
    //    if ([metadataObjects count] >0)
    //    {
    //        [[[SoundModel alloc]init] getRightSound];
    //        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
    //        stringValue = metadataObject.stringValue;
    //        if (self.delegate && [self.delegate respondsToSelector:@selector(oddNumber:)]) {
    //            [self.delegate oddNumber:stringValue];
    //        }
    //
    //    }
    //
    //    if (!isSweep) {
    //        [timer invalidate];
    //        [_session stopRunning];
    //        [self disMiss];
    //    }
}





@end
