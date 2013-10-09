//
//  HospitalizationFormViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Hospitalization+Methods.h"

@interface HospitalizationFormViewController : FormViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) Hospitalization *hospitalization;

@property (weak, nonatomic) IBOutlet UITextField *admitDate;
@property (weak, nonatomic) IBOutlet UITextField *dischargeDate;
@property (weak, nonatomic) IBOutlet UITextField *admitPhysician;
@property (weak, nonatomic) IBOutlet UITextField *facility;
@property (weak, nonatomic) IBOutlet UITextView *symptoms;
@property (weak, nonatomic) IBOutlet UITextView *outcome;

- (void)datePickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
