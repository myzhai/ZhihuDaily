//
//  StoryViewController.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/25/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "StoryViewController.h"
#import "Macro.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

#define PLACEHOLDERIMAGE [UIImage imageNamed:@"0"]

@interface StoryViewController () <UIScrollViewDelegate>

@property (copy, nonatomic) NSString *htmlString;
@property (copy, nonatomic) NSString *imageURLString;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopLayoutConstraint;

@end

static CGFloat const originalContentOffset_y = -220;

@implementation StoryViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - private methods

- (NSString *)html:(NSString *)body {
    NSMutableString *html = [NSMutableString stringWithString:@"<html>"];
    [html appendString:@"<body>"];
    [html appendString:body];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    return html;
}

- (void)setup {
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.imageView.height, 0, self.toolbar.height, 0);
    self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.imageView.height - 20, 0, self.toolbar.height, 0);
    for (UIView *view in self.webView.scrollView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) {
            NSLog(@"UIWebBrowserView");
            view.y = view.y - 20;
            break;
        }
    }
}

- (NSURL *)storyURLWithStoryID:(NSNumber *)story_id {
    return [NSURL URLWithString:[NSString convertToHttpsStringWithHttpString:[storyURLPrefix stringByAppendingString:[story_id stringValue]]]];
}

- (void)refresh {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[self storyURLWithStoryID:self.storyID] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", dict);
            self.htmlString = [self html:dict[@"body"]];
            self.imageURLString = [NSString convertToHttpsStringWithHttpString:dict[@"image"]];
        } else {
            NSLog(@"%s: Internet connection error", __func__);
        }
    }] resume];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat topOffset = scrollView.contentOffset.y - originalContentOffset_y;
    self.imageViewTopLayoutConstraint.constant = -topOffset;
    [self.view layoutIfNeeded];
}

#pragma mark - connected actions

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:self];
}

#pragma mark - getters and setters

- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadHTMLString:htmlString baseURL:nil];
    });
}

- (void)setImageURLString:(NSString *)imageURLString {
    _imageURLString = imageURLString;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:PLACEHOLDERIMAGE];
    });
}

@end

