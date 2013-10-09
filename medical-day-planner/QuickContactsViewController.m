 //
//  QuickContactsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/6/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "QuickContactsViewController.h"

@interface QuickContactsViewController ()
{
  BOOL keyboardVisible;
  UITextField *activeTextField;
  NSMutableArray *headerTitles;
  NSArray *phoneTitles;
}
@end

@implementation QuickContactsViewController

@synthesize managedObjectContext;
@synthesize patient;

@synthesize contacts;
@synthesize caregivers;
@synthesize emergencyContacts;
@synthesize insuranceBroker;
@synthesize accountant;
@synthesize notary;
@synthesize attorney;
@synthesize fieldValues;

#pragma mark -
#pragma mark - Target Actions

- (IBAction)save:(id)sender
{
  // Delete unpopulated contacts in caregivers and emergency contacts
  // Make sure there is always at least one of each type of contact
  SimpleContact *contact;

  int i = self.caregivers.count;
  for (contact in self.caregivers) {
    if(i > 1 &&
       contact.name.length      == 0 &&
       contact.phoneHome.length == 0 &&
       contact.phoneWork.length == 0 &&
       contact.phoneCell.length == 0
    ) {
      [self.managedObjectContext deleteObject:contact];
      i--;
    }
  }
  
  i = self.emergencyContacts.count;
  for (contact in self.emergencyContacts) {
    if(i > 1 &&
       contact.name.length      == 0 &&
       contact.phoneHome.length == 0 &&
       contact.phoneWork.length == 0 &&
       contact.phoneCell.length == 0
    ) {
      [self.managedObjectContext deleteObject:contact];
      i--;
    }
  }
  
  NSError *error;
  [self.managedObjectContext save:&error];

  if (sender != nil) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // If the we're on the first row in a multi-object section
  if (self.tableView.editing && indexPath.row == 0 && indexPath.section < [self numberOfEditableSections]) {
    
    // If we're on the first section/grouping of the multi-object section
    if (
        (indexPath.section == 0) ||
        (indexPath.section > 0 && indexPath.section == [self.caregivers count]) ||
        (indexPath.section > [self.caregivers count] && indexPath.section == [self.caregivers count] + [self.emergencyContacts count])
       )
    {
      return UITableViewCellEditingStyleInsert;
    }

    return UITableViewCellEditingStyleDelete;
  }

  return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  return indexPath.section < [self numberOfEditableSections];
}

#pragma mark -
#pragma mark - Table view section helpers

- (NSInteger)numberOfEditableSections
{
  return [self.caregivers count] + [self.emergencyContacts count];
}

- (NSInteger)numberOfFields
{
  return ((([self numberOfEditableSections] - 1) * 4) + 8);
}

- (NSInteger)insuranceBrokerSection
{
  return [self numberOfEditableSections];
}

- (NSInteger)accountantSection
{
  return [self numberOfEditableSections] + 1;
}

- (NSInteger)notarySection
{
  return [self numberOfEditableSections] + 2;  
}
-(NSInteger)attorneySection
{
    return [self numberOfEditableSections]+3;
}

- (NSString *)groupForSection:(NSInteger)section
{
  if (
    section >= 0 &&
    section <  [self.caregivers count]
  )
  {
    return @"caregivers";
  }

  else if (
    section >= [self.caregivers count] &&
    section <  [self.caregivers count] + [self.emergencyContacts count]
  ) {
    return @"emergencyContacts";
  }

  return @"";
}

- (SimpleContact *)contactForSection:(NSInteger)section
{
  SimpleContact *contact;
  NSString *sectionName = [self groupForSection:section];
  NSInteger objectIndex = section;

  if ([sectionName isEqualToString:@"caregivers"]) {
    contact = [self.caregivers objectAtIndex:objectIndex];
  }
  
  else if ([sectionName isEqualToString:@"emergencyContacts"]) {
    objectIndex -= [self.caregivers count];
    contact = [self.emergencyContacts objectAtIndex:objectIndex];
  }

  else if (section == [self insuranceBrokerSection]) {
    contact = self.insuranceBroker;
  }

  else if (section == [self accountantSection]) {
    contact = self.accountant;
  }

  else if (section == [self notarySection]) {
    contact = self.notary;
  }
    else if(section==[self attorneySection])
    {
        contact=self.attorney;
    }
  return contact;
}

