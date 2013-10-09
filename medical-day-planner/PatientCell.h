//
//  PatientCell.h
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/6/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *phone;
@property (nonatomic, strong) IBOutlet UIImageView *photo;

@end
