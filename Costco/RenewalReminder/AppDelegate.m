//
//  AppDelegate.m
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate
@synthesize renewalsList30Days,renewalsListOther;

+(AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.loadingView addSubview:self.indicator];
    self.loadingView.layer.cornerRadius = 10.0f;
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.indicator.center = self.loadingView.center;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.convertDateFormate = [[NSDateFormatter alloc] init];
    [self.convertDateFormate setDateStyle:NSDateFormatterFullStyle];
    [self.convertDateFormate setTimeZone:[NSTimeZone systemTimeZone]];
    [self.convertDateFormate setDateFormat:@"EEEE, d MMMM, yyyy"];
    
    self.calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    self.renewalsList30Days = [[NSMutableArray alloc] init];
    self.renewalsListOther = [[NSMutableArray alloc] init];
    self.typeCatgory = [[NSMutableArray alloc] init];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound | UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }
    
    [self loadUser];
    [self checkSetting];
    
    return YES;
}

- (void)startLoadingView{
    if (![self.loadingView isDescendantOfView:self.window]) {
        self.window.userInteractionEnabled = NO;
        self.loadingView.center = self.window.center;
        [self.window addSubview:self.loadingView];
        [self.indicator startAnimating];
    }
    
}

- (void)stopLoadingView{
    if ([self.loadingView isDescendantOfView:self.window]) {
        self.window.userInteractionEnabled = YES;
        [self.indicator stopAnimating];
        [self.loadingView removeFromSuperview];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}

- (void)saveUser:(NSDictionary *)dict{
    self.me = [[User alloc] initWithDict:dict];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.me) {
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.me];
        [defaults setObject:myEncodedObject forKey:@"me"];
    }
    [defaults synchronize];
}

- (void)loadUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"me"]) {
        NSData *myEncodedObject = [defaults objectForKey:@"me"];
        self.me = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    }
}

- (void)clearUser{
    self.me = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"me"];
    [defaults synchronize];
}

- (NSInteger)getDifferenceFromTodayTo:(NSString *)end{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [NSDate date];
    
    
    NSString *currentDate = [f stringFromDate:[NSDate date]];
    NSLog(@"%@",startDate);
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[f dateFromString:currentDate]
                                                          toDate:[f dateFromString:end]
                                                         options:0];
    return components.day;
    
//    NSDate *endDate = [self.dateFormatter dateFromString:end];
//    NSDateComponents *components = [self.calender components:NSDayCalendarUnit fromDate:[NSDate date] toDate:endDate options:0];
//    return components.day;
}

- (NSString *)convertDateFormate:(NSString *)strDate{
    NSDate *d = [self.dateFormatter dateFromString:strDate];
    return [self.convertDateFormate stringFromDate:d];
}

- (NSString *)convertOriginalDate:(NSString *)date{
    NSDate *cdate = [self.convertDateFormate dateFromString:date];
    return [self.dateFormatter stringFromDate:cdate];
    return @"";
}

- (NSString *)getTypeImageLogoName:(NSString *)strType{
    NSString *image = @"";
    for (NSDictionary *tmp in self.typeCatgory) {
        if ([[tmp valueForKey:@"id"] integerValue] == strType.integerValue) {
            image = [tmp valueForKey:@"image"];
            break;
        }
    }
    return image;
    
    
//    if ([strType isEqualToString:@"Utilities"]) {
//        return @"utilityLogo.png";
//    }
//    else{
//        return [strType stringByAppendingString:@"Logo.png"];
//    }
}

- (NSString *)getTypeImageBackName:(NSString *)strType{
    if ([strType isEqualToString:@"Utilities"]) {
        return @"utilityBack.png";
    }
    else{
        return [strType stringByAppendingString:@"Back.png"];
    }
}

- (void)checkSetting{
    NSString *strTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"alert_time"];
    if (strTime.length <= 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"09:00 AM" forKey:@"alert_time"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alert_switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)setImageFromURL:(NSString *)imageURL ImageView:(UIImageView *)imageView withUniqueValue:(NSInteger)unique{
    imageView.tag = unique;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    if (!self.queue) self.queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *image = [UIImage imageWithData:(NSData *)data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageView.tag == unique) {
                    imageView.image = image;
                }
            });
        }
    }];
}
@end
