//
//  LoginViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestConnection.h"
#import "RenewalViewController.h"
#import "FacebookManager.h"
#import "HTTwitterEngine.h"

//-- Define key for twitter login. DEVELOPER
#define kOAuthConsumerKey @"L08FAnGKO8RPlXPkPw5WBvtx3"		//REPLACE ME
#define kOAuthConsumerSecret @"8LWT4UW8oXqWK7AjbEaZsBJIZsamoZy7M4bIf2Ik44fVlXnlEg"		//REPLACE ME

@interface LoginViewController ()<RequestConnectionDelegate,FacebookManagerDelegate>
{
    int loginType;
    id twitterResponse, facebookResponse;
    BOOL isRegister;
}
@property (nonatomic, strong) RequestConnection *connection;
@end

@implementation LoginViewController

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
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    if ([AppDelegate sharedAppDelegate].me) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
    //-- setup border of email text
    self.viewLoginFields.layer.masksToBounds = YES;
    self.viewLoginFields.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewLoginFields.layer.borderWidth = 0.5f;
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.txtEmail]) {
        [self.txtPassword becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtPassword]){
        [self.txtPassword resignFirstResponder];
        [self clickedSignIn:nil];
    }
    return YES;
}

- (IBAction)clickedSignIn:(id)sender {
    NSString *error = @"";
    if (self.txtEmail.text.length <=0) {
        error = @"Email address can not be blank.";
    }
    else if (self.txtPassword.text.length <=0) {
        error = @"Password can not be blank.";
    }
    
    if (error.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        loginType = 0;
        isRegister = NO;
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection loginUser:self.txtEmail.text Password:self.txtPassword.text andLoginType:@"0"];
    }
}

- (IBAction)clickedRegister:(id)sender {
}

- (IBAction)clickedSigninFacebook:(id)sender {
    [FacebookManager sharedManager].delegate = self;
    [[FacebookManager sharedManager]facebookLogin];
}

- (void)FBResultSuccess:(id)result andError:(NSError *)error{
    if (!error) {
        NSLog(@"FB login success");
        loginType = 1;
        facebookResponse = result;
        isRegister = NO;
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection loginUser:[result valueForKey:@"id"] Password:[result valueForKey:@"id"] andLoginType:@"1"];
    }
}

- (IBAction)clickedSigninTwitter:(id)sender {
    [[HTTwitterEngine sharedEngine]permanentlySetConsumerKey:kOAuthConsumerKey andSecret:kOAuthConsumerSecret];
    [[HTTwitterEngine sharedEngine]loadAccessToken];
    
    [[HTTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
        if (success) {
            id response = [[HTTwitterEngine sharedEngine] verifyCredentials];
            [self performSelectorOnMainThread:@selector(twitterLoginSuccess:) withObject:response waitUntilDone:NO];
        }
        else{
            [self performSelectorOnMainThread:@selector(twitterLoginFailed) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)twitterLoginSuccess:(id)response{
    twitterResponse = response;
    loginType = 2;
    [[AppDelegate sharedAppDelegate] startLoadingView];
    isRegister = NO;
    [self.connection loginUser:[response valueForKey:@"id"] Password:[response valueForKey:@"id"] andLoginType:@"2"];
    
//    [self.connection registerUserID:[response valueForKey:@"id"] Title:@"" FirstName:fname Surname:lname Email:@"" Password:[response valueForKey:@"id"] Mobile:@"" andLoginType:@"2"];
}

- (void)twitterLoginFailed{
    
}

- (IBAction)clickedForgotPassword:(id)sender {
    
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (isRegister) {
        if (!error) {
            isRegister = NO;
            if (loginType == 1) {
                [[AppDelegate sharedAppDelegate] startLoadingView];
                [self.connection loginUser:[facebookResponse valueForKey:@"id"] Password:[facebookResponse valueForKey:@"id"] andLoginType:@"1"];
            }
            else if (loginType == 2){
                [[AppDelegate sharedAppDelegate] startLoadingView];
                [self.connection loginUser:[twitterResponse valueForKey:@"id"] Password:[twitterResponse valueForKey:@"id"] andLoginType:@"2"];
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        if (!error) {
            [[AppDelegate sharedAppDelegate] saveUser:response];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        else{
            if (loginType == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (loginType == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your facebook account not registered. Do you want to register it?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                alert.tag = 1001;
                [alert show];
            }
            else if (loginType == 2){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Your twitter account not registered. Do you want to register it?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                alert.tag = 1001;
                [alert show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            if (loginType == 1) {
                NSLog(@"Facebook signup");
                [[AppDelegate sharedAppDelegate] startLoadingView];
                isRegister = YES;
                [self.connection registerUserID:[facebookResponse valueForKey:@"id"] Title:@"" FirstName:[facebookResponse valueForKey:@"first_name"] Surname:[facebookResponse valueForKey:@"last_name"] Email:@"" Password:[facebookResponse valueForKey:@"id"] Mobile:@"" andLoginType:@"1"];
            }
            else if (loginType == 2){
                NSLog(@"Twitter signup");
                NSArray *name = [[twitterResponse valueForKey:@"name"] componentsSeparatedByString:@" "];
                NSString *fname = @"";
                NSString *lname = @"";
                if (name.count>2) {
                    fname = [name firstObject];
                    lname = [name objectAtIndex:1];
                }
                else{
                    fname = [name firstObject];
                }
                [[AppDelegate sharedAppDelegate] startLoadingView];
                isRegister = YES;
                [self.connection registerUserID:[twitterResponse valueForKey:@"id"] Title:@"" FirstName:fname Surname:lname Email:@"" Password:[twitterResponse valueForKey:@"id"] Mobile:@"" andLoginType:@"2"];
            }
        }
    }
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

@end
