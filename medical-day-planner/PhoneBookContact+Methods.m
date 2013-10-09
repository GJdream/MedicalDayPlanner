//
//  PhoneBookContact+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/25/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "PhoneBookContact+Methods.h"
#import "Patient.h"

@implementation PhoneBookContact (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (PhoneBookContact *)createPhoneBookContactWithInfo:(NSDictionary *)phoneBookContactFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context
{
  PhoneBookContact *phonebook = [NSEntityDescription insertNewObjectForEntityForName:@"PhoneBookContact" inManagedObjectContext:context];
  [PhoneBookContact processPhoneBookContact:phonebook withInfo:phoneBookContactFields];
  [aPatient addPhonebookContactsObject:phonebook];
  NSError *error = nil;
  [context save:&error];
  return phonebook;
}

+ (PhoneBookContact *)modifyPhoneBookContact:(PhoneBookContact *)phoneBookContact
                      withInfo:(NSDictionary *)phoneBookContactFields
        inManagedObjectContext:(NSManagedObjectContext *)context
{
  [PhoneBookContact processPhoneBookContact:phoneBookContact withInfo:phoneBookContactFields];
  NSError *error = nil;
  [context save:&error];
  return phoneBookContact;
}

/*
 *
 * This method is used to process the incoming form data for the PhoneBookContact and massage it
 * Date fields are converted to NSDate, photo's turned into PNG representations, etc.
 *
 * */

+ (PhoneBookContact *)processPhoneBookContact:(PhoneBookContact *)phoneBookContact withInfo:(NSDictionary *)phoneBookContactFields
{
  NSMutableDictionary *phoneBookContactInfo = [NSMutableDictionary dictionaryWithDictionary:phoneBookContactFields];
  NSArray *keys = [phoneBookContactInfo allKeys];
  
  // Replace contact name if none given
  NSString *trimmedName = [[phoneBookContactInfo objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    phoneBookContact.name = @"Contact Name";
    [phoneBookContactInfo removeObjectForKey:@"name"];
  }
  
  // Reindex the keys since we probably removed some
  keys = [phoneBookContactInfo allKeys];
  for (NSString *key in keys) {
    if ([phoneBookContact respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [phoneBookContact setValue:[phoneBookContactInfo objectForKey:key] forKey:key];
    }
  }
  
  return phoneBookContact;
}

- (NSString *)availablePhone
{
  NSString *phone = @"";
  
  if ([self.phone length] != 0) {
    return self.phone;
  } else if ([self.contactPhone length] != 0) {
    return self.contactPhone;
  }

  return phone;
}

@end
