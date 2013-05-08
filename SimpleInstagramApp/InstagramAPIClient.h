//
//  InstagramAPIClient.h
//  SimpleInstagramApp
//
//  Created by Danil on 09.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "AFHTTPClient.h"

typedef enum LoginStatus{
	LoginStatusSuccessfully = -1,
	LoginStatusFailed,
} LoginStatusEnum;

@protocol IGSessionDelegate <NSObject>

-(void)igDidLogin;

-(void)igDidNotLogin:(BOOL)cancelled;

-(void)igDidLogout;

-(void)igSessionInvalidated;

@end

@interface InstagramAPIClient : AFHTTPClient{
     void(^loginStatusBlock)(LoginStatusEnum);
}

@property(nonatomic, strong) NSString* clientId;
@property(nonatomic, strong) NSArray* scopes;
@property(nonatomic, strong) NSString* accessToken;


+ (InstagramAPIClient *)sharedClient;
-(void)setLoginStatusBlock:(void(^)(LoginStatusEnum))block;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)loginWithClientId:(NSString *)clientId andPermisions:(NSArray*)permisions;

@end
