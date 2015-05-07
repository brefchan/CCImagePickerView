//
//  CCSelectView.m
//  CCImagePickerView
//
//  Created by bref on 15/5/6.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "CCSelectView.h"
#import "AnimationUtilty.h"

@interface CCSelectView()

@property (strong, nonatomic) IBOutlet UIButton *tipView;

@end

@implementation CCSelectView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *containerView = [[[UINib nibWithNibName:@"CCSelectView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

- (void)updateTipView:(NSInteger)count
{
    CGRect newFrame = _tipView.frame;
    _tipView.frame = CGRectMake(_tipView.frame.origin.x + 4, _tipView.frame.origin.y + 4, _tipView.frame.size.width - 8, _tipView.frame.size.width - 8);
    [_tipView setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
    [AnimationUtilty SpringAnimationWithView:_tipView toRectValue:newFrame springBounciness:10];
}
- (IBAction)onSelectButtonClick:(id)sender
{
    [_delegate onCCSelectButtonClick:self];
}

- (void)setSelectButtonUsing:(BOOL)using
{
    if (using) {
        self.selectButton.enabled = YES;
        self.selectButton.alpha = 1;
    }
    else
    {
        self.selectButton.enabled = NO;
        self.selectButton.alpha = 0.5;
    }
}

@end
