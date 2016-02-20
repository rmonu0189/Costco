//
//  FacebookManager.m
//  DealTApp
//
//  Created by Mac Book on 26/11/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookManager
@synthesize delegate;

#pragma mark - Shared Manager -
+ (FacebookManager* ) sharedManager{
    static FacebookManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FacebookManager alloc] init];
    });
    
    return _sharedClient;
}

#pragma mark- Facebook
-(void)facebookLogin
{
    if (FBSession.activeSession.isOpen) {
        // login is integrated with the send button -- so if open, we send
        [self sendfacebookRequests];
    } else {
        NSArray *permissionsNeeded = @[@"publish_actions"];
        [FBSession openActiveSessionWithReadPermissions:permissionsNeeded
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                              message:error.localizedDescription
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              [self LogoutFacebook];
                                              
                                              // if otherwise we check to see if the session is open, an alternative to
                                              // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
                                              // property of the session object; the macros are useful, however, for more
                                              // detailed state checking for FBSession objects
                                          }
                                          else if (FB_ISSESSIONOPENWITHSTATE(status))
                                          {
                                              // send our requests if we successfully logged in
                                              [self sendfacebookRequests];
                                          }
                                          else if(status == FBSessionStateClosedLoginFailed)
                                          {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed!"
                                                                                              message:@"Unable to login!"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              
                                          }
                                      }];
    }
    
    
}
-(void)sendfacebookRequests
{
        /* make the API call */
    [FBRequestConnection startWithGraphPath:@"me?fields=id,name,first_name,last_name,email"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if (error==nil) {
                                  if([result isKindOfClass:[NSDictionary class]])
                                  {
                                      
                                      [self performSelectorOnMainThread:@selector(FBLoginSuccess:) withObject:result waitUntilDone:NO];
                                  }
                              }
                              else{
                                  [self performSelectorOnMainThread:@selector(FBLoginFailed:) withObject:error waitUntilDone:NO];
                              }
                          }];
}

- (void)FBLoginSuccess:(id)result{
    NSLog(@"%@",result);
    if ([self.delegate respondsToSelector:@selector(FBResultSuccess:andError:)]) {
        [self.delegate FBResultSuccess:result andError:nil];
    }
}

- (void)FBLoginFailed:(NSError *)error{
    NSLog(@"%@",error);
    if ([self.delegate respondsToSelector:@selector(FBResultSuccess:andError:)]) {
        [self.delegate FBResultSuccess:nil andError:error];
    }
}

-(void)LogoutFacebook
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
}



@end
