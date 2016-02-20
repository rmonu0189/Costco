//
//  HomeViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 28/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblRenewal30;
@property (weak, nonatomic) IBOutlet UITableView *tblRenewalOther;
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;
- (IBAction)clickedMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoRecordFound;
@property (weak, nonatomic) IBOutlet UIButton *btnNorecordFound;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfRemainDays;
@property (weak, nonatomic) IBOutlet UILabel *lblReminderType;

- (IBAction)clickedNoRecord:(id)sender;

- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;

@end
