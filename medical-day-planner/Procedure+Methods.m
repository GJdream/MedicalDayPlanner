//
//  Procedure+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Procedure+Methods.h"

@implementation Procedure (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Procedure *)createProcedureWithInfo:(NSDictionary *)procedureFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context
{
  Procedure *procedure = [NSEntityDescription insertNewObjectForEntityForName:@"Procedure" inManagedObjectContext:context];
  [Procedure processProcedure:procedure withInfo:procedureFields inContext:context];
  [aPatient addProceduresObject:procedure];
  NSError *error = nil;
  [context save:&error];
  return procedure;
}

+ (Procedure *)modifyProcedure:(Procedure *)procedure
                      withInfo:(NSDictionary *)procedureFields
        inManagedObjectContext:(NSManagedObjectContext *)context
{
  [Procedure processProcedure:procedure withInfo:procedureFields inContext:context];
  NSError *error = nil;
  [context save:&error];
  return procedure;
}

+ (Procedure *)processProcedure:(Procedure *)procedure withInfo:(NSDictionary *)procedureFields inContext:(id)context
{
  NSMutableDictionary *procedureInfo = [NSMutableDictionary dictionaryWithDictionary:procedureFields];
  NSArray *keys = [procedureInfo allKeys];
  
  // Replace contact name if none given
  NSString *trimmedName = [[procedureInfo objectForKey:@"procedureText"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    procedure.procedureText = @"Procedure";
    [procedureInfo removeObjectForKey:@"procedureText"];
  }
  
  // Format dates
  if ([[procedureInfo objectForKey:@"date"] length] > 0)
  {
    NSString *dateString = [procedureInfo objectForKey:@"date"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:dateString];
    
    procedure.date = date;
  } else {
    procedure.date = nil;
  }
  
  // No longer need the date info
  [procedureInfo removeObjectForKey:@"date"];
  
  // Reindex the keys since we probably removed some
  keys = [procedureInfo allKeys];
  for (NSString *key in keys) {
    if ([procedure respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [procedure setValue:[procedureInfo objectForKey:key] forKey:key];
    }
  }
  
  return procedure;
}

- (NSString *)dateString
{
  NSString *value = @"";
  
  if (self.date) {
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:self.date];
  }
  
  return value;
}

- (NSString *)detailText
{  
  return self.dateString;
}

@end
