//
//  PhoneBookFromViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/25/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"
#import "PhoneBookContact.h"
#import <AddressBookUI/AddressBookUI.h>

@interface PhoneBookFormViewController : FormViewController <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) PhoneBookContact *phonebookContact;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *specialty;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *fax;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UITextField *contactName;
@property (weak, nonatomic) IBOutlet UITextField *contactPhone;
@property (weak, nonatomic) IBOutlet UISwitch *quickContact;

- (void)showContactPicker;
- (void)loadFormWithPerson:(ABRecordRef)person;

@end
