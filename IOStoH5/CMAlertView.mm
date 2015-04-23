//
//  CMShareDialog.m
//  MLPlayer
//
//  Created by water on 14-6-30.
//  Copyright (c) 2014年 w. All rights reserved.
//

#import "CMAlertView.h"

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define TEXT_SPACING_X                           10
#define ANIMATE_DURATION                        0.25f
#define BACKGROUND_WIDTH                        280
#define BACKGROUND_HEIGHT                       175
#define BACKGROUND_COLOR                        [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define DESC_MAXHEIGHT                          50
#define BUTTON_CANCEL_TAG                       100
#define BUTTON_CONFIRM_TAG                      101

@interface CMAlertView ()

@property (nonatomic,strong) UIView *backGroundView,*shadowView;
@property (nonatomic,assign) BOOL isHadImage;
@end


@implementation CMAlertView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title delegate:(id<CMAlertViewDelegate>)delegate description:(NSString *)description image:(UIImage *)image cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle{
    self.delegate = delegate;
    return [self initWithTitle:title description:description image:image cancelButtonTitle:cancelButtonTitle comfirmButtonTitle:comfirmButtonTitle];
}

- (id)initWithTitle:(NSString *)title description:(NSString *)description cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle completionBlock:(CompletionBlock)block{
    
    self.completionBlock = block;
    
    return [self initWithTitle:title description:description image:nil cancelButtonTitle:cancelButtonTitle comfirmButtonTitle:comfirmButtonTitle];
};

- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle{
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        //        [self addGestureRecognizer:tapGesture];
        
        
        self.shadowView = [[UIView alloc]initWithFrame:self.bounds];
        self.shadowView.backgroundColor = WINDOW_COLOR;
        self.shadowView.alpha = 0.f;
        //        [self.shadowView addGestureRecognizer:tapGesture];
        
        [self addSubview:self.shadowView];
        
        [self creatViewsWithTitle:title description:description image:image cancelButtonTitle:cancelButtonTitle comfirmButtonTitle:comfirmButtonTitle];
        
    }
    return self;
};

- (void)setDelegate:(id<CMAlertViewDelegate>)delegate{
    if (delegate) {
        _delegate = delegate;
    }
}

- (void)creatViewsWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle{
    
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKGROUND_WIDTH, BACKGROUND_HEIGHT)];
    self.backGroundView.backgroundColor =  [UIColor whiteColor];
    self.backGroundView.center = self.center;
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 2.f;
    
    CGFloat origin_x = 70;
    self.isHadImage = YES;
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 60, 60)];
    self.imageview.image = [UIImage imageNamed:@"ulp"];
    self.imageview.backgroundColor = [UIColor clearColor];
    [self.backGroundView addSubview:self.imageview];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(origin_x + TEXT_SPACING_X, 10, CGRectGetWidth(self.backGroundView.frame) - origin_x - 2 * TEXT_SPACING_X, 18)];
    self.titleLabel .backgroundColor = [UIColor clearColor];
    self.titleLabel .text = title;
    self.titleLabel .textColor = [UIColor blackColor];
    self.titleLabel .font = [UIFont systemFontOfSize:15.f];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.backgroundColor = [UIColor clearColor];
    self.descLabel.text = description;
    self.descLabel.textColor = [UIColor darkGrayColor];
    self.descLabel.font = [UIFont systemFontOfSize:12.f];
    self.descLabel.numberOfLines = 0;
    
    CGSize descSize = [description sizeWithFont:self.descLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.titleLabel.frame), DESC_MAXHEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    self.descLabel.frame = CGRectMake(origin_x + TEXT_SPACING_X, CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.backGroundView.frame) - origin_x - 2 * TEXT_SPACING_X, descSize.height);
    
    [self.backGroundView addSubview:self.titleLabel];
    [self.backGroundView addSubview:self.descLabel];
    
    UIView *textFieldBackView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 5 + DESC_MAXHEIGHT , BACKGROUND_WIDTH - 20, 34)];
    textFieldBackView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    textFieldBackView.userInteractionEnabled = YES;
    textFieldBackView.layer.masksToBounds = YES;
    textFieldBackView.layer.cornerRadius = 2.f;
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 2,BACKGROUND_WIDTH - 30 ,30)];
    self.textfield.font = [UIFont systemFontOfSize:16.f];
    self.textfield.placeholder = @"说点什么";
    self.textfield.returnKeyType = UIReturnKeyDone;
    self.textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.textfield.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.textfield addTarget:self action:@selector(textfieldbegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.textfield addTarget:self action:@selector(textfieldreturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [textFieldBackView addSubview:self.textfield];
    [self.backGroundView addSubview:textFieldBackView];
    
    UIView *spView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textFieldBackView.frame) + 10, BACKGROUND_WIDTH, 1)];
    spView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.backGroundView addSubview:spView];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20, CGRectGetMaxY(spView.frame) + 7, 100, 30);
    [cancleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    cancleButton.tag = BUTTON_CANCEL_TAG;
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_nor@2x"] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_sel@2x"] forState:UIControlStateHighlighted];
    [cancleButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(160, CGRectGetMaxY(spView.frame) + 7, 100, 30);
    [confirmButton setTitle:comfirmButtonTitle forState:UIControlStateNormal];
    confirmButton.tag = BUTTON_CONFIRM_TAG;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"interact_agree_btn_normal"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"interact_agree_btn_highlight"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backGroundView addSubview:cancleButton];
    [self.backGroundView addSubview:confirmButton];
    [self addSubview:self.backGroundView];
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.shadowView.alpha = 1.0;
    }];
    
}

