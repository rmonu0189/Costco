//
//  AddRenewalViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 28/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "AddRenewalViewController.h"
#import "RequestConnection.h"
#import "CategoryVC.h"

@interface AddRenewalViewController ()<UIPickerViewDelegate, UITextViewDelegate, RequestConnectionDelegate, CategoryVCDelegate>
{
    
    BOOL isSelectStartDate,isSelectRenewalDate;
    NSMutableArray *arrTypes;
    int selectTypeIndex;
    int requestType;
}
@property (nonatomic, strong) RequestConnection *connection;
@end

@implementation AddRenewalViewController

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
    self.viewPicker.hidden = YES;
    self.typePicker.hidden = YES;
    self.datePicker.hidden = YES;
    self.typePicker.backgroundColor = [UIColor grayColor];
    self.datePicker.backgroundColor = [UIColor grayColor];
    
    [self.datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    requestType = 1;
    [[AppDelegate sharedAppDelegate] startLoadingView];
    [self.connection getTypeAndCategory];
    
    arrTypes = [[AppDelegate sharedAppDelegate].typeCatgory mutableCopy];
    
    if (self.root != nil) {
        [self setRootValue];
        [self.btnAddEdit setTitle:@"SAVE" forState:UIControlStateNormal];
    }
    else{
        [self.btnAddEdit setTitle:@"DONE" forState:UIControlStateNormal];
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtPrice.inputAccessoryView = numberToolbar;
    
}

- (void)nextWithNumberPad{
    [self.txtNotes becomeFirstResponder];
}

- (void)setRootValue{
    self.txtStartDate.text = [[AppDelegate sharedAppDelegate] convertDateFormate:[self.root valueForKey:@"start_date"]];
    self.txtRenewaldate.text = [[AppDelegate sharedAppDelegate] convertDateFormate:[self.root valueForKey:@"renewal_date"]];
    self.txtProvider.text = [self.root valueForKey:@"provider"];
    self.txtPrice.text = [self.root valueForKey:@"price"];
    self.txtNotes.text = [self.root valueForKey:@"notes"];
    self.txtType.text = [self.root valueForKey:@"type"];
    self.txtNotes.textColor = [UIColor colorWithRed:65.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.btnAddEdit setTitle:@"Done" forState:UIControlStateNormal];
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

- (void)hiddenPickerView{
    self.viewPicker.hidden = YES;
    self.typePicker.hidden = YES;
    self.datePicker.hidden = YES;
}

- (void)showDatePicker{
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 568)];
    self.typePicker.hidden = YES;
    self.viewPicker.hidden = NO;
    self.datePicker.hidden = NO;
    [self.txtProvider resignFirstResponder];
    [self.txtPrice resignFirstResponder];
    [self.txtNotes resignFirstResponder];
}

- (void)showTypePicker{
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 568)];
//    if (self.txtType.text.length<=0) {
//        self.txtType.text =  @"Home";
//    }
//    self.viewPicker.hidden = NO;
//    self.typePicker.hidden = NO;
//    self.datePicker.hidden = YES;
    [self performSegueWithIdentifier:@"category_list" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (IBAction)clickedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedAdd:(id)sender {
    if ([self validate]) {
        requestType = 2;
        [[AppDelegate sharedAppDelegate] startLoadingView];
        if ([self.btnAddEdit.titleLabel.text isEqual:@"SAVE"]) {
            [self.connection editRenewal:self.renewalID UserID:[AppDelegate sharedAppDelegate].me.userID Type:self.txtType.text StartDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] RenewalDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewaldate.text] provider:self.txtProvider.text Price:self.txtPrice.text Notes:self.txtNotes.text Category:[[arrTypes objectAtIndex:selectTypeIndex] valueForKey:@"id"]];
        }
        else{
            [self.connection addRenewal:[AppDelegate sharedAppDelegate].me.userID Type:self.txtType.text Category:[[arrTypes objectAtIndex:selectTypeIndex] valueForKey:@"id"] StartDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] RenewalDate:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewaldate.text] provider:self.txtProvider.text Price:self.txtPrice.text Notes:self.txtNotes.text];
        }
    }
}

