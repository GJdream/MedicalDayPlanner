//
//  Treatment+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Treatment+Methods.h"

@implementation Treatment (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Treatment *)createTreatmentWithInfo:(NSDictionary *)treatmentFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context
{
  Treatment *treatment = [NSEntityDescription insertNewObjectForEntityForName:@"Treatment" inManagedObjectContext:context];
  [Treatment processTreatment:treatment withInfo:treatmentFields inContext:context];
  [aPatient addTreatmentsObject:treatment];
  NSError *error = nil;
  [context save:&error];
  return treatment;
}

+ (Treatment *)modifyTreatment:(Treatment *)treatment
                      withInfo:(NSDictionary *)treatmentFields
        inManagedObjectContext:(NSManagedObjectContext *)context
{
  [Treatment processTreatment:treatment withInfo:treatmentFields inContext:context];
  NSError *error = nil;
  [context save:&error];
  return treatment;
}

+ (Treatment *)processTreatment:(Treatment *)treatment withInfo:(NSDictionary *)treatmentFields inContext:(id)context
{
  NSMutableDictionary *treatmentInfo = [NSMutableDictionary dictionaryWithDictionary:treatmentFields];
  NSArray *keys = [treatmentInfo allKeys];
  
  // Replace contact name if none given
  NSString *trimmedName = [[treatmentInfo objectForKey:@"treatmentText"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    treatment.treatmentText = @"Treatment";
    [treatmentInfo removeObjectForKey:@"treatmentText"];
  }
  
  // Format dates
  if ([[treatmentInfo objectForKey:@"startDate"] length] > 0)
  {
    NSString *startDate = [treatmentInfo objectForKey:@"startDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:startDate];
    
    treatment.startDate = date;
  } else {
    treatment.startDate = nil;
  }
  
  if ([[treatmentInfo objectForKey:@"endDate"] length] > 0)
  {
    NSString *endDate = [treatmentInfo objectForKey:@"endDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:endDate];
    
    treatment.endDate = date;
  } else {
    treatment.endDate = nil;
  }
  
  // No longer need the date info
  [treatmentInfo removeObjectForKey:@"startDate"];
  [treatmentInfo removeObjectForKey:@"endDate"];
  
  // Reindex the keys since we probably removed some
  keys = [treatmentInfo allKeys];
  for (NSString *key in keys) {
    if ([treatment respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [treatment setValue:[treatmentInfo objectForKey:key] forKey:key];
    }
  }
  
  return treatment;
}

- (NSString *)startDateString
{
  NSString *value = @"";
  
  if (self.startDate) {
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:self.startDate];
  }
  
  return value;
}

- (NSString *)endDateString
{
  NSString *value = @"";
  
  if (self.endDate) {
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    value = [formatter stringFromDate:self.endDate];
  }
  
  return value;
}

- (NSString *)detailText
{
  NSString *detailString = [NSString stringWithString:self.startDateString];

  if (self.endDateString.length != 0) {
    detailString = [detailString stringByAppendingFormat:@" – %@", self.endDateString];
  }
  
  return detailString;
}

@end
