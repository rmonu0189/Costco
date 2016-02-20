//
//  ProfileViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 30/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "RequestConnection.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()< RequestConnectionDelegate>
@property (nonatomic, strong) RequestConnection *connection;
@property (nonatomic, strong) User *user;
@end

@implementation ProfileViewController

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
    
    [self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    [self setUserValue];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"LOGOUT" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logout:(NSNotification *)notification{
    [[AppDelegate sharedAppDelegate] clearUser];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserValue{
    self.user = [AppDelegate sharedAppDelegate].me;
    self.txtTitle.text = self.user.title;
    self.txtFirstName.text = self.user.first_name;
    self.txtSurname.text = self.user.surname;
    self.txtEmail.text = self.user.email;
    self.txtContact.text = self.user.contact;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)resignAllKeypad{
    [self.txtTitle resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
    [self.txtSurname resignFirstResponder];
    [self.txtContact resignFirstResponder];
}

- (IBAction)clickedSaveChanges:(id)sender {
    [self resignAllKeypad];
    [[AppDelegate sharedAppDelegate] startLoadingView];
    [self.connection editUserProfileTitle:self.txtTitle.text FirstName:self.txtFirstName.text Surname:self.txtSurname.text Mobile:self.txtContact.text];
}

- (IBAction)clickedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedHelp:(id)sender {
}

- (IBAction)clickedTitle:(id)sender {
    [self resignAllKeypad];
    self.viewPickerTitle.hidden = NO;
}

//-- UIPicker delegate methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row==0) {
        return  @"Mr";
    }
    else if(row == 1){
        return @"Mrs";
    }
    else if(row == 2){
        return @"Ms";
    }
    else if(row == 3){
        return @"Miss";
    }
    else if(row == 4){
        return @"Dr";
    }
    else{
        return @"Prof";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row==0) {
        self.txtTitle.text =  @"Mr";
    }
    else if(row == 1){
        self.txtTitle.text = @"Mrs";
    }
    else if(row == 2){
        self.txtTitle.text = @"Ms";
    }
    else if(row == 3){
        self.txtTitle.text = @"Miss";
    }
    else if(row == 4){
        self.txtTitle.text = @"Dr";
    }
    else if(row == 5){
        self.txtTitle.text = @"Prof";
    }
    self.viewPickerTitle.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.viewPickerTitle.hidden = YES;
    if (self.view.frame.size.height<=480) {
        if ([self.txtContact isEqual:textField]) {
            [self.scrollViewProfile setContentOffset:CGPointMake(0, 80) animated:YES];
        }
        else{
            [self.scrollViewProfile setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.txtTitle]) {
        [self.txtFirstName becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtFirstName]){
        [self.txtSurname becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtSurname]){
        [self.txtContact becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtContact]){
        [self.scrollViewProfile setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.txtContact resignFirstResponder];
    }
    return YES;
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        [AppDelegate sharedAppDelegate].me = nil;
        [AppDelegate sharedAppDelegate].me = [[User alloc] initWithDict:[response valueForKey:@"response"]];
        [self setUserValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"open_home" object:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[response valueForKey:@"result"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
