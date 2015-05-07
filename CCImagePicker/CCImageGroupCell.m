//
//  CCImageGroupCell.m
//  CCImagePickerView
//
//  Created by bref on 15/5/1.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "CCImageGroupCell.h"
#import "CCImagePickerViewController.h"

@implementation CCImageGroupCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected)
    {
        //选中状态:
        self.contentView.backgroundColor = [UIColor colorWithRed:64/255.f green:191/255.f blue:238/255.f alpha:1];
        [self.albumCountLabel setTextColor:[UIColor whiteColor]];
        [self.albumNameLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.albumCountLabel setTextColor:[UIColor darkGrayColor]];
        [self.albumNameLabel setTextColor:[UIColor blackColor]];
    }

}



@end
