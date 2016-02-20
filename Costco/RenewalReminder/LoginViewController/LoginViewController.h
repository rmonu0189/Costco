//
//  LoginViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


- (IBAction)clickedSignIn:(id)sender;
- (IBAction)clickedRegister:(id)sender;
- (IBAction)clickedSigninFacebook:(id)sender;
- (IBAction)clickedSigninTwitter:(id)sender;
- (IBAction)clickedForgotPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewLoginFields;


@end
