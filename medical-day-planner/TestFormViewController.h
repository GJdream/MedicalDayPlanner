//
//  TestFormViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Test+Methods.h"
#import "FGalleryViewController.h"

enum {
  ActionSheetImageSourceType,
  ActionSheetConfirmPhotoDelete
} ActionSheet;

enum {
  ImagePickerSourceTypeCamera,
  ImagePickerSourceTypePhotoLibrary,
} ImagePickerSourceType;

enum {
  PhotoDeleteConfirmDelete,
  PhotoDeleteCancelDelete
} PhotoDelete;

@interface TestFormViewController : FormViewController
<UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FGalleryViewControllerDelegate>
{
  FGalleryViewController *localGallery;
}

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) Test *test;

@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *performedDate;
@property (weak, nonatomic) IBOutlet UITextField *physician;
@property (weak, nonatomic) IBOutlet UITextField *facility;
@property (weak, nonatomic) IBOutlet UITextField *bodyRegion;
@property (weak, nonatomic) IBOutlet UITextView *results;

@property (strong, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (strong, nonatomic) NSMutableArray *galleryPhotos;
@property (strong, nonatomic) NSMutableArray *deletePhotos;

- (void)datePickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (void)confirmPhotoDelete:(id)sender;
- (void)deleteGalleryPhoto;
- (void)updatePhotosCount;
- (void)showPhotoGallery;

- (void)deletePhotoFiles:(NSArray *)filenames;

@end
