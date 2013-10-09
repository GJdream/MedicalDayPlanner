//
//  PatientFormViewController.h
//  The Medical Day Planner
//
//  Created by Ronnie L Miller on 6/3/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Patient+Methods.h"

@interface PatientFormViewController : FormViewController
  <UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phoneHome;
@property (weak, nonatomic) IBOutlet UITextField *phoneWork;
@property (weak, nonatomic) IBOutlet UITextField *phoneCell;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *address;

@property (weak, nonatomic) IBOutlet UITextField *dobDate;
@property (weak, nonatomic) IBOutlet UITextField *bloodType;
@property (weak, nonatomic) IBOutlet UITextView *knownAllergies;
@property (weak, nonatomic) IBOutlet UITextView *dietaryRestrictions;
@property (weak, nonatomic) IBOutlet UITextView *diagnosis;
@property (weak, nonatomic) NSString *notes;

@property (strong, nonatomic) UIPickerView *bloodPicker;

@property (weak, nonatomic) IBOutlet UITableViewCell *homePhoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *workPhoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPhoneCell;

- (void)datePickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
