//
//  RenewalViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 30/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "RenewalViewController.h"
#import "Notification.h"
#import "RequestConnection.h"
#import "AddRenewalViewController.h"
#import <Social/Social.h>

@interface RenewalViewController ()< RequestConnectionDelegate>
{
    BOOL isSelectStartDate,isSelectRenewalDate;
}
@property (nonatomic, strong) RequestConnection *connection;

@end

@implementation RenewalViewController

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
    self.typePicker.backgroundColor = [UIColor grayColor];
    self.datePicker.backgroundColor = [UIColor grayColor];
    [self.datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenPickerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"LOGOUT" object:nil];
    if ([AppDelegate sharedAppDelegate].editRenewalData != nil) {
        self.root = [AppDelegate sharedAppDelegate].editRenewalData;
        [AppDelegate sharedAppDelegate].editRenewalData = nil;
    }
    [self setRootValue];
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

- (void)setRootValue{
    self.txtStartDate.text = [[AppDelegate sharedAppDelegate] convertDateFormate:[self.root valueForKey:@"start_date"]];
    self.txtRenewalDate.text = [[AppDelegate sharedAppDelegate] convertDateFormate:[self.root valueForKey:@"renewal_date"]];
    self.txtYouAreWith.text = [self.root valueForKey:@"provider"];
    self.lblYouWith.text = [self.root valueForKey:@"provider"];
    self.txtYouPaid.text = [self.root valueForKey:@"price"];
    self.txtNotes.text = [self.root valueForKey:@"notes"];
    self.txtType.text = [self.root valueForKey:@"type"];
    self.lblReminderType.text = [self.root valueForKey:@"type"];
    NSInteger days = [[AppDelegate sharedAppDelegate] getDifferenceFromTodayTo:[[[self.root valueForKey:@"renewal_date"] componentsSeparatedByString:@" "] firstObject]];
    if (days == 0) {
        self.txtDueDate.text = @"Today";
        self.lblNumberOfRemainDays.text = @"0";
    }
    else{
        self.txtDueDate.text = [NSString stringWithFormat:@"%d days",(int)days];
        self.lblNumberOfRemainDays.text = [NSString stringWithFormat:@"%d",(int)days];
    }
    self.txtNotes.textColor = [UIColor whiteColor];
    self.imgTypeIcon.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageLogoName:[self.root valueForKey:@"category"]]];
    self.imgTypeBackground.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageBackName:[self.root valueForKey:@"category"]]];
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenPickerView];
    [self.scrollViewRenewal setContentSize:CGSizeMake(320, 800)];
    if ([textField isEqual:self.txtYouAreWith]) {
        [self.scrollViewRenewal setContentOffset:CGPointMake(0, 86) animated:YES];
    }
    else if ([textField isEqual:self.txtYouPaid]){
        [self.scrollViewRenewal setContentOffset:CGPointMake(0, 130) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.txtYouAreWith]) {
        [self.txtYouPaid becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtYouPaid]){
        [self.txtNotes becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self hiddenPickerView];
    [self.scrollViewRenewal setContentSize:CGSizeMake(320, 800)];
    [self.scrollViewRenewal setContentOffset:CGPointMake(0, 200) animated:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self hiddenPickerView];
        [self.scrollViewRenewal setContentSize:CGSizeMake(320, 568)];
        [self.scrollViewRenewal setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.txtNotes resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)hiddenPickerView{
    self.viewPicker.hidden = YES;
    self.typePicker.hidden = YES;
    self.datePicker.hidden = YES;
}

- (void)showDatePicker{
    [self.scrollViewRenewal setContentSize:CGSizeMake(320, 568)];
    self.typePicker.hidden = YES;
    self.viewPicker.hidden = NO;
    self.datePicker.hidden = NO;
    [self.txtYouAreWith resignFirstResponder];
    [self.txtYouPaid resignFirstResponder];
    [self.txtNotes resignFirstResponder];
}

- (void)showTypePicker{
    [self.scrollViewRenewal setContentSize:CGSizeMake(320, 568)];
    if (self.txtType.text.length<=0) {
        self.txtType.text =  @"Home";
    }
    self.viewPicker.hidden = NO;
    self.typePicker.hidden = NO;
    self.datePicker.hidden = YES;
}

- (IBAction)clickedPickerDone:(id)sender {
    NSLog(@"%@",self.datePicker.date);
    [self hiddenPickerView];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterFullStyle];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:@"EEEE, d MMMM, yyyy"];
    if (isSelectStartDate) {
        self.txtStartDate.text = [f stringFromDate:self.datePicker.date];
    }
    else if(isSelectRenewalDate){
        self.txtRenewalDate.text = [f stringFromDate:self.datePicker.date];
    }
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
    if (row == 0) {
        return @"Home";
    }
    else if (row == 1){
        return @"Insurance";
    }
    else if (row == 2){
        return @"Lifestyle";
    }
    else if (row == 3){
        return @"Motoring";
    }
    else if (row == 4){
        return @"Travel";
    }
    else if (row == 5){
        return @"Utilities & Service";
    }
    else{
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        self.txtType.text =  @"Home";
    }
    else if (row == 1){
        self.txtType.text =  @"Insurance";
    }
    else if (row == 2){
        self.txtType.text =  @"Lifestyle";
    }
    else if (row == 3){
        self.txtType.text =  @"Motoring";
    }
    else if (row == 4){
        self.txtType.text =  @"Travel";
    }
    else if (row == 5){
        self.txtType.text =  @"Utilities & Service";
    }
    self.imgTypeIcon.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageLogoName:self.txtType.text]];
    self.imgTypeBackground.image = [UIImage imageNamed:[[AppDelegate sharedAppDelegate] getTypeImageBackName:self.txtType.text]];
}

