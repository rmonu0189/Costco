//
//  SettingViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 01/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "SettingViewController.h"
#import "SWRevealViewController.h"
#import "Notification.h"

@interface SettingViewController ()
{
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, strong) Notification *localNotification;
@end

@implementation SettingViewController

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
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.viewTimePicker.hidden = YES;
    
    self.localNotification = [[Notification alloc] init];
    
    NSString *strTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"alert_time"];
    
    if (strTime.length > 0) {
        self.lblTime.text = strTime;
        if ([dateFormatter dateFromString:self.lblTime.text] != nil) {
            self.datePicker.date = [dateFormatter dateFromString:self.lblTime.text];
        }
    }
    
    self.btnAlertOnOff.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"alert_switch"];
    [self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (IBAction)clickedSetAlertTime:(id)sender {
    self.viewTimePicker.hidden = NO;
}


- (IBAction)clickedTimePickerDone:(id)sender {
    self.lblTime.text = [dateFormatter stringFromDate:self.datePicker.date];
    [[NSUserDefaults standardUserDefaults] setValue:self.lblTime.text forKey:@"alert_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.viewTimePicker.hidden = YES;
    [[AppDelegate sharedAppDelegate] startLoadingView];
    [self.localNotification cancelAllNotification];
    [self.localNotification resetAllNotification];
}

- (IBAction)clickedAlertOnOff:(id)sender {
    if (self.btnAlertOnOff.on) {
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.localNotification resetAllNotification];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alert_switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        [self.localNotification cancelAllNotification];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alert_switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
