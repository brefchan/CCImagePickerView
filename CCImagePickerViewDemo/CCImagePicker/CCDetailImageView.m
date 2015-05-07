//
//  CCDetailImageView.m
//  CCImagePickerView
//
//  Created by bref on 15/5/6.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "CCDetailImageView.h"

@implementation CCDetailImageView

+ (id)defaultDetailView
{
    CCDetailImageView *detailView = [[[UINib nibWithNibName:@"CCDetailImageView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    return detailView;

}

- (void)createDetailImages:(NSArray *)array
{
    for (UIImage *image in array) {
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        CGFloat height = CGRectGetHeight(self.scrollView.frame);

        CGFloat x = self.scrollView.subviews.count * width;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;

        imageView.layer.cornerRadius = 6.f;

        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = CGSizeMake(x + width, height);
    }
}

- (void)show
{
    self.scrollView.effect = JT3DScrollViewEffectCards;
    self.closeButton.layer.cornerRadius = 2.f;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    self.alpha = 0;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (IBAction)close:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
