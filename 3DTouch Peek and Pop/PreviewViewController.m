//
//  PreviewViewController.m
//  3DTouch Peek and Pop
//
//  Created by wyh on 2018/5/15.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<UIImage *>* gifs;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Gif";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.gifImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startPreviewing];
}

- (void)dealloc {
    
}



- (void)startPreviewing {
    
    if (self.gifImageView.animationImages.count > 0 && !self.gifImageView.isAnimating) {
        
        [self.gifImageView startAnimating];
        self.gifImageView.center = self.view.center;
    }
    
//    CGRect frame = self.gifImageView.frame;
//    frame.origin.y -= 22;
//    frame.size.height += 22;
//    self.gifImageView.frame = frame;
}

- (void)stopPreviewing {
    
    self.gifImageView.center = self.view.center;
    
    [self reconfigUIIfPreviewStopped];
}

- (void)reconfigUIIfPreviewStopped {
    
    [self.gifImageView stopAnimating];
    self.gifImageView.hidden = YES;
    
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    CGFloat edgeX = 5.f, imgW = (UIScreen.mainScreen.bounds.size.width - edgeX*3)/2;
    CGFloat edgeY = 5.f;
    UIView *lastImg = NULL;
    for (int i = 0; i < self.gifs.count; i++) {
        @autoreleasepool {
            UIImage *img = self.gifs[i];
            UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
            CGFloat imgX = (i%2==0)?edgeX:(imgW+2*edgeX);
            CGFloat imgY = (i%2==0) ? (!lastImg?(64.f+edgeY):CGRectGetMaxY(lastImg.frame)+edgeY) : (lastImg.frame.origin.y);
            imgView.frame = CGRectMake(imgX, imgY, imgW, imgW*0.9);
            [self.scrollView addSubview:imgView];
            lastImg = imgView;
        }
    }
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lastImg.frame));
}

#pragma mark - API

- (CGSize)setGifImages:(NSArray<UIImage *>*)gifImages {
    
    _gifs = [gifImages copy];
    CGSize originalSize = CGSizeZero;
    
    if (gifImages.count > 0) {
        self.gifImageView.animationImages = [gifImages copy];
        self.gifImageView.animationDuration = 0.2 * gifImages.count;
        self.gifImageView.animationRepeatCount = MAXFLOAT;
        [self.gifImageView sizeToFit];
        originalSize = self.gifImageView.bounds.size;
    }
    return originalSize;
}

#pragma mark - previewActionItems

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *share = [UIPreviewAction actionWithTitle:@"Share" style:(UIPreviewActionStyleDefault) handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewAction *cancel = [UIPreviewAction actionWithTitle:@"Cancel" style:(UIPreviewActionStyleDestructive) handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    return @[share,cancel];
}

#pragma mark - lazy

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc]init];
    }
    return _gifImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end