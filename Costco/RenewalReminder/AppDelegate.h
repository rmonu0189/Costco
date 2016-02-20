//
//  AppDelegate.h
//  RenewalReminder
//
//  Created by MonuRathor on 26/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSDateFormatter *dateFormatter,*convertDateFormate;
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, strong) NSMutableArray *renewalsList30Days;
@property (nonatomic, strong) NSMutableArray *renewalsListOther;
@property (nonatomic, strong) NSMutableArray *typeCatgory;
@property (nonatomic, strong) User *me;
@property (nonatomic, strong) NSMutableDictionary *editRenewalData;

+(AppDelegate *)sharedAppDelegate;
- (void)startLoadingView;
- (void)stopLoadingView;

- (void)saveUser:(NSDictionary *)dict;
- (void)loadUser;
- (void)clearUser;
- (NSInteger)getDifferenceFromTodayTo:(NSString *)end;
- (NSString *)convertDateFormate:(NSString *)strDate;
- (NSString *)convertOriginalDate:(NSString *)date;
@property (nonatomic, strong) NSOperationQueue *queue;
- (NSString *)getTypeImageLogoName:(NSString *)strType;
- (NSString *)getTypeImageBackName:(NSString *)strType;
- (void)setImageFromURL:(NSString *)imageURL ImageView:(UIImageView *)imageView withUniqueValue:(NSInteger)unique;

@end
