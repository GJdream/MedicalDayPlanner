//
//  ProcedureFormViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Procedure+Methods.h"

@interface ProcedureFormViewController : FormViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) Procedure *procedure;

@property (weak, nonatomic) IBOutlet UITextField *procedureText;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *physician;
@property (weak, nonatomic) IBOutlet UITextField *facility;
@property (weak, nonatomic) IBOutlet UITextView *results;
@property (weak, nonatomic) IBOutlet UITextView *complications;
@property (weak, nonatomic) IBOutlet UITextView *suggestions;

- (void)datePickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
