//
//  ViewController.m
//  CCImagePickerViewDemo
//
//  Created by bref on 15/5/7.
//  Copyright (c) 2015年 bref. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClick:(id)sender {
    CCImagePickerViewController *con = [[CCImagePickerViewController alloc] init];
    con.delegate = self;
    [self presentViewController:con animated:YES completion:nil];
}

- (void)didCancelCCImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotoFromCCImagePickerController:(CCImagePickerViewController *)pikcer result:(NSMutableArray *)cResult
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