- (id)initWithPlaceholder:(NSString *)placeholder cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle completionBlock:(CompletionBlock)block{
    
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        
        self.shadowView = [[UIView alloc]initWithFrame:self.bounds];
        self.shadowView.backgroundColor = WINDOW_COLOR;
        self.shadowView.alpha = 0.f;
        [self.shadowView addGestureRecognizer:tapGesture];
        
        [self addSubview:self.shadowView];
        
        self.completionBlock = block;
        
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKGROUND_WIDTH, 100)];
        self.backGroundView.backgroundColor =  [UIColor whiteColor];
        self.backGroundView.center = self.center;
        self.backGroundView.layer.masksToBounds = YES;
        self.backGroundView.layer.cornerRadius = 2.f;
        
        CGFloat origin_y = 20;
        CGFloat titleWidth = CGRectGetWidth(self.backGroundView.frame) - 2 * TEXT_SPACING_X;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(TEXT_SPACING_X, origin_y, titleWidth, 18)];
        self.titleLabel .backgroundColor = [UIColor clearColor];
        self.titleLabel .text = placeholder;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel .textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel .font = [UIFont systemFontOfSize:15.f];
        
        CGSize size = [placeholder sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(titleWidth, 60) lineBreakMode:NSLineBreakByWordWrapping];
        self.titleLabel.frame = CGRectMake(TEXT_SPACING_X, origin_y, titleWidth, size.height);
        [self.backGroundView addSubview:self.titleLabel];

        
        origin_y = 20 + origin_y + size.height;
        UIView *textFieldBackView = [[UIView alloc]initWithFrame:CGRectMake(10, origin_y , BACKGROUND_WIDTH - 20, 35)];
        textFieldBackView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        textFieldBackView.userInteractionEnabled = YES;
        textFieldBackView.layer.masksToBounds = YES;
        textFieldBackView.layer.cornerRadius = 2.f;
        
        self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 2.5,BACKGROUND_WIDTH - 30 ,30)];
        self.textfield.font = [UIFont systemFontOfSize:16.f];
