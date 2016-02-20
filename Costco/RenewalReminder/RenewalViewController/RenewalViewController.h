//
//  RenewalViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 30/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenewalViewController : UIViewController
@property (nonatomic, strong) NSDictionary *root;
@property (nonatomic, retain) NSString *renewalID;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtRenewalDate;
@property (weak, nonatomic) IBOutlet UITextField *txtYouAreWith;
@property (weak, nonatomic) IBOutlet UITextField *txtYouPaid;
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;
@property (weak, nonatomic) IBOutlet UIImageView *imgTypeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgTypeBackground;
@property (weak, nonatomic) IBOutlet UILabel *txtType;
@property (weak, nonatomic) IBOutlet UILabel *txtDueDate;
@property (weak, nonatomic) IBOutlet UILabel *lblYouWith;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIView *typePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewRenewal;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfRemainDays;
@property (weak, nonatomic) IBOutlet UILabel *lblReminderType;


- (IBAction)clickedEditRenewal:(id)sender;
- (IBAction)clickedBack:(id)sender;
- (IBAction)clickedDeleteRenewal:(id)sender;
- (IBAction)clickedRenewalType:(id)sender;
- (IBAction)clickedStartedDate:(id)sender;
- (IBAction)clickedRenewalDate:(id)sender;
- (IBAction)clickedPickerDone:(id)sender;

- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;


@end
