//
//  Appointment+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/11/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Appointment+Methods.h"
#import "Patient.h"

@implementation Appointment (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Appointment *)createAppointmentWithInfo:(NSDictionary *)appointmentFields
                                          forPatient:(Patient *)aPatient
                              inManagedObjectContext:(NSManagedObjectContext *)context
{
  Appointment *appointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
  [Appointment processAppointment:appointment withInfo:appointmentFields];
  [aPatient addAppointmentsObject:appointment];
  NSError *error = nil;
  [context save:&error];
  return appointment;
}

+ (Appointment *)modifyAppointment:(Appointment *)appointment
                                    withInfo:(NSDictionary *)appointmentFields
                      inManagedObjectContext:(NSManagedObjectContext *)context
{
  [Appointment processAppointment:appointment withInfo:appointmentFields];
  NSError *error = nil;
  [context save:&error];
  return appointment;
}

/*
 *
 * This method is used to process the incoming form data for the Appointment and massage it
 * Date fields are converted to NSDate, photo's turned into PNG representations, etc.
 *
 * */

+ (Appointment *)processAppointment:(Appointment *)appointment withInfo:(NSDictionary *)appointmentFields
{
  NSMutableDictionary *appointmentInfo = [NSMutableDictionary dictionaryWithDictionary:appointmentFields];
  NSArray *keys = [appointmentInfo allKeys];
  
  // Replace contact name if none given
  NSString *trimmedName = [[appointmentInfo objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    appointment.physician = @"Physician Name";
    [appointmentInfo removeObjectForKey:@"name"];
  }
  
  // Convert date strings to date objects
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/yy hh:mm a"];
  
  if ([[appointmentInfo objectForKey:@"dateTime"] length] > 0)
  {
    NSString *dateTime = [appointmentInfo objectForKey:@"dateTime"];
    NSDate *date = [formatter dateFromString:dateTime];    
    appointment.dateTime = date;
  } else {
    appointment.dateTime = nil;
  }
  
  if ([[appointmentInfo objectForKey:@"nextDateTime"] length] > 0)
  {
    NSString *dateTime = [appointmentInfo objectForKey:@"nextDateTime"];
    NSDate *date = [formatter dateFromString:dateTime];
    appointment.nextDateTime = date;
  } else {
    appointment.nextDateTime = nil;
  }
  
  // No longer need the date info
  [appointmentInfo removeObjectForKey:@"dateTime"];
  [appointmentInfo removeObjectForKey:@"nextDateTime"];
  
  // Reindex the keys since we probably removed some
  keys = [appointmentInfo allKeys];
  for (NSString *key in keys) {
    if ([appointment respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [appointment setValue:[appointmentInfo objectForKey:key] forKey:key];
    }
  }
  
  return appointment;
}

- (NSString *)formattedDateTime {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"LLLL dd, yyyy 'at' hh:mm a"];

  if (self.dateTime) {
    return [dateFormatter stringFromDate:self.dateTime];
  }

  return @"Unknown appointment date";
}

@end
