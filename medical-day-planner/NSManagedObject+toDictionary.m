//
//  NSManagedObject+toDictionary.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/21/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "NSManagedObject+toDictionary.h"

@implementation NSManagedObject (toDictionary)

- (NSDictionary*)toDictionary
{  
  NSArray* attributes = [[[self entity] attributesByName] allKeys];
  NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:
                               [attributes count] + 1];
  
  [dict setObject:[[self class] description] forKey:@"class"];
  
  for (NSString* attr in attributes) {
    NSObject* value = [self valueForKey:attr];
    
    if (value != nil) {
      [dict setObject:value forKey:attr];
    }
  }
  
  return dict;
}

@end
