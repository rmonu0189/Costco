//
//  SettingViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 01/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)clickedSetAlertTime:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *btnAlertOnOff;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)clickedTimePickerDone:(id)sender;
- (IBAction)clickedAlertOnOff:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewTimePicker;
@end
