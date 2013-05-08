//
//  MostLikedPhoto.m
//  SimpleInstagramApp
//
//  Created by Danil on 10.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "MostLikedPhoto.h"

@implementation MostLikedPhoto

-(id)initWithPhotoURL:(NSURL*)url andNumOfLikes:(NSInteger)numLikes{
    self = [super init];
    if (!self) {
        return nil;
    }
    _photoURL =url;
    _numLikes= numLikes;
    return self;
}

@end
