//
//  Photo.h
//  SUImagePickerController
//
//  Created by liangbin on 15/6/2.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SUImagePickerPhoto : NSObject
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) ALAssetRepresentation *assetRepresentation;
@property (strong, nonatomic) NSURL *alAssetURL;
@end
