//
//  CCSelectView.h
//  CCImagePickerView
//
//  Created by bref on 15/5/6.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCSelectViewDelegate;


@interface CCSelectView : UIView

@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) id<CCSelectViewDelegate> delegate;

- (void)updateTipView:(NSInteger)count;
- (void)setSelectButtonUsing:(BOOL)using;

@end


@protocol CCSelectViewDelegate <NSObject>

- (void)onCCSelectButtonClick:(CCSelectView *)selectView;

@end