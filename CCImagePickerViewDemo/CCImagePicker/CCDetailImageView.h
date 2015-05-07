//
//  CCDetailImageView.h
//  CCImagePickerView
//
//  Created by bref on 15/5/6.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT3DScrollView.h"

@interface CCDetailImageView : UIView

@property (strong, nonatomic) IBOutlet JT3DScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

+ (id)defaultDetailView;

- (void)createDetailImages:(NSArray *)array;
- (void)show;

@end
