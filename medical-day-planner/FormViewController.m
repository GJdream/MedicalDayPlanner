//
//  FormViewController.m
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()
- (void)scrollViewToTextField:(id)textField;
@end

@implementation FormViewController

@synthesize managedObjectContext = _managedObjectContext;

#pragma mark -
#pragma mark - Form gathering

- (NSDictionary *)gatheredFormData
{
  Class klass = [self class];
  u_int count;
  
  objc_property_t *properties = class_copyPropertyList(klass, &count);
  NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];

  for (int i = 0; i < count ; i++)
  {
    NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];

    id field = nil;
    if ([self respondsToSelector:NSSelectorFromString(propertyName)]) {
      field = [self performSelector:NSSelectorFromString(propertyName)];
    }
  
    // Bool fields (table cells)
    if ([field isKindOfClass:[UITableViewCell class]]) {
      [fields setValue:[NSNumber numberWithBool:([field accessoryType] == UITableViewCellAccessoryCheckmark)] forKey:propertyName];
    }
    
    // TextField and TextView elements
    else if ([field isKindOfClass:[UITextField class]] || [field isKindOfClass:[UITextView class]]) {
      [fields setValue:[field text] forKey:propertyName];
         }
        
    // Switch elements
    else if ([field isKindOfClass:[UISwitch class]]) {
      [fields setValue:[NSNumber numberWithBool:[field isOn]] forKey:propertyName];
    }
  }

  
  free(properties);
  return fields;
}

- (void)setFormData:(NSDictionary *)formData
{
  for (NSString *key in formData) {
    id field = [self performSelector:NSSelectorFromString(key)];
    id value = [formData objectForKey:key];
      
    if (field) {
      // Set value of text fields      
      if ([field isKindOfClass:[UITextField class]] || [field isKindOfClass:[UITextView class]]) {
        // format date and time fields
          
          
         if([key rangeOfString:@"alarmTime" options:NSCaseInsensitiveSearch].location != NSNotFound)
         {
              NSDate *date = value;
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"hh:mm a"];
             value = [formatter stringFromDate:date];
             
         
         }
          
        if ([key rangeOfString:@"dateTime" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
          NSDate *date = value;
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"MM/dd/yy hh:mm a"];
          value = [formatter stringFromDate:date];
        }

        // format date fields
        else if ([key rangeOfString:@"date" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
          NSDate *date = value;
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"MM/dd/yyyy"];
          value = [formatter stringFromDate:date];
           
        }
       
        [field setText:value];
      }

      // Set value (check type) for table cells
      else if ([field isKindOfClass:[UITableViewCell class]]) {
        [field setAccessoryType:([value integerValue] == 1 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
      }
      
      // Switch elements
      else if ([field isKindOfClass:[UISwitch class]]) {
        [field setOn:[value boolValue] animated:NO];
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
    cell = (UITableViewCell *) ((UITextField *) textField).superview.superview;
  else if ([textField isKindOfClass:[UITextView class]])
    cell = (UITableViewCell *) ((UITextView *) textField).superview.superview;
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark -
#pragma mark UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  activeTextView = textField;
  if (keyboardVisible) {      
    [self scrollViewToTextField:textField];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (keyboardVisible) {
    [self scrollViewToTextField:textField];
  }
  
  NSInteger nextFieldTag = [textField tag] + 1;
  [[self.view viewWithTag:nextFieldTag] becomeFirstResponder];
  
  return YES;
}

#pragma mark -
#pragma mark UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  activeTextView = textView;
  if (keyboardVisible) {      
    [self scrollViewToTextField:textView];
  }
}

#pragma mark - 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIView *content = [self.tableView cellForRowAtIndexPath:indexPath].contentView;
  for (UIView *childView in content.subviews) {   
    if ([childView respondsToSelector:@selector(becomeFirstResponder)] && ![childView isFirstResponder]) {
      [childView becomeFirstResponder];
      if (keyboardVisible) {
        [self scrollViewToTextField:childView];
      }
    }
  }
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
    [activeTextView resignFirstResponder];
  }
}

#pragma mark - 
#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  keyboardVisible = NO;

  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
  
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
  [self setManagedObjectContext:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