- (BOOL)validate{
    NSString *error = @"";
    if (self.txtType.text.length<=0) {
        error = @"Please select type.";
    }
    else if (self.txtStartDate.text.length<=0) {
        error = @"Please select start date.";
    }
    else if (self.txtRenewaldate.text.length<=0) {
        error = @"Please select renewal date.";
    }
    else if (self.txtProvider.text.length<=0) {
        error = @"Please enter provider.";
    }
    
    if (error.length>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else{
        return YES;
    }
}

- (IBAction)clickedType:(id)sender {
    [self showTypePicker];
}

- (IBAction)clickedRenewalDate:(id)sender {
    isSelectRenewalDate = YES;
    isSelectStartDate = NO;
    if (self.txtRenewaldate.text.length > 0) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateStyle:NSDateFormatterFullStyle];
        [f setTimeZone:[NSTimeZone systemTimeZone]];
        [f setDateFormat:@"EEEE, d MMMM, yyyy"];
        self.datePicker.date = [f dateFromString:self.txtRenewaldate.text];
    }
    [self showDatePicker];
}

- (IBAction)clickedStartDate:(id)sender {
    isSelectStartDate = YES;
    isSelectRenewalDate = NO;
    if (self.txtStartDate.text.length > 0) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateStyle:NSDateFormatterFullStyle];
        [f setTimeZone:[NSTimeZone systemTimeZone]];
        [f setDateFormat:@"EEEE, d MMMM, yyyy"];
        self.datePicker.date = [f dateFromString:self.txtStartDate.text];
    }
    [self showDatePicker];
}

- (IBAction)clickedHelp:(id)sender {
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
        self.txtRenewaldate.text = [f stringFromDate:self.datePicker.date];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenPickerView];
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 800)];
    if ([textField isEqual:self.txtProvider]) {
        [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 86) animated:YES];
    }
    else if ([textField isEqual:self.txtPrice]){
        [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 130) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.txtProvider]) {
        [self.txtPrice becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtPrice]){
        [self.txtNotes becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self hiddenPickerView];
    [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 800)];
    [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 200) animated:YES];
    if ([self.txtNotes.text isEqualToString:@"- add your notes here -"]) {
        self.txtNotes.text = @"";
        self.txtNotes.textColor = [UIColor colorWithRed:65.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length<=0) {
        self.txtNotes.text = @"- add your notes here -";
        self.txtNotes.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self hiddenPickerView];
        [self.scrollViewAddRenewal setContentSize:CGSizeMake(320, 568)];
        [self.scrollViewAddRenewal setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.txtNotes resignFirstResponder];
        return NO;
    }
    return YES;
}

//-- UIPicker delegate methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arrTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[arrTypes objectAtIndex:row] valueForKey:@"type"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.txtType.text = [[arrTypes objectAtIndex:row] valueForKey:@"type"];
    selectTypeIndex = (int)row;
}

- (void)selectedCategory:(NSDictionary *)category Index:(NSInteger)index{
    self.txtType.text = [category valueForKey:@"type"];
    selectTypeIndex = (int)index;
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (requestType == 1) {
        NSLog(@"%@",response);
//        arrTypes = (NSMutableArray *)response;
//        
//        [self.typePicker reloadAllComponents];
        return;
    }
    if (!error) {
        [AppDelegate sharedAppDelegate].editRenewalData = [NSMutableDictionary dictionary];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtStartDate.text] forKeyPath:@"start_date"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[[AppDelegate sharedAppDelegate] convertOriginalDate:self.txtRenewaldate.text] forKeyPath:@"renewal_date"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtProvider.text forKeyPath:@"provider"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtPrice.text forKeyPath:@"price"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtNotes.text forKeyPath:@"notes"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:self.txtType.text forKeyPath:@"type"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[[arrTypes objectAtIndex:selectTypeIndex] valueForKey:@"category"] forKeyPath:@"category"];
        [[AppDelegate sharedAppDelegate].editRenewalData setValue:[self.root valueForKey:@"rid"] forKeyPath:@"rid"];
        NSLog(@"%@",[AppDelegate sharedAppDelegate].editRenewalData);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([[segue destinationViewController] isKindOfClass:[CategoryVC class]]) {
         CategoryVC *cvc = (CategoryVC *)[segue destinationViewController];
         cvc.delegate = self;
     }
 }
 

@end
