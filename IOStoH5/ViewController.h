//
//  ViewController.h
//  IOStoH5
//
//  Created by water on 14-8-15.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^JSCallback)(NSString *retunData);

@interface ViewController : UIViewController<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,UIAlertViewDelegate>{

    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
}
@property (strong, nonatomic) IBOutlet UIWebView *theWebView;
@property (strong, nonatomic) AVAudioPlayer *avPlay;
@property (strong, nonatomic) JSCallback jsCallback;

@property (strong, nonatomic) NSString *onlineUrl;

@end
