//
//  TitleRowCell.h
//  RenewalReminder
//
//  Created by MonuRathor on 12/03/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleRowCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblRenewalCount;
@end
