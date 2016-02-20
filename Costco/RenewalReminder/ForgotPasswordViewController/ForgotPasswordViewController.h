//
//  ForgotPasswordViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewEmailText;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

- (IBAction)clickedBackLogin:(id)sender;
- (IBAction)clickedSendMyPassword:(id)sender;

@end
