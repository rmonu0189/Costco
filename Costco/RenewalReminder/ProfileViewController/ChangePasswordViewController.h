//
//  ChangePasswordViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 06/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
- (IBAction)clickedChangePassword:(id)sender;
- (IBAction)clickedBack:(id)sender;

@end
