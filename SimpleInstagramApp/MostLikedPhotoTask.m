//
//  MostLikedPhoto.m
//  SimpleInstagramApp
//
//  Created by Danil on 10.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "MostLikedPhotoTask.h"
#import "InstagramAPIClient.h"
#import "MostLikedPhoto.h"
#import "Photos.h"

@implementation MostLikedPhotoTask

- (id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    _lastID=@"";
    _numOfLikes=0;
    return self;
}



-(void)getMostLikedPhotoWithBlock:(void (^)(MostLikedPhoto *photo, NSError *error))block{
    [Photos getPhotosFromLastID:_lastID withBlock:^(Photos *photos, NSError *error) {
        if(error){
            NSLog(@"error: %@",[error description]);
            block(nil,error);
        }else{
//            NSLog(@"photos: %@",photos.photosArray);
            NSLog(@"num of likes: %i",_numOfLikes);
            for (NSDictionary*dataDict in photos.photosArray) {
                NSInteger temp = [[[dataDict objectForKey:@"likes"] objectForKey:@"count"] intValue];
                if(temp>_numOfLikes){
                    _numOfLikes=temp;
                    _url = [NSURL URLWithString: [[[dataDict objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"] ];
                }
            }
            if([photos.photosArray count]>0){
                _lastID = [[photos.photosArray lastObject] objectForKey:@"id"];
                [self getMostLikedPhotoWithBlock:block];
                //            NSLog(@"lastID: %@",lastID);
            }else if ([photos.photosArray count]==0){
                MostLikedPhoto* newPhoto = [[MostLikedPhoto alloc] initWithPhotoURL:_url andNumOfLikes:_numOfLikes];
                block(newPhoto,nil);
            }
        }
        
    }];
}





@end
