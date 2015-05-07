//
//  AnimationUtilty.h
//  CCImagePickerView
//
//  Created by bref on 15/5/6.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/POP.h>

@interface AnimationUtilty : NSObject

+ (void)SpringAnimationWithView:(UIView *)view toRectValue:(CGRect)value springBounciness:(CGFloat)springValue;

@end
