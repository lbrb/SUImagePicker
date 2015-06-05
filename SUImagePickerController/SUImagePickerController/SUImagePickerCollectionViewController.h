//
//  ImageCollectionViewController.h
//  SUImagePickerController
//
//  Created by liangbin on 15/6/2.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUImagePickerCollectionViewController : UIViewController
@property (assign, nonatomic) CGFloat numberInSignalLine;
@property (assign, nonatomic) BOOL multiSelect;
@property (strong, nonatomic) NSString *imageGroupName;
@end
