//
//  TreatmentFormViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Treatment+Methods.h"

@interface TreatmentFormViewController : FormViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) Treatment *treatment;

@property (weak, nonatomic) IBOutlet UITextField *treatmentText;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *physician;
@property (weak, nonatomic) IBOutlet UITextField *facility;
@property (weak, nonatomic) IBOutlet UITextView *sideEffects;

- (void)datePickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
