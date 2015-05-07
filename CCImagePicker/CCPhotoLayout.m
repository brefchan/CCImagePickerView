//
//  CCPhotoLayout.m
//  CCImagePickerView
//
//  Created by bref on 15/4/30.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "CCPhotoLayout.h"

@implementation CCPhotoLayout

- (instancetype)init
{
    self = [super init];
    if (self) {

        float screenWidth = [UIScreen mainScreen].bounds.size.width;
        float size = (screenWidth - 25) / 4;

        self.itemSize = CGSizeMake(size, size);
        self.sectionInset = UIEdgeInsetsMake(45, 5, 45, 5);

        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
    }
    return self;
}

@end