- (NSString *)fieldValueForIndexPath:(NSIndexPath *)indexPath
                        orKey:(NSString *)key
{
  NSString *value = nil;

  // If the value exists in fieldValues it means the user has edited that field, so pull from the dictionary
  value = [self.fieldValues valueForKey:[self keyForIndexPath:indexPath]];

  if (value == nil) {
    value = [[self contactForSection:indexPath.section] valueForKey:key];
  }

  return value;
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return [self numberOfEditableSections] + 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section <= [self insuranceBrokerSection]) {
    return 4;
  }
    if(section==[self attorneySection])
    {
        return 3;
    }

  else {
    return 2;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  UITextField *nameField;  UILabel *nameLabel;
  UITextField *phoneField; UILabel *phoneLabel;
  // NSString *value;

  // Caregivers, emergency contacts
  if (indexPath.section < [self insuranceBrokerSection]) {
    // First row is for name fields
    if (indexPath.row == 0) {
      nameLabel = [self labelWithText:@"Name"];
      nameLabel.frame = CGRectMake(45, 12, 97, 21);

      nameField = [self textFieldWithKeyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext atIndexPath:indexPath];
      nameField.frame = CGRectMake(156, 7, 147, 31);
      nameField.text = [self fieldValueForIndexPath:indexPath orKey:@"name"];
      
      [cell addSubview:nameLabel];
      [cell addSubview:nameField];
    }
    
    // Phone rows
    if (indexPath.row > 0) {
      phoneLabel = [self labelWithText:[phoneTitles objectAtIndex:indexPath.row-1]];
      phoneLabel.frame = CGRectMake(45, 11, 97, 21);
      
      phoneField = [self textFieldWithKeyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDone atIndexPath:indexPath];
      phoneField.frame = CGRectMake(156, 7, 147, 31);

      if (indexPath.row == 1) phoneField.text = [self fieldValueForIndexPath:indexPath orKey:@"phoneHome"];
      if (indexPath.row == 2) phoneField.text = [self fieldValueForIndexPath:indexPath orKey:@"phoneWork"];
      if (indexPath.row == 3) phoneField.text = [self fieldValueForIndexPath:indexPath orKey:@"phoneCell"];
      
      [cell addSubview:phoneLabel];
      [cell addSubview:phoneField];
    }
  }  
  
  // Insurance broker, Accountant and Notary information
  if (indexPath.section >= [self insuranceBrokerSection]) {    
    // First row is for name fields
    if (indexPath.row == 0) {
      nameLabel = [self labelWithText:@"Name"];
      nameField = [self textFieldWithKeyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext atIndexPath:indexPath];
      nameField.text = [self fieldValueForIndexPath:indexPath orKey:@"name"];

      [cell addSubview:nameLabel];
      [cell addSubview:nameField];
    }
    
    // Second row is for phone fields
    if (indexPath.row == 1) {
      phoneLabel = [self labelWithText:@"Phone"];
      phoneField = [self textFieldWithKeyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDone atIndexPath:indexPath];
      phoneField.text = [self fieldValueForIndexPath:indexPath orKey:@"phoneWork"];

      [cell addSubview:phoneLabel];
      [cell addSubview:phoneField];
    }
    
    // Third row for company name (insurance broker only)
    if (indexPath.section == [self insuranceBrokerSection] && indexPath.row == 2) {
      UILabel *companyLabel = [self labelWithText:@"Company"];
      UITextField *companyField = [self textFieldWithKeyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext atIndexPath:indexPath];
      companyField.text = [self fieldValueForIndexPath:indexPath orKey:@"company"];
      
      [cell addSubview:companyLabel];
      [cell addSubview:companyField];
    }
    
    // Third row for policy number (insurance broker only)
    if (indexPath.section == [self insuranceBrokerSection] && indexPath.row == 3) {
      UILabel *policyLabel = [self labelWithText:@"Policy #"];
      UITextField *policyField = [self textFieldWithKeyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext atIndexPath:indexPath];
      policyField.text = [self fieldValueForIndexPath:indexPath orKey:@"policyNumber"];

      [cell addSubview:policyLabel];
      [cell addSubview:policyField];
    }
      if (indexPath.section==[self attorneySection] && indexPath.row == 2) {
          UILabel *companyLabel = [self labelWithText:@"Company"];
          UITextField *companyField = [self textFieldWithKeyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext atIndexPath:indexPath];
          companyField.text = [self fieldValueForIndexPath:indexPath orKey:@"company"];
          
          [cell addSubview:companyLabel];
          [cell addSubview:companyField];
      }
  }

  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *title = [headerTitles objectAtIndex:section];
  return ([title length] == 0) ? nil : title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  for (UIView *childView in cell.subviews) {
    if ([childView respondsToSelector:@selector(becomeFirstResponder)] && ![childView isFirstResponder]) {
      [childView becomeFirstResponder];
      if (keyboardVisible) {
        [self scrollViewToTextField:childView];
      }
    }
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  // insert button pressed
  if (editingStyle == UITableViewCellEditingStyleInsert) {
    NSString *sectionName = [self groupForSection:indexPath.section];
    NSInteger section;	

    if ([sectionName isEqualToString:@"caregivers"]) {
      section = self.caregivers.count;
      self.caregivers = [self.caregivers arrayByAddingObject:[self createContact:@"caregiver"]];
    }

    else if ([sectionName isEqualToString:@"emergencyContacts"]) {
      section = self.caregivers.count + self.emergencyContacts.count;
      self.emergencyContacts = [self.emergencyContacts arrayByAddingObject:[self createContact:@"emergencyContact"]];
    }

    [self setupHeaderTitles];
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView endUpdates];
    [self.tableView reloadData];

    [self reindexFieldValuesForStyle:UITableViewCellEditingStyleInsert fromSection:section];
  }

  // delete button pressed
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSError *error;
    NSString *sectionName  = [self groupForSection:indexPath.section];
    SimpleContact *contact = [self contactForSection:indexPath.section];

    if ([sectionName isEqualToString:@"caregivers"]) {
      NSMutableArray *newCaregivers = [self.caregivers mutableCopy];
      [newCaregivers removeObject:contact];
      self.caregivers = [NSArray arrayWithArray:newCaregivers];
    }
    
    else if ([sectionName isEqualToString:@"emergencyContacts"]) {
      NSMutableArray *newEmergencyContacts = [self.emergencyContacts mutableCopy];
      [newEmergencyContacts removeObject:contact];
      self.emergencyContacts = [NSArray arrayWithArray:newEmergencyContacts];
    }

    [self setupHeaderTitles];
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

    [self.managedObjectContext deleteObject:contact];
    [self.managedObjectContext save:&error];

    [self reindexFieldValuesForStyle:UITableViewCellEditingStyleDelete fromSection:indexPath.section];
  }
}

