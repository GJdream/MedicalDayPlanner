//
//  Test+Methods.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Test+Methods.h"
#import "TestPhoto.h"
#import "Patient.h"

@implementation Test (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Test *)createTestWithInfo:(NSDictionary *)testFields
                              forPatient:(Patient *)aPatient
                  inManagedObjectContext:(NSManagedObjectContext *)context
{
  Test *test = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:context];
  [Test processTest:test withInfo:testFields inContext:context];
  [aPatient addTestsObject:test];
  NSError *error = nil;
  [context save:&error];
  return test;
}

+ (Test *)modifyTest:(Test *)test
                        withInfo:(NSDictionary *)testFields
          inManagedObjectContext:(NSManagedObjectContext *)context
{
  [Test processTest:test withInfo:testFields inContext:context];
  NSError *error = nil;
  [context save:&error];
  return test;
}

+ (Test *)processTest:(Test *)test withInfo:(NSDictionary *)testFields inContext:(id)context
{
  NSMutableDictionary *testInfo = [NSMutableDictionary dictionaryWithDictionary:testFields];
  NSArray *keys = [testInfo allKeys];
  
  // Replace contact name if none given
  NSString *trimmedName = [[testInfo objectForKey:@"type"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([trimmedName length] == 0) {
    test.type = @"Test";
    [testInfo removeObjectForKey:@"type"];
  }
  
  // Format dates
  if ([[testInfo objectForKey:@"performedDate"] length] > 0)
  {
    NSString *performedDate = [testInfo objectForKey:@"performedDate"];
    
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:performedDate];
    
    test.performedDate = date;
  } else {
    test.performedDate = nil;
  }
  
  // No longer need the date info
  [testInfo removeObjectForKey:@"performedDate"];
  
  // Setup the photo objects
  NSMutableArray *testPhotos = [[NSMutableArray alloc] init];
  
  if ([(NSArray *)[testInfo objectForKey:@"photos"] count] > 0) {    
    for (NSString *filename in [testInfo objectForKey:@"photos"]) {
      TestPhoto *testPhoto = [[TestPhoto alloc] initWithEntity:[NSEntityDescription entityForName:@"TestPhoto" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
      testPhoto.filename = filename;
      [testPhotos addObject:testPhoto];
    }
  }
  
  [test removePhotos:test.photos];
  [test addPhotos:[NSSet setWithArray:testPhotos]];
  [testInfo removeObjectForKey:@"photos"];
  
  // Reindex the keys since we probably removed some
  keys = [testInfo allKeys];
  for (NSString *key in keys) {
    if ([test respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [test setValue:[testInfo objectForKey:key] forKey:key];
    }
  }
  
  return test;
}

- (NSString *)performedDateString
{
  NSString *value = @"";
  
  if (self.performedDate) {
    // Convert string to date object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    return [formatter stringFromDate:self.performedDate];
  }
  
  return value;
}

- (NSString *)detailText
{
  return self.performedDateString;
}

- (NSArray *)photoFilenames
{
  NSMutableArray *filenames = [[NSMutableArray alloc] init];
  
  if ([self.photos count] > 0) {
    for (TestPhoto *photo in self.photos) {
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
