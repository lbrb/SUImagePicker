//
//  SUCollectionViewCell.m
//  SUImagePickerController
//
//  Created by liangbin on 15/6/2.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import "SUImagePickerCollectionViewCell.h"

@interface SUImagePickerCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SUImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        
        CGRect rect = CGRectMake(self.bounds.size.width - 24 , 4, 20, 20);
        self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectedBtn.frame = rect;
        self.selectedBtn.layer.cornerRadius = self.selectedBtn.frame.size.width/2.0;
        self.selectedBtn.clipsToBounds = YES;

        [self.selectedBtn setImage:[UIImage imageNamed:@"assignment_checkbox_unselected"] forState:UIControlStateNormal];
        [self.selectedBtn setImage:[UIImage imageNamed:@"assignment_checkbox_selected"] forState:UIControlStateSelected];
        [self addSubview:self.selectedBtn];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)prepareForReuse
{
    self.selectedBtn.selected = NO;
}

@end
