//
//  RequestConnection.m
//  RenewalReminder
//
//  Created by MonuRathor on 25/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "RequestConnection.h"

//-- Local server
//#define SERVER @"http://localhost:8888/renewal/mobile.php"

//-- Live server
#define SERVER @"http://reminder.premiumsaver.co.uk/mobileuser/mobile.php"



@interface RequestConnection ()
{
    NSOperationQueue *queue;
}
@end

@implementation RequestConnection
@synthesize delegate;

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
          andLoginType:(NSString *)loginType{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"SIGN_UP" forKeyPath:@"action"];
    [param setValue:title forKeyPath:@"title"];
    [param setValue:fName forKeyPath:@"first_name"];
    [param setValue:surname forKeyPath:@"surname"];
    [param setValue:email forKeyPath:@"email"];
    [param setValue:password forKeyPath:@"password"];
    [param setValue:mobile forKeyPath:@"contact"];
    [param setValue:loginID forKeyPath:@"loginID"];
    [param setValue:loginType forKeyPath:@"login_type"];
    [self makePostRequestWithParam:param];
    
}

/**
 *  Method to use login user
 */
- (void)loginUser:(NSString *)loginID
         Password:(NSString *)password
     andLoginType:(NSString *)loginType{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"LOGIN" forKeyPath:@"action"];
    [param setValue:password forKeyPath:@"password"];
    [param setValue:loginID forKeyPath:@"loginID"];
    [param setValue:loginType forKeyPath:@"login_type"];
    [self makePostRequestWithParam:param];
    
}

/**
 *  Method to use for forgot password
 */
- (void)forgotPassword:(NSString *)email{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"FORGOT_PASSWORD" forKeyPath:@"action"];
    [param setValue:email forKeyPath:@"email"];
    [self makePostRequestWithParam:param];
}

- (void)addRenewal:(NSString *)userID
              Type:(NSString *)type
          Category:(NSString *)category
         StartDate:(NSString *)startDate
       RenewalDate:(NSString *)renewalDate
          provider:(NSString *)provider
             Price:(NSString *)price
             Notes:(NSString *)notes
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"ADD_RENEWAL" forKeyPath:@"action"];
    [param setValue:userID forKeyPath:@"uid"];
    [param setValue:category forKeyPath:@"category"];
    [param setValue:type forKeyPath:@"type"];
    [param setValue:startDate forKeyPath:@"start_date"];
    [param setValue:renewalDate forKeyPath:@"renewal_date"];
    [param setValue:provider forKeyPath:@"provider"];
    [param setValue:price forKeyPath:@"price"];
    [param setValue:notes forKeyPath:@"notes"];
    [self makePostRequestWithParam:param];
}

- (void)editRenewal:(NSString *)rid
             UserID:(NSString *)userID
              Type:(NSString *)type
         StartDate:(NSString *)startDate
       RenewalDate:(NSString *)renewalDate
          provider:(NSString *)provider
             Price:(NSString *)price
             Notes:(NSString *)notes
           Category:(NSString *)category
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"UPDATE_RENEWAL" forKeyPath:@"action"];
    [param setValue:rid forKeyPath:@"rid"];
    [param setValue:userID forKeyPath:@"uid"];
    [param setValue:type forKeyPath:@"type"];
    [param setValue:startDate forKeyPath:@"start_date"];
    [param setValue:renewalDate forKeyPath:@"renewal_date"];
    [param setValue:provider forKeyPath:@"provider"];
    [param setValue:price forKeyPath:@"price"];
    [param setValue:notes forKeyPath:@"notes"];
    [param setValue:category forKeyPath:@"category"];
    [self makePostRequestWithParam:param];
}

- (void)deleteRenewalWithID:(NSString *)rid
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"DELETE_RENEWAL" forKeyPath:@"action"];
    [param setValue:rid forKeyPath:@"rid"];
    [param setValue:[AppDelegate sharedAppDelegate].me.userID forKeyPath:@"uid"];
    [self makePostRequestWithParam:param];
}


- (void)getRenewalsList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GET_RENEWAL_LIST" forKeyPath:@"action"];
    [param setValue:[AppDelegate sharedAppDelegate].me.userID forKeyPath:@"uid"];
    [param setValue:@"2" forKeyPath:@"app_type"];
    [self makePostRequestWithParam:param];
}

- (void)editUserProfileTitle:(NSString *)title
                   FirstName:(NSString *)fName
                     Surname:(NSString *)surname
                      Mobile:(NSString *)mobile{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"UPDATE_PROFILE" forKeyPath:@"action"];
    [param setValue:[AppDelegate sharedAppDelegate].me.userID forKeyPath:@"uid"];
    [param setValue:title forKeyPath:@"title"];
    [param setValue:fName forKeyPath:@"first_name"];
    [param setValue:surname forKeyPath:@"surname"];
    [param setValue:mobile forKeyPath:@"contact"];
    [self makePostRequestWithParam:param];
}

- (void)changePassword:(NSString *)oldPass NewPassword:(NSString *)newPas{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"CHANGE_PASSWORD" forKeyPath:@"action"];
    [param setValue:[AppDelegate sharedAppDelegate].me.userID forKeyPath:@"uid"];
    [param setValue:oldPass forKeyPath:@"old_password"];
    [param setValue:newPas forKeyPath:@"new_password"];
    [self makePostRequestWithParam:param];
}

- (void)getTypeAndCategory{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GET_TYPE_CATEGORY" forKeyPath:@"action"];
    [param setValue:@"2" forKeyPath:@"app_type"];
    [self makePostRequestWithParam:param];
}

- (void)makePostRequestWithParam:(NSDictionary *)param{
    NSString *parameterString = @"";
    for (NSString *aKey in [param allKeys]) {
        parameterString = [parameterString stringByAppendingFormat:@"&%@=%@",aKey,[param valueForKey:aKey]];
    }
    parameterString = [parameterString stringByAppendingFormat:@"&%@=%@",@"2",@"brand"];
    NSData *postData = [parameterString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:SERVER]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [self startConnection:request];
}

- (void)startConnection:(NSURLRequest *)request{
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (!connectionError) {
            [self performSelectorOnMainThread:@selector(connectionSuccess:) withObject:data waitUntilDone:NO];
        }
        else{
            [self performSelectorOnMainThread:@selector(connectionError:) withObject:connectionError waitUntilDone:NO];
        }
    }];
}

- (void)connectionSuccess:(id)data{
    NSError *jsonError = nil;
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (!jsonError) {
        if ([[jsonResponse valueForKey:@"status"] isEqualToString:@"success"]) {
            if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
                [self.delegate requestResultSuccess:[jsonResponse valueForKey:@"response"] andError:nil];
            }
        }
        else{
            NSError *error = [[NSError alloc] initWithDomain:@"RESPONSE_ERROR" code:1001 userInfo:@{NSLocalizedDescriptionKey:[jsonResponse valueForKey:@"response"]}];
            if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
                [self.delegate requestResultSuccess:nil andError:error];
            }
        }
    }
    else{
        NSError *error = [[NSError alloc] initWithDomain:@"JSON_PARSING_ERROR" code:1002 userInfo:@{NSLocalizedDescriptionKey:@"Error to parsing response data."}];
        if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
            [self.delegate requestResultSuccess:nil andError:error];
        }
    }
}

- (void)connectionError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
        [self.delegate requestResultSuccess:nil andError:error];
    }
}

@end
