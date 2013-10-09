//
//  ARUINavigationController.m
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/13/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARUINavigationController.h"

#import "ARUINavigationController.h"
@implementation ARUINavigationController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
  [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} 

@end
