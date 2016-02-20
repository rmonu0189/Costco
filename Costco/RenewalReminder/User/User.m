//
//  User.m
//  RenewalReminder
//
//  Created by Monu on 31/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "User.h"

@implementation User

+ ( id )me
{
    __strong static User*     sharedObject = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once( &onceToken, ^{
        sharedObject = [ [ User alloc ] init ] ;
    } ) ;
    
    return sharedObject ;
}


- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    if( self )
    {
        [self setUserID:[_dict objectForKey:@"uid"]];
        [self setTitle:[_dict objectForKey:@"title"]];
        [self setFirst_name:[_dict objectForKey:@"firstname"]];
        [self setSurname:[_dict objectForKey:@"surname"]];
        [self setEmail:[_dict objectForKey:@"email"]];
        //[self setPassword:[_dict objectForKey:@"user_password"]];
        [self setContact:[_dict objectForKey:@"contact"]];
        [self setLoginID:[_dict objectForKey:@"email"]]; //TODO: change email with Login ID
        [self setLogin_type:[_dict objectForKey:@"user_type"]];
    }
    return self ;
    
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.userID            forKey:@"user_id"];
    [encoder encodeObject:self.title            forKey:@"user_title"];
    [encoder encodeObject:self.first_name       forKey:@"user_first_name"];
    [encoder encodeObject:self.surname          forKey:@"user_surname"];
    [encoder encodeObject:self.email            forKey:@"user_email"];
    //[encoder encodeObject:self.password         forKey:@"user_password"];
    [encoder encodeObject:self.contact          forKey:@"user_contact"];
    [encoder encodeObject:self.loginID          forKey:@"user_login_id"];
    [encoder encodeObject:self.login_type       forKey:@"user_login_type"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.userID          = [decoder decodeObjectForKey:@"user_id"];
        self.title          = [decoder decodeObjectForKey:@"user_title"];
        self.first_name     = [decoder decodeObjectForKey:@"user_first_name"];
        self.surname        = [decoder decodeObjectForKey:@"user_surname"];
        self.email          = [decoder decodeObjectForKey:@"user_email"];
        //self.password       = [decoder decodeObjectForKey:@"user_password"];
        self.contact        = [decoder decodeObjectForKey:@"user_contact"];
        self.loginID        = [decoder decodeObjectForKey:@"user_login_id"];
        self.login_type     = [decoder decodeObjectForKey:@"user_login_type"];
    }
    return self;
}


@end
