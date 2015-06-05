//
//  SUPreviewImagesViewController.m
//  SUImagePickerController
//
//  Created by liangbin on 15/6/4.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//



#import "SUImagePickerPreviewImagesViewController.h"
#import "SUImagePickerController.h"

static CGFloat const bottomViewHeight = 44;

@interface SUImagePickerPreviewImagesViewController ()

@end

@implementation SUImagePickerPreviewImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    //navigationbar
    self.navigationItem.title = @"图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    //下面的View
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomViewHeight, self.view.frame.size.width, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor grayColor];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat confirmBtnX = bottomView.frame.size.width - 55.0;
    CGFloat confirmBtnY = 6.0;
    CGFloat confirmBtnWidth = 45.0;
    CGFloat confirmBtnHeight = 32.0;
    confirmBtn.frame = CGRectMake(confirmBtnX, confirmBtnY, confirmBtnWidth, confirmBtnHeight);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
    [self.view addSubview:bottomView];
    
    //上面的scroolView
    //每页的宽度，高度
    CGFloat pageHeight = bottomView.frame.origin.y;
    CGFloat pageWidth = bottomView.frame.size.width;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomViewHeight);
    scrollView.contentSize = CGSizeMake(pageWidth * self.images.count, pageHeight);
    
    //imageView Frame
    CGFloat imageViewWidth = 0;
    CGFloat imageViewHeight = 0;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    for (int i=0; i<self.images.count; i++) {
        UIImage *image = self.images[i];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        //宽高比
        CGFloat widthScale = image.size.width/scrollView.frame.size.width;
        CGFloat hightScale = image.size.height/scrollView.frame.size.height;
        
        if (widthScale > hightScale) {
            imageViewWidth = image.size.width/widthScale;
            imageViewHeight = image.size.height/widthScale;
            imageViewX = pageWidth*i;
            imageViewY = (pageHeight - imageViewHeight)/2.0;
        } else {
            imageViewWidth = image.size.width/hightScale;
            imageViewHeight = image.size.height/hightScale;
            imageViewX = pageWidth*i;
            imageViewY = (pageHeight - imageViewHeight)/2.0;
        }
        imageView.frame = CGRectMake(imageViewX,imageViewY,imageViewWidth,imageViewHeight);
        [scrollView addSubview:imageView];
    }
    
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirm
{
    if (self.navigationController.delegate && [self.navigationController.delegate respondsToSelector:@selector(SUImagePickerController:didFinishPickingImage:)]) {
        [self.navigationController.delegate performSelector:@selector(SUImagePickerController:didFinishPickingImage:) withObject:self.images];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