- (void)reindexFieldValuesForStyle:(UITableViewCellEditingStyle)style
                       fromSection:(NSInteger)section
{  
  if (style == UITableViewCellEditingStyleInsert) {
    int i = [self numberOfEditableSections] + 3;
    
    while (i >= section) {
      int j = 0;
      
      while (j < 4) {
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:j inSection:i+1];
        NSString *key   = [self keyForIndexPath:currentIndexPath];
        NSString *value = [self.fieldValues objectForKey:key];

        if (value != nil) {
          NSString *newKey = [self keyForIndexPath:nextIndexPath];
          [self.fieldValues removeObjectForKey:key];
          [self.fieldValues setValue:value forKey:newKey];
        }
        
        j++;
      }

      i--;
    }
  }
  
  else if (style == UITableViewCellEditingStyleDelete) {
    if (section < [self numberOfEditableSections] + 3) {
      int i = section;

      while (i <= [self numberOfEditableSections] + 3) {
        int j = 0 ;

        while (j < 4) {
          NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:j inSection:i+1];        
          NSString *key   = [self keyForIndexPath:nextIndexPath];
          NSString *value = [self.fieldValues objectForKey:key];

          if (value != nil) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSString *newKey = [self keyForIndexPath:newIndexPath];
            [self.fieldValues removeObjectForKey:key];
            [self.fieldValues setValue:value forKey:newKey];
          }

          j++;
        }

        i++;
      }
    }
  }
}

#pragma mark -
#pragma mark - Text field handling

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
  UITableViewCell *cell = nil;
  if ([textField isKindOfClass:[UITextField class]]) 
    cell = (UITableViewCell *) ((UITextField *) textField).superview;
  else if ([textField isKindOfClass:[UITextView class]])
    cell = (UITableViewCell *) ((UITextView *) textField).superview;

  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark -
#pragma mark UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  activeTextField = textField;
  if (keyboardVisible) {
    [self scrollViewToTextField:textField];
  }
}

