//
//  ChangePasswordViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 06/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "RequestConnection.h"

@interface ChangePasswordViewController ()< RequestConnectionDelegate>
@property (nonatomic, strong) RequestConnection *connection;


@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    
    [self.txtOldPassword setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtNewPassword setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassword setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.txtOldPassword]) {
        [self.txtNewPassword becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtNewPassword]){
        [self.confirmPassword becomeFirstResponder];
    }
    else if ([textField isEqual:self.confirmPassword]){
        [self.confirmPassword resignFirstResponder];
    }
    return YES;
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (IBAction)clickedChangePassword:(id)sender {
    NSString *error = @"";
    if (self.txtOldPassword.text.length <= 0) {
        error = @"Old password can not be blank.";
    }
    else if (self.txtNewPassword.text.length <= 0){
        error = @"New password can not be blank.";
    }
    else if (self.confirmPassword.text.length <= 0){
        error = @"Confirm password can not be blank.";
    }
    else if(self.txtNewPassword.text.length < 4){
        error = @"Password should be a minimum of 4 character.";
    }
    else if(![self.txtNewPassword.text isEqualToString:self.confirmPassword.text]){
        error = @"Confirm password does not match.";
    }
    
    if (error.length>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection changePassword:self.txtOldPassword.text NewPassword:self.txtNewPassword.text];
    }
}

- (IBAction)clickedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
