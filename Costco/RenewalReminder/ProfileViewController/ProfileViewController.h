//
//  ProfileViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 30/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtSurname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtContact;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewProfile;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTitle;
@property (weak, nonatomic) IBOutlet UIView *viewPickerTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

- (IBAction)clickedSaveChanges:(id)sender;
- (IBAction)clickedBack:(id)sender;
- (IBAction)clickedHelp:(id)sender;
- (IBAction)clickedTitle:(id)sender;


@end
