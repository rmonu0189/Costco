//
//  ForgotPasswordViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "RequestConnection.h"

@interface ForgotPasswordViewController ()<RequestConnectionDelegate>
@property (nonatomic, strong) RequestConnection *connection;
@end

@implementation ForgotPasswordViewController

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
    
    //-- setup border of email text
    self.viewEmailText.layer.masksToBounds = YES;
    self.viewEmailText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewEmailText.layer.borderWidth = 0.5f;
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedBackLogin:(id)sender {
    [self.txtEmail resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtEmail resignFirstResponder];
    [self clickedSendMyPassword:nil];
    return YES;
    
}

- (IBAction)clickedSendMyPassword:(id)sender {
    if (self.txtEmail.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Email address can not be blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection forgotPassword:self.txtEmail.text];
    }
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

@end
