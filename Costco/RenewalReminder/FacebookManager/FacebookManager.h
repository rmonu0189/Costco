//
//  FacebookManager.h
//  DealTApp
//
//  Created by Mac Book on 26/11/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FacebookManagerDelegate <NSObject>

- (void)FBResultSuccess:(id)result andError:(NSError *)error;

@end

@interface FacebookManager : NSObject
{
    __weak id<FacebookManagerDelegate> delegate;
}
@property (nonatomic, weak) id<FacebookManagerDelegate> delegate;

+(FacebookManager *) sharedManager;
-(void)facebookLogin;
-(void)LogoutFacebook;
@end
