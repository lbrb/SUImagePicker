//
//  SUImagePIckerController.h
//  SUImagePickerController
//
//  Created by liangbin on 15/6/2.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SUImagePickerControllerSourceType) {
    SUImagePickerControllerSourceTypePhotos,
    SUImagePickerControllerSourceTypePhotoGroups
};

@interface SUImagePickerController : UINavigationController
@property (assign, nonatomic) CGFloat numberInSignalLine; //一行显示几张图片， 默认4张
@property (assign, nonatomic) BOOL multiSelect;//多选还是单选，默认单选
@property (strong, nonatomic) NSString *imageGroupName;//相册详情中展示该组的图片，如果为空则展示所有图片
@property (assign, nonatomic) NSInteger sourceType; //展示的类别，是相册目录，还是相册详情
@end

@protocol SUImagePickerControllerDelegate <NSObject>
@optional
- (void)SUImagePickerController:(SUImagePickerController *)picker didFinishPickingImage:(NSArray *)images;
@end
