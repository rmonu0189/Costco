//
//  Notification.h
//  RenewalReminder
//
//  Created by MonuRathor on 01/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
@property (nonatomic, strong) NSDateFormatter *notificationDateFormatter,*calenderdateFormate,*defaultdateFormatter;
@property (nonatomic, strong) NSCalendar *calender; 

- (void)addNotification:(NSDictionary *)alertRenewal;
- (void)deleteNotification:(NSDictionary *)alertRenewal;
- (void)editNotification:(NSDictionary *)alertRenewal;
- (void)cancelAllNotification;
- (void)resetAllNotification;

@end
