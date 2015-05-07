//
//  AssetHelper.m
//  CCImagePickerView
//
//  Created by bref on 15/4/29.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "AssetHelper.h"

@interface AssetHelper()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray  *assetPhotos;
@property (nonatomic, strong) NSMutableArray  *assetGroups;

@end

@implementation AssetHelper

+ (AssetHelper *)sharedAssetHelper
{
    static AssetHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AssetHelper alloc] init];
        [_sharedInstance initAsset];
    });

    return _sharedInstance;
}

- (void)initAsset
{
    //初始化资源库对象
    if(self.assetsLibrary == nil)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }

}

- (void)getGroupList:(void (^)(NSArray *))result
{
    [self initAsset];

    _assetGroups = [[NSMutableArray alloc] init];

    //设置资源组枚举代码块
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        //将资源组中的照片过滤出来
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        if (group == nil) {
            //因为取出来的数据是反着装进数组的,所以应该再反过来
            if (_cReverse) {
                _assetGroups = [[NSMutableArray alloc] initWithArray:[[_assetGroups reverseObjectEnumerator] allObjects]];
            }
            result(_assetGroups);
            return ;
        }

        [_assetGroups addObject:group];
    };

    //设置资源组枚举失败代码块
    void(^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error)
    {
        NSLog(@"Error: %@",[error description]);
    };

    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];

}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)ccGroup result:(void (^)(NSArray *))result
{
    [self initAsset];

    _assetPhotos = [[NSMutableArray alloc] init];

    [ccGroup setAssetsFilter:[ALAssetsFilter allPhotos]];

    [ccGroup enumerateAssetsUsingBlock:^(ALAsset *ccPhoto, NSUInteger index, BOOL *stop)
    {
        if (ccPhoto == nil)
        {
            //遍历完成
            if (_cReverse) {
                _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
            }

            result(_assetPhotos);

            return ;
        }
        [_assetPhotos addObject:ccPhoto];
    }];
}

- (void)getPhotoListOfGroupByIndex:(NSInteger)ccGroupIndex result:(void (^)(NSArray *))result
{
    //将指定的资源组中的图片取出来
    [self getPhotoListOfGroup:_assetGroups[ccGroupIndex] result:^(NSArray *ccResult) {
        result(_assetPhotos);
    }];
}

- (void)getSavedPhotoList:(void (^) (NSArray *))result error:(void (^) (NSError *))error
{
    [self initAsset];
    _assetPhotos = [[NSMutableArray alloc] init];

    dispatch_async(dispatch_get_main_queue(), ^{

        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
                //如果group的类型手机里保存的
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];

                [group enumerateAssetsUsingBlock:^(ALAsset *ccPhoto, NSUInteger index, BOOL *stop) {
                    if (ccPhoto == nil) {
                        if (_cReverse) {
                            _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
                        }

                        result(_assetPhotos);
                        return ;
                    }

                    [_assetPhotos addObject:ccPhoto];
                }];
            }
        };

        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err)
        {
            NSLog(@"Error : %@", [err description]);
        };

        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    });
}

- (NSInteger)getGroupCount
{
    return _assetGroups.count;
}

- (NSInteger)getPhotoCountOfCurrentGroup
{
    return _assetPhotos.count;
}

- (NSDictionary *)getGroupInfo:(NSInteger)cIndex
{
    return @{@"name"      : [_assetGroups[cIndex] valueForProperty:ALAssetsGroupPropertyName],
             @"count"     : @([_assetGroups[cIndex] numberOfAssets]),
             @"thumbrail" : [UIImage imageWithCGImage:[(ALAssetsGroup *)_assetGroups[cIndex] posterImage]]
             };
}

- (void)clearData
{
    _assetGroups = nil;
    _assetPhotos = nil;
}

- (UIImage *)getCroppedImage:(NSURL *)urlImage
{
    //从URL反取图片
    __block UIImage *cImage = nil;
    __block BOOL cBusy = YES;

    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        NSString *strXMP = rep.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            //原图未做修改
            CGImageRef ref = [rep fullResolutionImage];
            if(ref)
                cImage = [UIImage imageWithCGImage:ref scale:1.0 orientation:(UIImageOrientation)rep.orientation];
            else
                cImage = nil;
        }else
        {
            //照片已被修改
            NSData *cXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];

            CIImage *image = [CIImage imageWithCGImage:rep.fullResolutionImage];
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:cXMP inputImageExtent:image.extent error:&error];

            if (error) {
                NSLog(@"在过滤图片大小时发生: %@",[error localizedDescription]);
            }

            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }

            cImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)rep.orientation];
        }
        cBusy = NO;
    };

    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myError)
    {
        NSLog(@"哎呀.取不到图片 - %@",[myError localizedDescription]);
    };

    [_assetsLibrary assetForURL:urlImage resultBlock:resultblock failureBlock:failureblock];

    while (cBusy)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    return cImage;
}


- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(AssetPhotoType)cType
{
    CGImageRef cRef = nil;
    if (cType == AssetPhotoTypeThumbnail)
    {
        //缩略图
        cRef = [asset thumbnail];
    }else if(cType == AssetPhotoTypeScreenSize)
    {
        //全屏图
        cRef = [asset.defaultRepresentation fullScreenImage];
    }else if(cType == AssetPhotoTypeFullResolution)
    {
        //原图
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        NSData *cXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];

        CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        NSError *error = nil;
        NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:cXMP inputImageExtent:image.extent error:&error];

        if (error)
            NSLog(@"过滤图片时出错: %@",[error localizedDescription]);

        for (CIFilter *filter in filterArray) {
            [filter setValue:image forKey:kCIInputImageKey];
            image = [filter outputImage];
        }

        UIImage *cImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        return cImage;
    }
    return [UIImage imageWithCGImage:cRef];
}

- (UIImage *)getImageAtIndex:(NSInteger)cIndex type:(AssetPhotoType)cType
{
    return [self getImageFromAsset:(ALAsset *)_assetPhotos[cIndex] type:cType];
}

- (ALAsset *)getAssetAtIndex:(NSInteger)cIndex
{
    return _assetPhotos[cIndex];
}


@end
