//
//  AnimationUtilty.m
//  CCImagePickerView
//
//  Created by bref on 15/5/6.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "AnimationUtilty.h"

@implementation AnimationUtilty

+ (void)SpringAnimationWithView:(UIView *)view toRectValue:(CGRect)value springBounciness:(CGFloat)springValue
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.springBounciness = springValue;
    basicAnimation.springSpeed = 11;
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    basicAnimation.toValue = [NSValue valueWithCGRect:value];
    basicAnimation.name = @"AnyAnimationNameYouWant";
    basicAnimation.delegate = self;
    [view pop_addAnimation:basicAnimation forKey:@"AnimationForLeadView"];
}

@end
