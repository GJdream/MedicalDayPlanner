//
//  QuickContactsViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/6/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "SimpleContact.h"

@interface QuickContactsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Patient *patient;

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *caregivers;
@property (strong, nonatomic) NSArray *emergencyContacts;
@property (strong, nonatomic) SimpleContact *insuranceBroker;
@property (strong, nonatomic) SimpleContact *accountant;
@property (strong, nonatomic) SimpleContact *notary;
@property(strong, nonatomic) SimpleContact *attorney;

@property (strong, nonatomic) NSMutableDictionary *fieldValues;

- (IBAction)save:(id)sender;

- (void)setupHeaderTitles;
- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)loadContacts;
- (NSArray *)contactsOfType:(NSString *)type;
- (SimpleContact *)createContact:(NSString *)type;

- (NSInteger)numberOfEditableSections;
- (NSInteger)numberOfFields;

- (NSInteger)insuranceBrokerSection;
- (NSInteger)accountantSection;
- (NSInteger)notarySection;

- (NSString *)groupForSection:(NSInteger)section;
- (SimpleContact *)contactForSection:(NSInteger)section;
- (NSString *)fieldValueForIndexPath:(NSIndexPath *)indexPath
                               orKey:(NSString *)key;

- (UILabel *)labelWithText:(NSString *)text;
- (UITextField *)textFieldWithKeyboardType:(UIKeyboardType)keyboardType
                             returnKeyType:(UIReturnKeyType)returnKeyType
                             atIndexPath:(NSIndexPath *)indexPath;

- (void)reindexFieldValuesForStyle:(UITableViewCellEditingStyle)style
                       fromSection:(NSInteger)section;

@end
