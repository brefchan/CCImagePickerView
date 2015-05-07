//
//  CCImagePickerViewController.h
//  CCImagePickerView
//
//  Created by bref on 15/4/30.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#define ASSETHELPER   [AssetHelper sharedAssetHelper]

#import <UIKit/UIKit.h>
#import "CCPhotoLayout.h"
#import "CCSelectView.h"

@protocol CCImagePickerViewControllerDelegate;


@interface CCImagePickerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,CCSelectViewDelegate>

@property (weak, nonatomic) id<CCImagePickerViewControllerDelegate> delegate;

@end

@protocol CCImagePickerViewControllerDelegate <NSObject>

@required
- (void)didSelectPhotoFromCCImagePickerController:(CCImagePickerViewController *)pikcer result:(NSMutableArray *)cResult;

- (void)didCancelCCImagePickerController;

@end