#pragma mark -
#pragma mark - Extra Textfield delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  // Only do formatting for the phone number fields
  // The phone fields don't have specific tags
  // Have to check the label that's next to them
  
  UITableViewCell *cell = (UITableViewCell *)textField.superview;
  UILabel *label = [cell.subviews objectAtIndex:2];
  if ([label.text rangeOfString:@"phone" options:NSCaseInsensitiveSearch].location == NSNotFound) return YES;
  
  int length = [self getLength:textField.text];
  
  if(length == 10)
  {
    if(range.length == 0)
      return NO;
  }
  
  if(length == 3)
  {
    NSString *num = [self formatNumber:textField.text];
    textField.text = [NSString stringWithFormat:@"(%@) ",num];
    if(range.length > 0)
      textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
  }
  else if(length == 6)
  {
    NSString *num = [self formatNumber:textField.text];
    textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
    if(range.length > 0)
      textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
  }
  
  return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
  
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  int length = [mobileNumber length];
  if(length > 10)
  {
    mobileNumber = [mobileNumber substringFromIndex: length-10];
    
  }
  
  return mobileNumber;
}

-(int)getLength:(NSString*)mobileNumber
{
  
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  int length = [mobileNumber length];
  
  return length;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  UITableViewCell *cell = (UITableViewCell *)textField.superview;
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

  // Update the cached field values for use while scrolling
  [self.fieldValues setValue:textField.text forKey:[self keyForIndexPath:indexPath]];

  // Update the SimpleContact object
  SimpleContact *contact = [self contactForSection:indexPath.section];

  if (indexPath.section < [self insuranceBrokerSection]) {
    if (indexPath.row == 0) contact.name = textField.text;
    if (indexPath.row == 1) contact.phoneHome = textField.text;
    if (indexPath.row == 2) contact.phoneWork = textField.text;
    if (indexPath.row == 3) contact.phoneCell = textField.text;
  }

  else if (indexPath.section == [self insuranceBrokerSection]) {
    if (indexPath.row == 0) contact.name = textField.text;
    if (indexPath.row == 1) contact.phoneWork = textField.text;
    if (indexPath.row == 2) contact.company = textField.text;
    if (indexPath.row == 3) contact.policyNumber = textField.text;
  }

  else if (indexPath.section == [self accountantSection] || indexPath.section == [self notarySection]) {
    if (indexPath.row == 0) contact.name = textField.text;
    if (indexPath.row == 1) contact.phoneWork = textField.text;
  }
    else if (indexPath.section==[self attorneySection])
    {
        if (indexPath.row == 0) contact.name=textField.text;
        if (indexPath.row == 1) contact.phoneWork=textField.text;
        if (indexPath.row == 2) contact.company=textField.text;
            
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  UITableViewCell *cell = (UITableViewCell *) ((UITextField *) textField).superview;

  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  NSIndexPath *nextIndexPathRow = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
  NSIndexPath *nextIndexPathSection = [NSIndexPath indexPathForRow:0 inSection:indexPath.section+1];
  
  UITableViewCell *nextCell = nil;
  nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPathRow];
  if (nextCell == nil) nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPathSection];

  if (nextCell != nil) {
    UITextField *nextField = [[nextCell subviews] objectAtIndex:3];
    if ([nextField respondsToSelector:@selector(becomeFirstResponder)]) {
      [nextField becomeFirstResponder];
    }
  }

  return YES;
}

#pragma mark - 
#pragma mark - Data loading

- (NSArray *)loadContacts
{  
  NSError *error;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SimpleContact"];
  request.predicate       = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
  NSArray *results        = [self.managedObjectContext executeFetchRequest:request error:&error];
  return results;
}

- (NSArray *)contactsOfType:(NSString *)type
{
  NSArray *filteredContacts;

  if ([self.contacts count] > 0) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", type];
    filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
  } else {
    filteredContacts = [NSArray arrayWithObject:[self createContact:type]];
  }
  
  return filteredContacts;
}

- (SimpleContact *)createContact:(NSString *)type
{
  SimpleContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"SimpleContact" inManagedObjectContext:self.managedObjectContext];
  contact.patient = self.patient;
  contact.type = type;
  return contact;
}

#pragma mark - 
#pragma mark - Helper methods

