//
//  User.h
//  RenewalReminder
//
//  Created by Monu on 31/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * loginID;
@property (nonatomic, retain) NSString * login_type;

+ ( id ) me;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end
