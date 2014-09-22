//
//  FirstViewController.h
//  TwitterArchive
//
//  Created by Hikari Senju on 9/21/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <UIKit/UIKit.h>
#import "ParentController.h"

@interface FirstViewController : ParentController

@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;

@end
