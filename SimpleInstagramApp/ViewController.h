//
//  ViewController.h
//  SimpleInstagramApp
//
//  Created by Danil on 09.11.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mostLikedPhoto;
@property (weak, nonatomic) IBOutlet UILabel *numLikes;
@property (weak, nonatomic) IBOutlet UIImageView *avaImage;
- (IBAction)getMostLikedPhoto:(id)sender;
- (IBAction)getAva:(id)sender;
- (IBAction)login:(id)sender;

@end
