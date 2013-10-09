//
//  Hospitalization+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Hospitalization+Methods.h"

@implementation Hospitalization (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Hospitalization *)createHospitalizationWithInfo:(NSDictionary *)hospitalizationFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context
{
  Hospitalization *hospitalization = [NSEntityDescription insertNewObjectForEntityForName:@"Hospitalization" inManagedObjectContext:context];
  [Hospitalization processHospitalization:hospitalization withInfo:hospitalizationFields inContext:context];
  [aPatient addHospitalizationsObject:hospitalization];
  NSError *error = nil;
  [context save:&error];
  return hospitalization;
}

+ (Hospitalization *)modifyHospitalization:(Hospitalization *)hospitalization
                      withInfo:(NSDictionary *)hospitalizationFields
        inManagedObjectContext:(NSManagedObjectContext *)context
{
  [Hospitalization processHospitalization:hospitalization withInfo:hospitalizationFields inContext:context];
  NSError *error = nil;
  [context save:&error];
  return hospitalization;
}

+ (Hospitalization *)processHospitalization:(Hospitalization *)hospitalization withInfo:(NSDictionary *)hospitalizationFields inContext:(id)context
{
  NSMutableDictionary *hospitalizationInfo = [NSMutableDictionary dictionaryWithDictionary:hospitalizationFields];
  NSArray *keys = [hospitalizationInfo allKeys];
 
  // Format dates
  if ([[hospitalizationInfo objectForKey:@"admitDate"] length] > 0)
  {
    NSString *admitDate = [hospitalizationInfo objectForKey:@"admitDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:admitDate];
    
    hospitalization.admitDate = date;
  } else {
    hospitalization.admitDate = nil;
  }
  
  if ([[hospitalizationInfo objectForKey:@"dischargeDate"] length] > 0)
  {
    NSString *dischargeDate = [hospitalizationInfo objectForKey:@"dischargeDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:dischargeDate];
    
    hospitalization.dischargeDate = date;
  } else {
    hospitalization.dischargeDate = nil;
  }
  
  // No longer need the date info
  [hospitalizationInfo removeObjectForKey:@"admitDate"];
  [hospitalizationInfo removeObjectForKey:@"dischargeDate"];
  
  // Reindex the keys since we probably removed some
  keys = [hospitalizationInfo allKeys];
  for (NSString *key in keys) {
    if ([hospitalization respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [hospitalization setValue:[hospitalizationInfo objectForKey:key] forKey:key];
    }
  }
  
  return hospitalization;
}

- (NSString *)admitDateString
{
  NSString *value = @"";
  
  if (self.admitDate) {
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:self.admitDate];
  }
  
  return value;
}

- (NSString *)dischargeDateString
{
  NSString *value = @"";
  
  if (self.dischargeDate) {
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    value = [formatter stringFromDate:self.dischargeDate];
  }
  
  return value;
}

- (NSString *)detailText
{
  NSString *detailString = [NSString stringWithString:self.admitDateString];
  
  if (self.dischargeDateString.length != 0) {
    detailString = [detailString stringByAppendingFormat:@" – %@", self.dischargeDateString];
  }
  
  return detailString;
}

@end
