//
//  AssetHelper.h
//  CCImagePickerView
//
//  Created by bref on 15/4/29.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, AssetPhotoType)
{
    AssetPhotoTypeThumbnail = 0,
    AssetPhotoTypeScreenSize,
    AssetPhotoTypeFullResolution
};

@interface AssetHelper : NSObject

@property (readwrite) BOOL cReverse;

+ (AssetHelper *)sharedAssetHelper;

- (void)getGroupList:(void (^)(NSArray *))result;
- (void)getPhotoListOfGroup:(ALAssetsGroup *)ccGroup result:(void (^)(NSArray *))result;
- (void)getPhotoListOfGroupByIndex:(NSInteger)ccGroupIndex result:(void (^)(NSArray *))result;
- (void)getSavedPhotoList:(void (^) (NSArray *))result error:(void (^) (NSError *))error;

- (NSInteger)getGroupCount;
- (NSInteger)getPhotoCountOfCurrentGroup;
- (NSDictionary *)getGroupInfo:(NSInteger)cIndex;

- (void)clearData;

- (UIImage *)getCroppedImage:(NSURL *)urlImage;
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(AssetPhotoType)cType;
- (UIImage *)getImageAtIndex:(NSInteger)cIndex type:(AssetPhotoType)cType;
- (ALAsset *)getAssetAtIndex:(NSInteger)cIndex;

@end
