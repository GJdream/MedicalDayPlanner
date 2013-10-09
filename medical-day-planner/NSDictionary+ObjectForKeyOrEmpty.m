//
//  NSDictionary+ObjectForKeyOrEmpty.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/8/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "NSDictionary+ObjectForKeyOrEmpty.h"

@implementation NSDictionary (objectForKeyOrEmpty)

- (id)objectForKeyOrEmpty:(NSString *)key;
{
  id value = [self valueForKey:key];
  if (value == nil) {
    value = @"";
  }
  return value;
}

@end
