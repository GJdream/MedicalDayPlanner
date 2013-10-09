//
//  NSDictionary+ObjectForKeyOrEmpty.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/8/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (objectForKeyOrEmpty)

- (id)objectForKeyOrEmpty:(NSString *)key;

@end
