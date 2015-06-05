//
//  SUImageGroupTableViewController.m
//  SUImagePickerController
//
//  Created by liangbin on 15/6/4.
//  Copyright (c) 2015年 liangbin. All rights reserved.
//

#import "SUImagePickerGroupTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SUImagePickerGroup.h"
#import "SUImagePickerCollectionViewController.h"
#import "SUImagePIckerController.h"

static NSString * const SUTableViewCell = @"SUTableViewCell";

@interface SUImagePickerGroupTableViewController ()
@property (strong, nonatomic) NSMutableArray *groupArray;
@property (strong, nonatomic) ALAssetsLibrary *alLib;
@end

@implementation SUImagePickerGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _groupArray = [NSMutableArray array];
    
    [self initPhoneGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPhoneGroup
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
        self.alLib = [[ALAssetsLibrary alloc] init];
        
        [self.alLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                SUImagePickerGroup *suGroup = [[SUImagePickerGroup alloc]init];
                suGroup.groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                suGroup.imagesCount = [group numberOfAssets];
                UIImage *image = [UIImage imageWithCGImage:[group posterImage]];
                suGroup.groupImage = image;
                
                [_groupArray addObject:suGroup];
            } else {
                [self.tableView performSelector:@selector(reloadData) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
            }
        } failureBlock:^(NSError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return _groupArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUTableViewCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SUTableViewCell];
    }
    SUImagePickerGroup *suGroup = _groupArray[indexPath.row];
    cell.imageView.image = suGroup.groupImage;
    NSString *groupDetailStr = [NSMutableString stringWithFormat:@"%@(%ld)",suGroup.groupName, (long)suGroup.imagesCount];
    cell.textLabel.text = groupDetailStr;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SUImagePickerCollectionViewController *suImageCollectionVC = [[SUImagePickerCollectionViewController alloc] init];
    SUImagePickerGroup *suGroup = _groupArray[indexPath.row];
    SUImagePickerController *imagePickerC = (SUImagePickerController *)self.navigationController;
    imagePickerC.imageGroupName = suGroup.groupName;
    [self.navigationController pushViewController:suImageCollectionVC animated:YES];
    
}

@end
