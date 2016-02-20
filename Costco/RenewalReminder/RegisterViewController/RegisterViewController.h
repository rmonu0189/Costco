//
//  RegisterViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewRegisterFields;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtSurname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewRegister;
@property (weak, nonatomic) IBOutlet UIPickerView *titlePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnTerms;

- (IBAction)clickedHome:(id)sender;
- (IBAction)clickedRegister:(id)sender;
- (IBAction)clickedTitle:(id)sender;
- (IBAction)clickedCheckBoxTerms:(id)sender;
- (IBAction)clickedOpenTerms:(id)sender;

@end
