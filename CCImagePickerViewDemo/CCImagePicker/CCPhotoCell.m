//
//  CCPhotoCell.m
//  CCImagePickerView
//
//  Created by bref on 15/4/30.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "CCPhotoCell.h"

@implementation CCPhotoCell
    
- (void)awakeFromNib {
    // Initialization code
    [_breviaryPhoto setClipsToBounds:YES];
    _breviaryPhoto.layer.cornerRadius = 2.f;
}


- (IBAction)onClicktamp:(UIButton *)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CCPhotoCellSelectButtonClick" object:self.cellIndexPath];

}

- (void)setSelectMode:(BOOL)isSelect
{
    if (isSelect) {
        //取消选中
        self.stampBackgroundView.image = [UIImage imageNamed:@"stampBG"];
    }else
    {
        self.stampBackgroundView.image = [UIImage imageNamed:@"stampBG2"];
    }
}

@end
