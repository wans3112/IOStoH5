//
//  ViewController.m
//  IOStoH5
//
//  Created by water on 14-8-15.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "NSString+URL.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AudioToolbox/AudioServices.h>
#import "CMAlertView.h"

@interface ViewController ()

@end


@implementation ViewController
@synthesize avPlay = _avPlay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self audio];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    [self becomeFirstResponder];

    self.theWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.theWebView.delegate = self;
    [self.view addSubview:self.theWebView];
    if (self.onlineUrl) {
        [self loadHtml:self.onlineUrl];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [self.theWebView loadRequest:request];
    }

    //@"http://192.168.2.70:8888/test.html"
}

- (void)loadHtml:(NSString *)surl{
    NSString *path = surl;
    NSURL *url = [[NSURL alloc] initWithString:path];
    [self.theWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"url:%@\ndata:%@",request.mainDocumentURL.relativeString,[request.mainDocumentURL.relativeString defaultParameters]);
    NSString *type = [request.mainDocumentURL.relativePath parametersKey];
    if([type isEqualToString:@"writeData"])
    {
        NSDictionary *data = [request.mainDocumentURL.relativeString defaultParameters];
        NSString *key = [data objectForKey:@"id"];
        NSString *value = [data objectForKey:@"data"];
        NSString *callback = [data objectForKey:@"fn"];

        BOOL result = [self writeData:value key:key];
        NSString *js = [NSString stringWithFormat:@"%@(\"%@\",\"%@\",\"%d\")",callback,type,value,result];
        [self.theWebView stringByEvaluatingJavaScriptFromString:js];
        return false;
    }else if([type isEqualToString:@"readData"])
    {
        NSDictionary *data = [request.mainDocumentURL.relativeString defaultParameters];
        NSString *key = [data objectForKey:@"id"];
        NSString *callback = [data objectForKey:@"fn"];

        NSString *localData = [self readData:key];
        NSString *js = [NSString stringWithFormat:@"%@(\"%@\",\"%@\",\"%d\")",callback,type,localData,0];
        [self.theWebView stringByEvaluatingJavaScriptFromString:js];
        return false;
    }else if([type isEqualToString:@"delData"])
    {
        NSDictionary *data = [request.mainDocumentURL.relativeString defaultParameters];
        NSString *key = [data objectForKey:@"id"];
        NSString *callback = [data objectForKey:@"fn"];

        BOOL result = [self deleteData:key];
        NSString *js = [NSString stringWithFormat:@"%@(\"%@\",\"%@\",\"%d\")",callback,type,key,result];
        [self.theWebView stringByEvaluatingJavaScriptFromString:js];
        return false;
    }else if([type isEqualToString:@"driverSensor"])
    {
        NSDictionary *data = [request.mainDocumentURL.relativeString defaultParameters];
        NSString *device_type = [data objectForKey:@"device"];
        NSString *callback = [data objectForKey:@"fn"];
        
        if ([device_type isEqualToString:@"photo"]) {
            [self takePhoto:0 callback:^(NSString *retunData) {
                NSString *js = [NSString stringWithFormat:@"%@(\"%@\",\"%@\")",callback,device_type,retunData];
                [self.theWebView stringByEvaluatingJavaScriptFromString:js];
            }];
        }else if ([device_type isEqualToString:@"video"]) {
            [self takePhoto:1 callback:^(NSString *retunData) {
                NSString *js = [NSString stringWithFormat:@"%@(\"%@\",\"%@\")",callback,device_type,retunData];
                [self.theWebView stringByEvaluatingJavaScriptFromString:js];
            }];
        }else if ([device_type isEqualToString:@"audio"]) {
            [self playRecord:^(NSString *retunData) {
                NSString *js = [NSString stringWithFormat:@"%@(\"%@\",\"%@\")",callback,device_type,retunData];
                [self.theWebView stringByEvaluatingJavaScriptFromString:js];
            }];
        }else if ([device_type isEqualToString:@"shake"]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }

        return false;
    }
    return true;
}

- (BOOL)writeData:(NSString *)value key:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:value forKey:key];
    return [ud synchronize];
}

- (NSString *)readData:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    return [ud objectForKey:key];
}

- (BOOL)deleteData:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    return [ud synchronize];
}

- (void)takePhoto:(int)type callback:(JSCallback)callback{
    self.jsCallback = callback;
    
    UIImagePickerController *picker =[[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    if(type == 1){
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie,nil];
        [picker setMediaTypes: arrMediaTypes];
    }
    
    [self presentModalViewController:picker animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaUrl;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
 
    if([mediaType isEqualToString:@"public.movie"])
        
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //获取视频的thumbnail
        mediaUrl = [videoURL absoluteString];
    }else if ([mediaType isEqualToString:@"public.image"]){
        UIImage* oralImg=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        ////保存到本地
        mediaUrl = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"temp.png"];
        
        NSError* err=nil;
        if(![UIImagePNGRepresentation(oralImg) writeToFile:mediaUrl options:NSDataWritingAtomic error:&err])
            NSLog(@"oralImg save file failed :err%@",[err localizedFailureReason]);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.jsCallback) {
            self.jsCallback(mediaUrl);
            self.jsCallback= nil;
        }
    }];
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //检测到摇动
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        //检测到“摇一摇动作”，回调给js
        NSString *js = @"sdCallBack()";
        [self.theWebView stringByEvaluatingJavaScriptFromString:js];
    }
}

- (void)playRecordSound
{
    if (self.avPlay.playing) {
        [self.avPlay stop];
        return;
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    self.avPlay = player;
    [player release];
    [self.avPlay play];
    
    if (self.jsCallback) {
        self.jsCallback([urlPlay absoluteString]);
        self.jsCallback= nil;
    }
}

- (void)playRecord :(JSCallback)callback
{
    self.jsCallback = callback;

    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"正在录音..." delegate:self cancelButtonTitle:@"停止" otherButtonTitles:@"播放", nil];
        [alert show];
    }
    
    //设置定时检测
//    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self playRecordSound];
    }else{
        [self btnDragUp];
    }
}

- (void)btnUp
{
    double cTime = recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
        NSLog(@"发出去");
    }else {
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    [recorder stop];
    [timer invalidate];
}
- (void)btnDragUp
{
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    
    NSLog(@"取消发送");
}
- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[[NSMutableDictionary alloc]init] autorelease];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    urlPlay = url;
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
