//
//  NSManagedObject+toDictionary.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/21/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (toDictionary)

- (NSDictionary *)toDictionary;

@end
