//
//  CCPhotoCell.h
//  CCImagePickerView
//
//  Created by bref on 15/4/30.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPhotoCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *breviaryPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *stampBackgroundView;

@property (strong, nonatomic) NSIndexPath *cellIndexPath;


- (void)setSelectMode:(BOOL)isSelect;

@end
