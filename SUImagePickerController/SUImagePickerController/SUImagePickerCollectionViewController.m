//
//  ImageCollectionViewController.m
//  SUImagePickerController
//
//  Created by liangbin on 15/6/2.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import "SUImagePickerCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SUImagePickerPhoto.h"
#import "SUImagePickerCollectionViewCell.h"
#import "SUImagePickerController.h"
#import "SUImagePickerPreviewImagesViewController.h"
#import "SDImageCache.h"

//sdCacheImage名称空间
static NSString * const SUImagePickerSDNamespace = @"SUImagePickerSDNamespace";

static NSString * const reuseIdentifier = @"SUCollectionViewCell";

@interface SUImagePickerCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_selfPhones;
    NSMutableArray *_otherPhones;
    SDImageCache *_imageCache;
    BOOL _a;
}
@property (strong, nonatomic) ALAssetsLibrary *alLib;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *phoneArray; //经过去重排序后的图片
@property (strong, nonatomic) NSMutableArray *selectedPhones; //已选择的图片
@property (strong, nonatomic) NSIndexPath *lastIndexPath; //单选中使用，用来删除前面选择的图片

@end

@implementation SUImagePickerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载图片
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadPhones) object:nil];
    thread.name = @"loadView";
    [thread start];
    
    _phoneArray = [NSMutableArray array];
    _selectedPhones = [NSMutableArray array];
    
    _imageCache = [[SDImageCache alloc] initWithNamespace:SUImagePickerSDNamespace];
    
    //加载collectionView
    [self setupCollectionView];
    //加载按钮
    [self setupButtons];
    //加载导航条
    [self initNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    SUImagePickerController *imagePickerC = (SUImagePickerController *)self.navigationController;
    //设置一行显示几张图片
    CGFloat numberInSingalLine = imagePickerC.numberInSignalLine;
    CGFloat length = (self.view.frame.size.width - 10*(numberInSingalLine-1))/numberInSingalLine;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(length, length);
    //设置多选还是单选
    _multiSelect = imagePickerC.multiSelect;
    //设置title
    self.title = imagePickerC.imageGroupName;
    //设置组
    self.imageGroupName = imagePickerC.imageGroupName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

//初始化navigationbar
- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancel)];
}

//加载collectionView
- (void)setupCollectionView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    // Register cell classes
    [self.collectionView registerClass:[SUImagePickerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

//加载按钮
- (void)setupButtons
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    self.bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 45, 32)];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftBtn setTitle:@"预览" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [leftBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width - 55, 6, 45, 32)];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:rightBtn];
}

/**
 *  加载手机中的图片
 */
- (void)loadPhones {

    _selfPhones = [NSMutableArray array];
    _otherPhones = [NSMutableArray array];

    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
        self.alLib = [[ALAssetsLibrary alloc] init];
        
        [self.alLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                if (self.imageGroupName && ![[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:self.imageGroupName]) {
                    return;
                }
                ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
                
                [group setAssetsFilter:filter];
                
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        SUImagePickerPhoto *p = [[SUImagePickerPhoto alloc] init];
                        p.createdDate = [result valueForProperty:ALAssetPropertyDate];
                        p.alAssetURL = [result valueForProperty:ALAssetPropertyAssetURL];
                        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:self.imageGroupName]) {
                            [_selfPhones addObject:p];
                        } else {
                            [_otherPhones addObject:p];
                        }
                    } else {
                    }
                }];
            } else {
                [self performSelector:@selector(generatePhones) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
            }
        } failureBlock:^(NSError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

/**
 *  将图片排序去重
 */
- (void)generatePhones {

    NSSortDescriptor *selfSorter = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    
    //本项目图片
    if (_selfPhones.count > 0) {
        self.phoneArray  = [NSMutableArray arrayWithArray:[_selfPhones sortedArrayUsingDescriptors:@[selfSorter]]];
    }
    
    //过滤数据
    NSMutableIndexSet *idxSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i<[self.phoneArray count]; i++) {
        SUImagePickerPhoto *currentModel = self.phoneArray[i];
        NSString *currentURLStr = [[NSString alloc]initWithFormat:@"%@",currentModel.alAssetURL];
        [_otherPhones enumerateObjectsUsingBlock:^(SUImagePickerPhoto *obj, NSUInteger idx, BOOL *stop) {
            NSString *tempURLStr = [[NSString alloc]initWithFormat:@"%@",obj.alAssetURL];
            if ([currentURLStr isEqualToString:tempURLStr]) {
                [idxSet addIndex:idx];
                *stop = YES;
            }
        }];
    }
    //其他图片
    if ([idxSet count] > 0) {
        [_otherPhones removeObjectsAtIndexes:idxSet];
    }
    
    [self.phoneArray addObjectsFromArray:[_otherPhones sortedArrayUsingDescriptors:@[selfSorter]]];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.phoneArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SUImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SUImagePickerPhoto *p = (SUImagePickerPhoto *)[self.phoneArray objectAtIndex:indexPath.row];
    NSString *imageKey = [p.alAssetURL absoluteString];
    UIImage *image = [_imageCache imageFromDiskCacheForKey:imageKey];
    if (image) {
        cell.image = image;
    } else {
        [self.alLib assetForURL:p.alAssetURL resultBlock:^(ALAsset *asset) {
           UIImage *imageTmp = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
            [_imageCache storeImage:imageTmp forKey:imageKey];
            cell.image = imageTmp;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } failureBlock:^(NSError *error) {
           //todo defaultImage
        }];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //取消上一个图片
    if (!self.multiSelect && ![self.lastIndexPath isEqual:indexPath]) {
        if (self.lastIndexPath) {
            SUImagePickerCollectionViewCell *lastCell = (SUImagePickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastIndexPath];
            if (lastCell) {
                lastCell.selectedBtn.selected = FALSE;
            }
            SUImagePickerPhoto *p = [self.phoneArray objectAtIndex:self.lastIndexPath.row];
            if (p) {
                [self.selectedPhones removeObject:p];
            }
        }
        self.lastIndexPath = indexPath;
    }
    
    //添加当前图片
    SUImagePickerCollectionViewCell *cell = (SUImagePickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedBtn.selected = !(cell.selectedBtn.selected);
    SUImagePickerPhoto *p = [self.phoneArray objectAtIndex:indexPath.row];
    
    
    if ([self.selectedPhones containsObject:p]) {
        [self.selectedPhones removeObject:p];
    } else {
        [self.selectedPhones addObject:p];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

#pragma mark - button event

- (void)confirm
{
    if (self.navigationController.delegate && [self.navigationController.delegate respondsToSelector:@selector(SUImagePickerController:didFinishPickingImage:)]) {
        [self.navigationController.delegate performSelector:@selector(SUImagePickerController:didFinishPickingImage:) withObject:[self didPickImages]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)preview
{
    SUImagePickerPreviewImagesViewController *previewImagesVC = [[SUImagePickerPreviewImagesViewController alloc] init];
    previewImagesVC.images = [self didPickImages];
    if (previewImagesVC.images.count > 0) {
        [self.navigationController pushViewController:previewImagesVC animated:YES];
    }
}

#pragma mark phones to images

- (NSArray *)didPickImages
{
    NSMutableArray *imagesArray = [NSMutableArray array];
    
    for (SUImagePickerPhoto *p in self.selectedPhones) {
        NSString *imageKey = [p.alAssetURL absoluteString];
        UIImage *image = [_imageCache imageFromDiskCacheForKey:imageKey];
        [imagesArray addObject:image];
    }
    return imagesArray;
}
@end
