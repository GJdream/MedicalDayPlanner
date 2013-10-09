//
//  TestPhoto.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Test;

@interface TestPhoto : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) Test *test;

@end
