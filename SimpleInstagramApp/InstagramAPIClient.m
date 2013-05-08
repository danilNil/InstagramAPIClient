//
//  InstagramAPIClient.m
//  SimpleInstagramApp
//
//  Created by Danil on 09.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "InstagramAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kInstagramAPIBaseURLString = @"https://api.instagram.com/v1/";
static NSString* kInstagramBaseURL = @"https://instagram.com/";

@implementation InstagramAPIClient


+ (InstagramAPIClient *)sharedClient {
    static InstagramAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[InstagramAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kInstagramAPIBaseURLString]];
    });
    
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - Login/Logout

-(void)setLoginStatusBlock:(void(^)(LoginStatusEnum))block{
    loginStatusBlock = [block copy];
}


-(void)invalidateSession {
    self.accessToken = nil;
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:kInstagramBaseURL]];
    
    for (NSHTTPCookie* cookie in instagramCookies) {
        [cookies deleteCookie:cookie];
    }    
}


/**
 * Set the authToken after login succeed
 */
- (void)igDidLogin:(NSString *)token{
    _accessToken = token;
    [self setDefaultHeader:@"access_token" value:_accessToken];
    if (loginStatusBlock) {
        loginStatusBlock(LoginStatusSuccessfully);
    }
    
}

/**
 * Did not login call the not login delegate
 */
- (void)igDidNotLogin:(BOOL)cancelled {
    if (loginStatusBlock) {
        loginStatusBlock(LoginStatusFailed);
    }
}



-(void)loginWithClientId:(NSString *)clientId andPermisions:(NSArray*)permisions{
    self.clientId = clientId;
    self.scopes = permisions;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.clientId, @"client_id",
                                   @"token", @"response_type",
                                   [self getReturnedURL], @"redirect_uri",
                                   nil];
    
    NSString *loginDialogURL = [kInstagramBaseURL stringByAppendingString:@"oauth/authorize"];
    

    
    
    if (self.scopes != nil) {
        NSString* scope = [self.scopes componentsJoinedByString:@"+"];
        [params setValue:scope forKey:@"scope"];
    }
    NSString *igAppUrl = [self serializeURL:loginDialogURL params:params];
    
    NSLog(@"igAppUrl: %@",igAppUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:igAppUrl]];
}

- (NSString *)getReturnedURL {
    return [NSString stringWithFormat:@"ig%@://authorize", self.clientId];
}


- (BOOL)handleOpenURL:(NSURL *)url {
    NSLog(@"url with token: %@",url);
    // If the URL's structure doesn't match the structure used for Instagram authorization, abort.
    if (![[url absoluteString] hasPrefix:[self getReturnedURL]]) {
        return NO;
    }
    
    NSString *query = [url fragment];
    if (!query) {
        query = [url query];
    }
    
    NSDictionary *params = [self parseURLParams:query];
    NSString *accessToken = [params valueForKey:@"access_token"];

    // If the URL doesn't contain the access token, an error has occurred.
    if (!accessToken) {
        
        NSString *errorReason = [params valueForKey:@"error_reason"];
        
        BOOL userDidCancel = [errorReason isEqualToString:@"user_denied"];
        [self igDidNotLogin:userDidCancel];
        return YES;
    }
    
    [self igDidLogin:accessToken/* expirationDate:expirationDate*/];
    return YES;
}

#pragma mark - Helpers

- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}


- (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params {
    return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}


- (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            if ([httpMethod isEqualToString:@"GET"]) {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (__bridge CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary* parametrsWithDefaultParams = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [parametrsWithDefaultParams setObject:_accessToken forKey:@"access_token"];
    [super getPath:path parameters:parametrsWithDefaultParams success:success failure:failure];
}




@end
