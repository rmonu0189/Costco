//
//  RequestConnection.h
//  RenewalReminder
//
//  Created by MonuRathor on 25/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestConnectionDelegate <NSObject>

- (void)requestResultSuccess:(id)response andError:(NSError *)error;

@end

@interface RequestConnection : NSObject
{
    __weak id<RequestConnectionDelegate> delegate;
}
@property (nonatomic, weak) id<RequestConnectionDelegate> delegate;

/**
 *  Method to use register user
 *  @param loginType - 0 for Normal user, 1 for Facebook user, 2 for Twitter user
 */
- (void)registerUserID:(NSString *)loginID
                 Title:(NSString *)title
             FirstName:(NSString *)fName
               Surname:(NSString *)surname
                 Email:(NSString *)email
              Password:(NSString *)password
                Mobile:(NSString *)mobile
          andLoginType:(NSString *)loginType;

- (void)editUserProfileTitle:(NSString *)title
                   FirstName:(NSString *)fName
                     Surname:(NSString *)surname
                      Mobile:(NSString *)mobile;

/**
 *  Method to use login user
 */
- (void)loginUser:(NSString *)loginID
         Password:(NSString *)password
     andLoginType:(NSString *)loginType;

/**
 *  Method to use for forgot password
 */
- (void)forgotPassword:(NSString *)email;

- (void)addRenewal:(NSString *)userID
              Type:(NSString *)type
          Category:(NSString *)category
         StartDate:(NSString *)startDate
       RenewalDate:(NSString *)renewalDate
          provider:(NSString *)provider
             Price:(NSString *)price
             Notes:(NSString *)notes;

- (void)getRenewalsList;

- (void)editRenewal:(NSString *)rid
             UserID:(NSString *)userID
               Type:(NSString *)type
          StartDate:(NSString *)startDate
        RenewalDate:(NSString *)renewalDate
           provider:(NSString *)provider
              Price:(NSString *)price
              Notes:(NSString *)notes
           Category:(NSString *)category;

- (void)deleteRenewalWithID:(NSString *)rid;
- (void)changePassword:(NSString *)oldPass NewPassword:(NSString *)newPas;
- (void)getTypeAndCategory;

@end
