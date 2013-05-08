//
//  MostLikedPhoto.h
//  SimpleInstagramApp
//
//  Created by Danil on 10.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MostLikedPhoto : NSObject

@property(readonly) NSURL* photoURL;
@property(readonly) NSInteger numLikes;

-(id)initWithPhotoURL:(NSURL*)url andNumOfLikes:(NSInteger)numLikes;

@end
