//
//  AvatarQuery.m
//  SimpleInstagramApp
//
//  Created by Danil on 09.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "Avatar.h"
#import "InstagramAPIClient.h"
@implementation Avatar

- (id)initWithImage:(NSURL *)imgURL {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _avatarURL = imgURL;
    return self;
}

#pragma mark -

+ (void)getAvatarWithBlock:(void (^)(Avatar *avatar, NSError *error))block {
    [[InstagramAPIClient sharedClient] getPath:@"users/self" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
//        NSLog(@"json: %@",JSON);
        NSDictionary* dataDict =[JSON objectForKey:@"data"];
        Avatar* avatar= [[Avatar alloc]initWithImage:[NSURL URLWithString:[dataDict objectForKey:@"profile_picture"]]];
        
        if (block) {
            block(avatar, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
