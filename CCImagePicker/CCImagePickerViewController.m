//
//  CCImagePickerViewController.m
//  CCImagePickerView
//
//  Created by bref on 15/4/30.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "CCImagePickerViewController.h"
#import "CCPhotoCell.h"
#import "CCImageGroupCell.h"
#import "AssetHelper.h"
#import "CCDetailImageView.h"


@interface CCImagePickerViewController ()
@property (strong, nonatomic) UICollectionView *photoListView;
@property (strong, nonatomic) UITableView *groupListView;

@property (strong, nonatomic) IBOutlet UIView *topBar;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;

@property (strong, nonatomic) IBOutlet UIButton *groupNamebutton;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;

@property (strong, nonatomic) NSMutableDictionary *dic_selected;
@property (strong, nonatomic) IBOutlet CCSelectView *selectView;

@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) IBOutlet UIButton *previewButton;


@end

@implementation CCImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.view.frame = [UIScreen mainScreen].bounds;

    //新建图片显示CollectionView
    self.photoListView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[[CCPhotoLayout alloc] init]];
    _photoListView.backgroundColor = [UIColor whiteColor];
    _photoListView.dataSource = self;
    _photoListView.delegate = self;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCollectionCellSelectButtonClick:) name:@"CCPhotoCellSelectButtonClick" object:nil];
    UINib *photoNib = [UINib nibWithNibName:@"CCPhotoCell" bundle:nil];
    [_photoListView registerNib:photoNib forCellWithReuseIdentifier:@"CCPhotoCellIndentifier"];
    [self.view addSubview:_photoListView];

    //新建照片组显示TableView
    self.groupListView = [[UITableView alloc] initWithFrame:CGRectMake(0, _bottomBar.frame.origin.y, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    _groupListView.alpha = 0.f;
    [_groupListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    _groupListView.delegate = self;
    _groupListView.dataSource = self;

    UINib *groupNib = [UINib nibWithNibName:@"CCImageGroupCell" bundle:nil];
    [_groupListView registerNib:groupNib forCellReuseIdentifier:@"CCImageGroupCellIndentifier"];
    [self.view addSubview:_groupListView];

    //创建遮罩层
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMaskView:)];
    [_maskView addGestureRecognizer:tap];
    [self.view addSubview:_maskView];

    self.dic_selected = [[NSMutableDictionary alloc] init];
    self.selectView.delegate = self;

    //读取数据
    [self readAlbumlist];
    ASSETHELPER.cReverse = YES;

    [self.view bringSubviewToFront:_topBar];
    [self.view bringSubviewToFront:_bottomBar];

}

- (void)readAlbumlist
{
    [ASSETHELPER getGroupList:^(NSArray *cGroup) {

        [_groupListView reloadData];
        [_groupListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        [_groupNamebutton setTitle:[ASSETHELPER getGroupInfo:0][@"name"] forState:UIControlStateNormal];

        [self showPhotosInGroupIndex:0];

        if (cGroup.count == 1) {
//            _groupNamebutton.enabled = NO;
        }

        _groupListView.frame = CGRectMake(_groupListView.frame.origin.x, _groupListView.frame.origin.y, _groupListView.frame.size.width, MIN(cGroup.count * 40, 160));

    }];
}

- (void)showPhotosInGroupIndex:(NSInteger)index
{
    [ASSETHELPER getPhotoListOfGroupByIndex:index result:^(NSArray *result) {
        [_photoListView reloadData];
        [_photoListView setAlpha:0.4f];

        [UIView animateWithDuration:0.4 animations:^{
            [UIView setAnimationDelay:0.1];
            _photoListView.alpha = 1.f;
        }];

        if (result.count > 0) {
            [_photoListView scrollsToTop];
        }

    }];
}


- (IBAction)onSelectGroup:(id)sender {
    if (_bottomBar.frame.origin.y == _groupListView.frame.origin.y) {

        [self.view bringSubviewToFront:_maskView];
        [self.view bringSubviewToFront:_groupListView];
        [self.view bringSubviewToFront:_bottomBar];

        [UIView animateWithDuration:0.2 animations:^{
            _maskView.alpha = 0.7;

            _groupListView.frame = CGRectMake(0, _bottomBar.frame.origin.y - _groupListView.frame.size.height, _groupListView.frame.size.width, _groupListView.frame.size.height);

            _groupListView.alpha = 1;
            _arrow.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else
    {
        [self hideGroupListView];
    }

}

- (void)hideGroupListView
{
    [UIView animateWithDuration:0.2 animations:^{
        _maskView.alpha = 0;
        _groupListView.frame = CGRectMake(0,_bottomBar.frame.origin.y, _groupListView.frame.size.width, _groupListView.frame.size.height);

        [UIView setAnimationDelay:0.1];
        _groupListView.alpha = 0.f;

        _arrow.transform = CGAffineTransformMakeRotation(0);

    }];
}


- (void)onTapMaskView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self hideGroupListView];
    }
}


#pragma mark - UICollectionViewDelegate && DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ASSETHELPER getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCPhotoCellIndentifier" forIndexPath:indexPath];
    cell.cellIndexPath = indexPath;
    cell.breviaryPhoto.image = [ASSETHELPER getImageAtIndex:indexPath.row type:AssetPhotoTypeThumbnail];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [ASSETHELPER getImageAtIndex:indexPath.row type:AssetPhotoTypeScreenSize];

    NSArray *array = @[image];
    CCDetailImageView *imageView = [CCDetailImageView defaultDetailView];
    imageView.frame = self.view.bounds;
    [imageView createDetailImages:array];
    [imageView show];

}

