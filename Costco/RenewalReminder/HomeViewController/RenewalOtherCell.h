//
//  RenewalOtherCell.h
//  RenewalReminder
//
//  Created by MonuRathor on 28/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenewalOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainDays;
@property (weak, nonatomic) IBOutlet UILabel *lblYouAreWith;
@end