- (IBAction)clickedEditRenewal:(id)sender {
//    [[AppDelegate sharedAppDelegate] startLoadingView];
//    [self.connection editRenewal:[self.root valueForKey:@"rid"] UserID:[AppDelegate sharedAppDelegate].me.userID Type:self.txtType.text StartDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] RenewalDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewalDate.text] provider:self.txtYouAreWith.text Price:self.txtYouPaid.text Notes:self.txtNotes.text];
}

- (IBAction)clickedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedDeleteRenewal:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to delete this renewal?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"Renewal ID :::: %@", self.renewalID);
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection deleteRenewalWithID:self.renewalID];
    }
}

- (IBAction)clickedRenewalType:(id)sender {
    //[self showTypePicker];
}

- (IBAction)clickedStartedDate:(id)sender {
    isSelectStartDate = YES;
    isSelectRenewalDate = NO;
    [self showDatePicker];
}

- (IBAction)clickedRenewalDate:(id)sender {
    isSelectRenewalDate = YES;
    isSelectStartDate = NO;
    [self showDatePicker];
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[response valueForKey:@"result"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        if ([[response valueForKey:@"method"] isEqualToString:@"DELETE_RENEWAL"]) {
            Notification *noti = [[Notification alloc] init];
            [noti deleteNotification:self.root];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[AddRenewalViewController class]]) {
        [AppDelegate sharedAppDelegate].editRenewalData = nil;
        AddRenewalViewController *addRenewal = [segue destinationViewController];
        addRenewal.renewalID = self.renewalID;
        addRenewal.root = self.root;
    }
}

- (IBAction)shareOnFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [vc addImage:[UIImage imageNamed:@"share.png"]];
        [vc setInitialText:[NSString stringWithFormat:@"%@ days till my %@ is due.",self.lblNumberOfRemainDays.text,self.lblReminderType.text]];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings and add your Facebook account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)shareOnTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [vc addImage:[UIImage imageNamed:@"share.png"]];
        [vc setInitialText:[NSString stringWithFormat:@"%@ days till my %@ is due.",self.lblNumberOfRemainDays.text,self.lblReminderType.text]];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"It seems that we cannot talk to Twitter at the moment or you have not yet added your Twitter account to this device. Go to the Settings and add your Twitter account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