- (void)onCollectionCellSelectButtonClick:(NSNotification *)notif
{
    NSIndexPath *indexPath = notif.object;
    CCPhotoCell *cell = (CCPhotoCell *)[_photoListView cellForItemAtIndexPath:indexPath];
    if ((_dic_selected[@(indexPath.row)] == nil) && _dic_selected.count < 9) {
        //选中
        _dic_selected[@(indexPath.row)] = @(_dic_selected.count);
        [cell setSelectMode:YES];
    }else
    {
        [_dic_selected removeObjectForKey:@(indexPath.row)];
        [cell setSelectMode:NO];
    }

    if (_dic_selected.count > 0)
    {
        [self setPreviewButtonUsing:YES];
        [self.selectView setSelectButtonUsing:YES];
    }
    else
    {
        [self setPreviewButtonUsing:NO];
        [self.selectView setSelectButtonUsing:NO];
    }

    [self.selectView updateTipView:_dic_selected.count];
}



#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ASSETHELPER getGroupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCImageGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCImageGroupCellIndentifier"];

    NSDictionary *dict = [ASSETHELPER getGroupInfo:indexPath.row];
    cell.albumNameLabel.text = dict[@"name"];
    cell.albumCountLabel.text = [NSString stringWithFormat:@"(%@)",dict[@"count"]];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPhotosInGroupIndex:indexPath.row];
    [_groupNamebutton setTitle:[ASSETHELPER getGroupInfo:indexPath.row][@"name"] forState:UIControlStateNormal];
    [self hideGroupListView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



#pragma mark - Preview
- (void)setPreviewButtonUsing:(BOOL)using
{
    if (using) {
        self.previewImage.alpha = 1;
        self.previewButton.alpha = 1;
        self.previewButton.enabled = YES;
    }
    else
    {
        self.previewImage.alpha = 0.5;
        self.previewButton.alpha = 0.5;
        self.previewButton.enabled = NO;
    }
}

- (IBAction)onPreviewButtonClick:(id)sender {

    NSMutableArray *cResult = [[NSMutableArray alloc] initWithCapacity:_dic_selected.count];
    NSArray *cKey = [_dic_selected keysSortedByValueUsingSelector:@selector(compare:)];

    for (int i = 0; i < _dic_selected.count; i ++) {
        [cResult addObject:[ASSETHELPER getImageAtIndex:[cKey[i] intValue] type:AssetPhotoTypeScreenSize]];
    }

    CCDetailImageView *imageView = [CCDetailImageView defaultDetailView];
    imageView.frame = self.view.bounds;
    [imageView createDetailImages:cResult];
    [imageView show];
}



#pragma mark - cancel && select delegate

- (IBAction)onCancel:(id)sender {
    [_delegate didCancelCCImagePickerController];
}

- (void)onCCSelectButtonClick:(CCSelectView *)selectView
{
    NSMutableArray *cResult = [[NSMutableArray alloc] initWithCapacity:_dic_selected.count];
    NSArray *cKey = [_dic_selected keysSortedByValueUsingSelector:@selector(compare:)];

    for (int i = 0; i < _dic_selected.count; i ++) {
        [cResult addObject:[ASSETHELPER getImageAtIndex:[cKey[i] intValue] type:AssetPhotoTypeScreenSize]];
    }

    [_delegate didSelectPhotoFromCCImagePickerController:self result:cResult];
}



#pragma mark - StatusBar Setting

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end
