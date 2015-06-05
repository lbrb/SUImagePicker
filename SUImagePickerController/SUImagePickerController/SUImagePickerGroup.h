//
//  SUImagePickerGroup.h
//  SUImagePickerController
//
//  Created by liangbin on 15/6/5.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUImagePickerGroup : NSObject
@property (strong, nonatomic) NSString *groupName;
@property (assign, nonatomic) NSInteger imagesCount;
@property (strong, nonatomic) UIImage *groupImage;
@end