- (UILabel *)labelWithText:(NSString *)text
{
  NSInteger yLocation = 12;

  if (![text isEqualToString:@"name"]) {
    yLocation -= 1;
  }
  
  UILabel *label        = [[UILabel alloc] initWithFrame:CGRectMake(20, yLocation, 77, 21)];
  label.textColor       = [UIColor colorWithRed:0.00f green:0.44f blue:0.52f alpha:1.00f];
  label.font            = [UIFont boldSystemFontOfSize:13];
  label.textAlignment   = ALIGN_CENTER;
  label.backgroundColor = [UIColor clearColor];
  label.text            = text;

  return label;
}

- (UITextField *)textFieldWithKeyboardType:(UIKeyboardType)keyboardType
                             returnKeyType:(UIReturnKeyType)returnKeyType
                             atIndexPath:(NSIndexPath *)indexPath
{
  UITextField *textField    = [[UITextField alloc] initWithFrame:CGRectMake(116, 7, 187, 31)];
  textField.backgroundColor = [UIColor clearColor];
  textField.font            = [UIFont systemFontOfSize:16];
  textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  textField.keyboardType    = keyboardType;
  textField.returnKeyType   = returnKeyType;

  textField.adjustsFontSizeToFitWidth = YES;        
  textField.autocapitalizationType    = UITextAutocapitalizationTypeWords;
  textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;

  textField.delegate = self;
  return textField;
}

#pragma mark -
#pragma mark - Keyboard handlers

- (void)keyboardDidShow: (NSNotification *)notification {
  keyboardVisible = YES;
}

- (void)keyboardDidHide: (NSNotification *)notification {
  keyboardVisible = NO;
}

#pragma mark - 
#pragma mark - Gesture recognizer

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateEnded) {
    [activeTextField resignFirstResponder];
  }
}

#pragma mark - 
#pragma mark - View lifecycle

- (void)setupHeaderTitles
{
  // Setup the table header titles
  // Pad the header titles array for each of the multi editable sections
  headerTitles  = [NSMutableArray arrayWithObjects:@"Caregivers", @"Emergency Contacts", @"Insurance Broker", @"Accountant", @"Notary", @"Attorney" , nil];
  NSArray *multiSectionCounts = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInt:self.caregivers.count],
                                  [NSNumber numberWithInt:self.emergencyContacts.count], nil];
 
  int count;
  int paddedCount = 0;
  
  for (int i=0; i<multiSectionCounts.count; i++) {
    count = [[multiSectionCounts objectAtIndex:i] intValue];
    if (count > 1) {
      while (--count > 0) {
        [headerTitles insertObject:@"" atIndex:i+1+paddedCount];
        paddedCount++;
      }
    }
  }
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath
{
  return [NSString stringWithFormat:@"[%u,%u]", indexPath.section, indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView setEditing:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self save:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  keyboardVisible = NO;

  self.contacts          = [self loadContacts];
  self.caregivers        = [self contactsOfType:@"caregiver"];
  self.emergencyContacts = [self contactsOfType:@"emergencyContact"];
  self.insuranceBroker   = [[self contactsOfType:@"insuranceBroker"] objectAtIndex:0];
  self.accountant        = [[self contactsOfType:@"accountant"] objectAtIndex:0];
  self.notary            = [[self contactsOfType:@"notary"] objectAtIndex:0];
    self.attorney          =[[self contactsOfType:@"attorney"] objectAtIndex:0];

  // Setup the table headers
  [self setupHeaderTitles];

  phoneTitles = [NSMutableArray arrayWithObjects:@"Home Phone", @"Work Phone", @"Cell Phone", nil];
  self.fieldValues = [[NSMutableDictionary alloc] init];

  // Data has finished loading
  // Reload the table to setup the correct headings
  [self.tableView reloadData];

  // Setup double tap gesture to hide keyboard
  UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  doubleTapRecognizer.numberOfTapsRequired = 2;
  [self.view addGestureRecognizer:doubleTapRecognizer];

  // Listen for keyboard appearances and disappearances
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(keyboardDidShow:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardDidHide:)
                                               name:UIKeyboardDidHideNotification
                                             object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [self setManagedObjectContext:nil];
  [self setPatient:nil];
  [self setContacts:nil];
  [self setCaregivers:nil];
  [self setEmergencyContacts:nil];
  [self setInsuranceBroker:nil];
  [self setAccountant:nil];
  [self setNotary:nil];
  [self setFieldValues:nil];
    [self setAttorney:nil];
}

@end
