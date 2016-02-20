//
//  Notification.m
//  RenewalReminder
//
//  Created by MonuRathor on 01/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (id)init{
    self = [super init];
    if (self) {
        self.notificationDateFormatter = [[NSDateFormatter alloc] init];
        [self.notificationDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [self.notificationDateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        self.defaultdateFormatter = [[NSDateFormatter alloc] init];
        [self.defaultdateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [self.defaultdateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        self.calenderdateFormate = [[NSDateFormatter alloc] init];
        [self.calenderdateFormate setTimeZone:[NSTimeZone systemTimeZone]];
        [self.calenderdateFormate setDateFormat:@"yyyy-MM-dd"];
        
        self.calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.calender.timeZone = [NSTimeZone systemTimeZone];
    }
    return self;
}

- (NSString *)getPreviousDate:(NSInteger)day withDate:(NSString *)strCurrentDate{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.timeZone = [NSTimeZone systemTimeZone];
    components.day = day;
    NSDate *d = [self.calender dateByAddingComponents:components toDate:[self.calenderdateFormate dateFromString:strCurrentDate] options:0];
    return [[self.calenderdateFormate stringFromDate:d] stringByAppendingFormat:@" %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"alert_time"]];
}

- (void)addNotification:(NSDictionary *)alertRenewal{
    if ([self isEnableNotification])
    {
        NSLog(@"Notifications Enabled");
        NSString *strDate = [[[alertRenewal valueForKey:@"renewal_date"] componentsSeparatedByString:@" "] firstObject];
        [self addNotificationByDate:[self.notificationDateFormatter dateFromString:[self getPreviousDate:-2 withDate:strDate]] Renewal:alertRenewal Days:2];
        [self addNotificationByDate:[self.notificationDateFormatter dateFromString:[self getPreviousDate:-14 withDate:strDate]] Renewal:alertRenewal Days:14];
        [self addNotificationByDate:[self.notificationDateFormatter dateFromString:[self getPreviousDate:-30 withDate:strDate]] Renewal:alertRenewal Days:30];
    }
    else
    {
        NSLog(@"Notifications not Enabled");
    }
}

- (BOOL)isEnableNotification{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){ // Check it's iOS 8 and above
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (grantedSettings.types == UIUserNotificationTypeNone) {
            return NO;
        }
        else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){
            return YES;
        }
        else if (grantedSettings.types  & UIUserNotificationTypeAlert){
            return YES;
        }
    }
    else{
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types == UIRemoteNotificationTypeNone)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

- (void)deleteNotification:(NSDictionary *)alertRenewal{
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *dict = notification.userInfo;
        if ([[dict valueForKey:@"rid"] integerValue] == [[alertRenewal valueForKey:@"rid"] integerValue]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (void)editNotification:(NSDictionary *)alertRenewal{
    [self deleteNotification:alertRenewal];
    [self addNotification:alertRenewal];
}

- (void)resetAllNotification{
    for (NSDictionary *record in [AppDelegate sharedAppDelegate].renewalsList30Days) {
        [self addNotification:record];
    }
    for (NSDictionary *record in [AppDelegate sharedAppDelegate].renewalsListOther) {
        [self addNotification:record];
    }
    [[AppDelegate sharedAppDelegate] stopLoadingView];
}

- (void)cancelAllNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)addNotificationByDate:(NSDate *)date Renewal:(NSDictionary *)alertRenewal Days:(int)days{
    if([date compare:[NSDate date]] == NSOrderedDescending){
        NSLog(@"Added Notification Date: %@",[self.notificationDateFormatter stringFromDate:date]);
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = [NSString stringWithFormat:@"%d days are due for renewal \"%@\"",days,[alertRenewal valueForKey:@"type"]];
        localNotification.alertAction = @"Renewal";
        localNotification.userInfo = @{@"rid" : [alertRenewal valueForKey:@"rid"]};
        localNotification.timeZone = [NSTimeZone systemTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else{
        NSLog(@"Not Notification Date: %@",[self.notificationDateFormatter stringFromDate:date]);
    }
}





//30,14,2

@end
