//
//  Photos.m
//  SimpleInstagramApp
//
//  Created by Danil on 10.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "Photos.h"
#import "InstagramAPIClient.h"

@implementation Photos

- (id)initWithArray:(NSArray *)photos{
    self = [super init];
    if (!self) {
        return nil;
    }
    _photosArray =photos;
    return self;
}

+ (void)getPhotosFromLastID:(NSString*)lastID withBlock:(void (^)(Photos *photos, NSError *error))block{
    [[InstagramAPIClient sharedClient] getPath:@"users/self/media/recent" parameters:[NSDictionary dictionaryWithObject:lastID forKey:@"max_id"] success:^(AFHTTPRequestOperation *operation, id JSON) {
//        NSLog(@"json: %@",JSON);
        NSLog(@"max id: %@",lastID);
        Photos* photos= [[Photos alloc]initWithArray:[JSON objectForKey:@"data"]];
        
        if (block) {
            block(photos, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    
}


@end
