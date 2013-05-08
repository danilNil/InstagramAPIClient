//
//  AvatarQuery.h
//  SimpleInstagramApp
//
//  Created by Danil on 09.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Avatar : NSObject

@property(readonly) NSURL* avatarURL;

+ (void)getAvatarWithBlock:(void (^)(Avatar *avatar, NSError *error))block;

@end
