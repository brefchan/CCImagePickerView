# CCImagePickerView
  if you like it, plz give a star.
  如果对您有用,请给颗星~谢谢

###description
  Query the photo album better

###use Cocoapods
```
pod 'CCImagePickerView', '~>1.0.0'
```

###then
```Objective-C
  import <CCImagePickerView/CCImagePickerViewController.h>
```
###in <YOUR>ViewController
```Objective-C
    CCImagePickerViewController *con = [[CCImagePickerViewController alloc] init];
    con.delegate = self;
    [self presentViewController:con animated:YES completion:nil];
  
#pragma mark - delegate
    - (void)didCancelCCImagePickerController
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        /*
        your code
        */
    }

    - (void)didSelectPhotoFromCCImagePickerController:(CCImagePickerViewController *)pikcer result:(NSMutableArray *)cResult
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        /*
        your code
        */
    }
```
