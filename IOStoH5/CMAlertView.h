//
//  CMShareDialog.h
//  MLPlayer
//
//  Created by water on 14-6-30.
//  Copyright (c) 2014年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMAlertView;

typedef void (^CompletionBlock)(NSUInteger buttonIndex, CMAlertView *alertView);
typedef void (^CustomizationBlock)(CMAlertView *alertView);

@protocol CMAlertViewDelegate <NSObject>
- (void)CMAlertView:(CMAlertView *)alert didClickOnButtonIndex:(NSInteger)buttonIndex;
@end

@interface CMAlertView : UIView

@property (nonatomic,assign) id<CMAlertViewDelegate> delegate;
@property (nonatomic,strong) UITextField *textfield;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIImageView *imageview;

@property (nonatomic,strong) CompletionBlock completionBlock;
@property (nonatomic,strong) CustomizationBlock customizationBlock;

- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle;
- (id)initWithTitle:(NSString *)title description:(NSString *)description cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle completionBlock:(CompletionBlock)block;

- (id)initWithTitle:(NSString *)title delegate:(id<CMAlertViewDelegate>)delegate description :(NSString*)description image:(UIImage *)image cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle;
- (id)initWithPlaceholder:(NSString *)placeholder cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle completionBlock:(CompletionBlock)block;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle completionBlock:(CompletionBlock)block;
- (void)show;
- (void)showInView:(UIView *)view;

- (NSInteger)cancleButtonInde;
- (NSInteger)confirmButtonInde;

@end