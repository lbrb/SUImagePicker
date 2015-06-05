//
//  TestViewController.m
//  SUImagePickerController
//
//  Created by liangbin on 15/6/4.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import "TestViewController.h"
#import "SUImagePickerController.h"
#import "SUImagePickerGroupTableViewController.h"

@interface TestViewController ()<SUImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"打开相册" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(10, 400, 200, 40);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showImagePicker
{
    SUImagePickerController *imageC = [[SUImagePickerController alloc] init];
    
    imageC.delegate = self;
    imageC.numberInSignalLine = 5.0;
    imageC.multiSelect = YES;
    imageC.sourceType = SUImagePickerControllerSourceTypePhotoGroups;
    imageC.imageGroupName = @"Qqq";
    
    [self presentViewController:imageC animated:YES completion:nil];
}

#pragma mark delegate
- (void)SUImagePickerController:(SUImagePickerController *)picker didFinishPickingImage:(NSArray *)images
{
    for (int i = 0; i< images.count; i++) {
        UIImage *image = images[i];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        CGFloat x = 0+ 70*i;
        CGFloat y = 100;
        CGFloat width = 70  ;
        CGFloat height = 70;
        imageV.frame = CGRectMake(x,y,width,height);
        [self.view addSubview:imageV];
    }

}

@end
