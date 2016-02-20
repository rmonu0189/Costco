//
//  AddRenewalViewController.h
//  RenewalReminder
//
//  Created by MonuRathor on 28/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRenewalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtRenewaldate;
@property (weak, nonatomic) IBOutlet UITextField *txtProvider;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewAddRenewal;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDictionary *root;
@property (nonatomic, retain) NSString *renewalID;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEdit;

- (IBAction)clickedCancel:(id)sender;
- (IBAction)clickedAdd:(id)sender;
- (IBAction)clickedType:(id)sender;
- (IBAction)clickedRenewalDate:(id)sender;
- (IBAction)clickedStartDate:(id)sender;
- (IBAction)clickedHelp:(id)sender;
- (IBAction)clickedPickerDone:(id)sender;

@end
