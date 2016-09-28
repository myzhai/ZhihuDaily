//
//  WelcomeView.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "WelcomeView.h"
#import "Macro.h"
#import "UIView+Extension.h"
#import "LaunchImageModel.h"
#import "NSString+Extension.h"

@interface WelcomeView ()

@property (strong, nonatomic) UIImageView *logoView;
@property (strong, nonatomic) UIImageView *bgView;

@property (assign, nonatomic) BOOL bgViewShowed;

@end

@implementation WelcomeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bgViewShowed = NO;
        
        _bgView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_bgView setImage:[UIImage imageNamed:@"launch"]];
        [self addSubview:_bgView];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[NSString convertToHttpsStringWithHttpString:launchImageURL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error && data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                LaunchImageModel *launchImageModel = [LaunchImageModel launchImageModelWithDictionary:dict];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[session dataTaskWithURL:[NSURL URLWithString:launchImageModel.img] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *image = [UIImage imageWithData:data];
                            if (image) {
                                [_bgView setImage:image];
                            } else {
                                [_bgView setImage:[UIImage imageNamed:@"Splash_Image"]];
                            }
                            _bgViewShowed = YES;
                        });
                    }] resume];
                });
            } else {
                [_bgView setImage:[UIImage imageNamed:@"Splash_Image"]];
                _bgViewShowed = YES;
            }
        }] resume];
        
        _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 142.5)];
        _logoView.image = [UIImage imageNamed:@"Splash_Logo_Plus"];
        _logoView.centerX = _bgView.centerX;
        _logoView.centerY = self.height + _logoView.height * 0.5;
        [self addSubview:_logoView];
    }
    
    return self;
}

- (void)didMoveToWindow {
    CGFloat delay = 0;
    if (!_bgViewShowed) {
        delay += 0.5;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.6 animations:^{
            self.logoView.transform = CGAffineTransformMakeTranslation(0, -_logoView.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:3 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    });
}

@end