//        self.textfield.placeholder = placeholder;
        self.textfield.returnKeyType = UIReturnKeyDone;
        self.textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.textfield.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self.textfield addTarget:self action:@selector(textfieldbegin:) forControlEvents:UIControlEventEditingDidBegin];
        [self.textfield addTarget:self action:@selector(textfieldreturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [textFieldBackView addSubview:self.textfield];
        [self.backGroundView addSubview:textFieldBackView];
        
        origin_y = origin_y + 20 + CGRectGetHeight(self.textfield.frame);
        
        UIView *spView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textFieldBackView.frame) + 10, BACKGROUND_WIDTH, 1)];
        spView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self.backGroundView addSubview:spView];
        
        origin_y = origin_y + 10;
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(20, origin_y, 100, 30);
        [cancleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        cancleButton.tag = BUTTON_CANCEL_TAG;
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_nor@2x"] forState:UIControlStateNormal];
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_sel@2x"] forState:UIControlStateHighlighted];
        [cancleButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(160, origin_y, 100, 30);
        [confirmButton setTitle:comfirmButtonTitle forState:UIControlStateNormal];
        confirmButton.tag = BUTTON_CONFIRM_TAG;
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"interact_agree_btn_normal"] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"interact_agree_btn_highlight"] forState:UIControlStateHighlighted];
        [confirmButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        origin_y = origin_y + 10 + CGRectGetHeight(cancleButton.frame);
        [self.backGroundView setFrame:CGRectMake(0, 0, BACKGROUND_WIDTH, origin_y)];
        self.backGroundView.center = self.center;
        
        [self.backGroundView addSubview:cancleButton];
        [self.backGroundView addSubview:confirmButton];
        [self addSubview:self.backGroundView];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            self.shadowView.alpha = 1.0;
        }];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle comfirmButtonTitle:(NSString *)comfirmButtonTitle completionBlock:(CompletionBlock)block{
    
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        
        self.shadowView = [[UIView alloc]initWithFrame:self.bounds];
        self.shadowView.backgroundColor = WINDOW_COLOR;
        self.shadowView.alpha = 0.f;
        [self.shadowView addGestureRecognizer:tapGesture];
        
        [self addSubview:self.shadowView];
        
        self.completionBlock = block;
        
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKGROUND_WIDTH, 100)];
        self.backGroundView.backgroundColor =  [UIColor whiteColor];
        self.backGroundView.center = self.center;
        self.backGroundView.layer.masksToBounds = YES;
        self.backGroundView.layer.cornerRadius = 2.f;
        
        CGFloat origin_y = 20;
        CGFloat titleWidth = CGRectGetWidth(self.backGroundView.frame) - 2 * TEXT_SPACING_X;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(TEXT_SPACING_X, origin_y, titleWidth, 18)];
        self.titleLabel .backgroundColor = [UIColor clearColor];
        self.titleLabel .text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel .textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel .font = [UIFont systemFontOfSize:15.f];
        
        CGSize size = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(titleWidth, 60) lineBreakMode:NSLineBreakByWordWrapping];
        self.titleLabel.frame = CGRectMake(TEXT_SPACING_X, origin_y, titleWidth, size.height);
        [self.backGroundView addSubview:self.titleLabel];
        
        origin_y = origin_y + 20 + CGRectGetHeight(self.titleLabel.frame);
        UIView *spView = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, BACKGROUND_WIDTH, 1)];
        spView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self.backGroundView addSubview:spView];
        
        origin_y = origin_y + 10;
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(20, origin_y, 100, 30);
        [cancleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        cancleButton.tag = BUTTON_CANCEL_TAG;
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_nor@2x"] forState:UIControlStateNormal];
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"btn_sel@2x"] forState:UIControlStateHighlighted];
        [cancleButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(160, origin_y, 100, 30);
        [confirmButton setTitle:comfirmButtonTitle forState:UIControlStateNormal];
        confirmButton.tag = BUTTON_CONFIRM_TAG;
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"interact_agree_btn_normal"] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"interact_agree_btn_highlight"] forState:UIControlStateHighlighted];
        [confirmButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        origin_y = origin_y + 10 + CGRectGetHeight(cancleButton.frame);
        [self.backGroundView setFrame:CGRectMake(0, 0, BACKGROUND_WIDTH, origin_y)];
        self.backGroundView.center = self.center;
        [self.backGroundView addSubview:cancleButton];
        [self.backGroundView addSubview:confirmButton];
        [self addSubview:self.backGroundView];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            self.shadowView.alpha = 1.0;
        }];
    }
    return self;
}

- (void)buttonPressed:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(CMAlertView:didClickOnButtonIndex:)]) {
        [_delegate CMAlertView:self didClickOnButtonIndex:sender.tag];
    }
    if (self.completionBlock) {
        self.completionBlock(sender.tag,self);
        self.completionBlock = nil;
    }
    [self tappedCancel];
}

- (void)textfieldbegin:(UITextField *)sender{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        CGRect frame = self.backGroundView.frame;
        frame.origin.y = self.backGroundView.frame.origin.y - 100;
        self.backGroundView.frame = frame;
    }];
}

- (void)textfieldreturn:(UITextField *)sender{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.backGroundView.center = self.center;
    }];
    [sender resignFirstResponder];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}

- (void)show{
    [self showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
}

- (void)tappedCancel
{
    [self.textfield resignFirstResponder];
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.shadowView.alpha = 0.0;
        self.backGroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (NSInteger)cancleButtonInde
{
    return BUTTON_CANCEL_TAG;
}

- (NSInteger)confirmButtonInde
{
    return BUTTON_CONFIRM_TAG;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
