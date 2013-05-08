//
//  ViewController.m
//  SimpleInstagramApp
//
//  Created by Danil on 09.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "ViewController.h"
#import "InstagramAPIClient.h"
#import "Avatar.h"
#import "UIImageView+AFNetworking.h"
#import "MostLikedPhotoTask.h"
#import "MostLikedPhoto.h"

static  NSString* instagramAppId = @"b8374cd039c6493daaab5f38fce74073";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[InstagramAPIClient sharedClient] setLoginStatusBlock:^(LoginStatusEnum status) {
        NSString* message;
        switch (status) {
            case LoginStatusFailed:
                message = @"Failed";
                break;
            case LoginStatusSuccessfully:
                message = @"Logged!";
                break;
            default:
                break;
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getMostLikedPhoto:(id)sender {
    MostLikedPhotoTask* newTask = [[MostLikedPhotoTask alloc] init];
    [newTask getMostLikedPhotoWithBlock:^(MostLikedPhoto *photo, NSError *error) {
        if(error){
        }else{
            NSLog(@"photo url: %@ likes: %i",photo.photoURL,photo.numLikes);
            [_mostLikedPhoto setImageWithURL:photo.photoURL];
            _numLikes.text = [NSString stringWithFormat:@"%i",photo.numLikes];
        }
    }];
}

- (IBAction)getAva:(id)sender {
    [Avatar getAvatarWithBlock:^(Avatar *avatar, NSError *error) {
        if (error) {
            NSLog(@"error: %@",[error description]);
        }else{
            [_avaImage setImageWithURL:avatar.avatarURL];
        }
    }];
}

- (IBAction)login:(id)sender {
//basic - to read any and all data related to a user (e.g. following/followed-by lists, photos, etc.) (granted by default)
// http://instagram.com/developer/authentication/
    [[InstagramAPIClient sharedClient] loginWithClientId:instagramAppId andPermisions:[NSArray arrayWithObjects:@"basic", nil]];
}
@end
