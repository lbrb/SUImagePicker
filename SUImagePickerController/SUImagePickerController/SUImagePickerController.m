//
//  SUImagePIckerController.m
//  SUImagePickerController
//
//  Created by liangbin on 15/6/2.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import "SUImagePickerController.h"
#import "SUImagePickerCollectionViewController.h"
#import "SUImagePickerGroupTableViewController.h"

@interface SUImagePickerController ()
@property (strong, nonatomic) SUImagePickerCollectionViewController *imageCollectionVc;
@property (strong, nonatomic) SUImagePickerGroupTableViewController *imageGroup;
@end

@implementation SUImagePickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //配置默认参数
        self.numberInSignalLine = 4.0;
        self.multiSelect = NO;
        //图片组
        self.imageGroup = [[SUImagePickerGroupTableViewController alloc] init];
        [self addChildViewController:self.imageGroup];
        
        //图片集合
        self.imageCollectionVc = [[SUImagePickerCollectionViewController alloc]init];
        [self addChildViewController:self.imageCollectionVc];
    }
    return self;
}

- (void)setSourceType:(NSInteger)sourceType
{
    if (sourceType == SUImagePickerControllerSourceTypePhotoGroups) {
        [[self.childViewControllers lastObject] removeFromParentViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
