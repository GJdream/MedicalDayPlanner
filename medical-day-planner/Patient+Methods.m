//
//  Patient+Methods.m
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/8/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Patient+Methods.h"

@implementation Patient (Methods)

+ (Patient *)createPatientWithInfo:(NSDictionary *)patientFields
            inManagedObjectContext:(NSManagedObjectContext *)context
{
  Patient *patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:context];
  [Patient processPatient:patient withInfo:patientFields];   
  NSError *error = nil;
  [context save:&error];  
  return patient;
}


+ (Patient *)modifyPatient:(Patient *)patient
                  withInfo:(NSDictionary *)patientFields
    inManagedObjectContext:(NSManagedObjectContext *)context
{   
  [Patient processPatient:patient withInfo:patientFields];
  NSError *error = nil;
  [context save:&error];  
  return patient;
}

/*
 *
 * This method is used to process the incoming form data for the Patient and massage it
 * Date fields are converted to NSDate, photo's turned into PNG representations, etc.
 *
 * */
 
+ (Patient *)processPatient:(Patient *)patient withInfo:(NSDictionary *)patientFields
{
  NSMutableDictionary *patientInfo = [NSMutableDictionary dictionaryWithDictionary:patientFields];
  NSArray *keys = [patientInfo allKeys];

  // Replace patient name if none given
  NSString *trimmedName = [[patientInfo objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    patient.name = @"Patient Name";
    [patientInfo removeObjectForKey:@"name"];
  }

  // If a photo was given, set it up, otherwise clear it
  if (!![patientInfo objectForKey:@"photo"]) {
    patient.photo = UIImagePNGRepresentation([patientInfo objectForKey:@"photo"]);
    [patientInfo removeObjectForKey:@"photo"];
  } else {
    patient.photo = nil;
  }
  
  if ([[patientInfo objectForKey:@"dobDate"] length] > 0)
  {
    NSString *dob = [patientInfo objectForKey:@"dobDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:dob];
    
    patient.dobDate = date;
  } else {
    patient.dobDate = nil;
  }

  // No longer need the date info
  [patientInfo removeObjectForKey:@"dobDate"];
  
  // Reindex the keys since we probably removed some
  keys = [patientInfo allKeys];
  for (NSString *key in keys) {
    if ([patient respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [patient setValue:[patientInfo objectForKey:key] forKey:key];
    }
  }

  return patient;
}


- (NSString *)availablePhone
{
  NSString *phone = @"";
  
  if ([self.phoneHome length] != 0) {
    return self.phoneHome;
  } else if ([self.phoneWork length] != 0) {
    return self.phoneWork;
  } else if ([self.phoneCell length] != 0) {
    return self.phoneCell;
  }
  
  return phone;
}


- (UIImage *)parsedPhoto
{
  UIImage *image;
  
  if (self.photo) {
    [self willAccessValueForKey:@"photo"];
    NSData *imageData = [self primitiveValueForKey:@"photo"];
    [self didAccessValueForKey:@"photo"];
    image = [UIImage imageWithData:imageData];
  } else {
    image = [UIImage imageNamed:@"choosephoto"];
  }
  
  return image;
}


- (NSInteger)age
{
  if (self.dobDate)
  {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:self.dobDate];

    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
      return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
      return [dateComponentsNow year] - [dateComponentsBirth year];
    }   
  }

  return 0;
}

@end
