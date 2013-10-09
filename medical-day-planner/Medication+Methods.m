//
//  Medication+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Medication+Methods.h"
#import "MedicationPhoto.h"
#import "Patient.h"

@implementation Medication (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Medication *)createMedicationWithInfo:(NSDictionary *)medicationFields
                              forPatient:(Patient *)aPatient
                  inManagedObjectContext:(NSManagedObjectContext *)context
{
  Medication *medication = [NSEntityDescription insertNewObjectForEntityForName:@"Medication" inManagedObjectContext:context];
  [Medication processMedication:medication withInfo:medicationFields inContext:context];
  [aPatient addMedicationsObject:medication];
  NSError *error = nil;
  [context save:&error];
  return medication;
}

+ (Medication *)modifyMedication:(Medication *)medication
withInfo:(NSDictionary *)medicationFields
inManagedObjectContext:(NSManagedObjectContext *)context
{
  [Medication processMedication:medication withInfo:medicationFields inContext:context];
  NSError *error = nil;
  [context save:&error];
  return medication;
}

+ (Medication *)processMedication:(Medication *)medication withInfo:(NSDictionary *)medicationFields inContext:(id)context
{
  NSMutableDictionary *medicationInfo = [NSMutableDictionary dictionaryWithDictionary:medicationFields];
  NSArray *keys = [medicationInfo allKeys];
  
  // Replace contact name if none given
  NSString *trimmedName = [[medicationInfo objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    medication.name = @"Medication Name";
    [medicationInfo removeObjectForKey:@"name"];
  }
  
  // Format dates
  if ([[medicationInfo objectForKey:@"startDate"] length] > 0)
  {
    NSString *startDate = [medicationInfo objectForKey:@"startDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:startDate];
    
    medication.startDate = date;
  }
  else
  {
    medication.startDate = nil;
  }
  
  if ([[medicationInfo objectForKey:@"endDate"] length] > 0)
  {
    NSString *endDate = [medicationInfo objectForKey:@"endDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:endDate];
    
    medication.endDate = date;
  }
  else
  {
    medication.endDate = nil;
  }
    if ([[medicationInfo objectForKey:@"alarmTime"] length] > 0)
    {
        NSString *alarmTime = [medicationInfo objectForKey:@"alarmTime"];
       
        // Convert string to date object
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSDate *date = [formatter dateFromString:alarmTime];
        
        medication.alarmTime =date;
       
    }
    else
    {
        medication.alarmTime = nil;
    }
   
  // No longer need the date info
  [medicationInfo removeObjectForKey:@"startDate"];
  [medicationInfo removeObjectForKey:@"endDate"];
    [medicationInfo removeObjectForKey:@"alarmTime"];
    
  // Setup the photo objects
  NSMutableArray *medicationPhotos = [[NSMutableArray alloc] init];
  
  if ([(NSArray *)[medicationInfo objectForKey:@"photos"] count] > 0) {    
    for (NSString *filename in [medicationInfo objectForKey:@"photos"]) {
      MedicationPhoto *medPhoto = [[MedicationPhoto alloc] initWithEntity:[NSEntityDescription entityForName:@"MedicationPhoto" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
      medPhoto.filename = filename;
      [medicationPhotos addObject:medPhoto];
    }
  }

  [medication removePhotos:medication.photos];
  [medication addPhotos:[NSSet setWithArray:medicationPhotos]];
  [medicationInfo removeObjectForKey:@"photos"];
  
  // Reindex the keys since we probably removed some
  keys = [medicationInfo allKeys];
  for (NSString *key in keys) {
    if ([medication respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [medication setValue:[medicationInfo objectForKey:key] forKey:key];
        
    }
  }
  
  return medication;
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
-(NSString *)alarmTimeString
{
    NSString *value = @"";
    if (self.alarmTime) {
        // Convert string to date object
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        return [formatter stringFromDate:self.alarmTime];
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
  NSArray *detailFields  = [NSArray arrayWithObjects: self.dosage, self.frequency, nil];
  NSString *detailString = [[detailFields componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  if ([detailString length] != 0 && [self.endDateString length] != 0) {
      detailString = [detailString stringByAppendingFormat:@" until %@", self.endDateString];
  }

  // if detail is still empty, try using the description
  if ([detailString length] == 0 && [self.descriptionText length] != 0) {
    detailString = self.descriptionText;
  }
  
  return detailString;
}

- (NSArray *)photoFilenames
{
  NSMutableArray *filenames = [[NSMutableArray alloc] init];

  if ([self.photos count] > 0) {
    for (MedicationPhoto *photo in self.photos) {
      [filenames addObject:photo.filename];
    }
  }
  
  return filenames;
}

- (void)deletePhotoFiles
{
  NSError *error;
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

  for (NSString *fileName in self.photoFilenames) {
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:&error];
  }
}

@end
