//
//  AppointmentFormViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/11/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "Appointment+Methods.h"

@interface AppointmentFormViewController : FormViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) Appointment *appointment;

@property (weak, nonatomic) IBOutlet UITextField *physician;
@property (weak, nonatomic) IBOutlet UITextField *dateTime;
@property (weak, nonatomic) IBOutlet UITextField *caregiver;
@property (weak, nonatomic) IBOutlet UITextView *purpose;
@property (weak, nonatomic) IBOutlet UITextView *results;
@property (weak, nonatomic) IBOutlet UITextField *nextDateTime;

- (void)datePickerValueChanged:(id)sender;
- (void)contactPickerValueChanged:(id)sender;

@end
