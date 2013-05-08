//
//  MostLikedPhoto.h
//  SimpleInstagramApp
//
//  Created by Danil on 10.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MostLikedPhoto;
@interface MostLikedPhotoTask : NSObject

@property(readonly) NSString* lastID;
@property(readonly) NSMutableArray* queryArray;
@property(readonly) NSInteger numOfLikes;
@property(readonly) NSURL* url;

-(void)getMostLikedPhotoWithBlock:(void (^)(MostLikedPhoto *photo, NSError *error))block;

@end
