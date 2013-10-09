
//
//  FormViewController.h
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <objc/runtime.h>

@interface FormViewController : UITableViewController  <UITextFieldDelegate, UITextViewDelegate>
{
  BOOL keyboardVisible;
  id activeTextView;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSDictionary *)gatheredFormData;
- (void)setFormData:(NSDictionary *)formData;

@end
