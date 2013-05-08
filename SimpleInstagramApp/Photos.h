//
//  Photos.h
//  SimpleInstagramApp
//
//  Created by Danil on 10.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photos : NSObject

@property(readonly) NSArray* photosArray;


- (id)initWithArray:(NSArray *)photos;

+ (void)getPhotosFromLastID:(NSString*)lastID withBlock:(void (^)(Photos *photos, NSError *error))block;

@end
