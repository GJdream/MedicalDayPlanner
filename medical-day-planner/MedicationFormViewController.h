//
//  MedicationFormViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Medication+Methods.h"
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

@interface MedicationFormViewController : FormViewController
  <UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FGalleryViewControllerDelegate>
{
  FGalleryViewController *localGallery;
    NSDateFormatter *timeFormatter;
   
}
//testing
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) MedicationFormViewController *medicationFormView;
@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) Medication *medication;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (assign, nonatomic) IBOutlet UITextField *startDate;
@property (assign, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *dosage;
@property (weak, nonatomic) IBOutlet UITextField *frequency;
@property (weak, nonatomic) IBOutlet UITextView *purpose;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITextView *sideEffects;
@property (weak, nonatomic) IBOutlet UITextField *prescriptionPhysician;
@property (weak, nonatomic) IBOutlet UITextField *prescriptionNumber;
@property (weak, nonatomic) IBOutlet UITextField *pharmacy;
@property (weak, nonatomic) IBOutlet UITableViewCell *generic;

@property (strong, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (strong, nonatomic) NSMutableArray *galleryPhotos;
@property (strong, nonatomic) NSMutableArray *deletePhotos;
@property (strong, nonatomic) NSDate *actualAlarmDate;
@property (weak, nonatomic) IBOutlet UITextField *alarmTime;
@property (weak, nonatomic) IBOutlet UISwitch *alarmStatus;


@property (weak, nonatomic) IBOutlet UITableViewCell *dc;
- (void)datePickerValueChanged:(id)sender;
- (void)timePickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (void)confirmPhotoDelete:(id)sender;
- (void)deleteGalleryPhoto;
- (void)updatePhotosCount;
- (void)showPhotoGallery;

- (void)deletePhotoFiles:(NSArray *)filenames;

-(void) scheduleAlarm;
@end
