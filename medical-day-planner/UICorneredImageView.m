//
//  UICorneredImageView.m
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/14/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UICorneredImageView.h"

@implementation UICorneredImageView

- (void)setNeedsDisplay {
  self.layer.cornerRadius = 5;
  self.layer.masksToBounds = YES;
  [self.layer setBorderWidth: 1.0];
  [self.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
}

@end
