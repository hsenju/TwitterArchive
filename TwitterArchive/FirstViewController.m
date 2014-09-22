//
//  FirstViewController.m
//  TwitterArchive
//
//  Created by Hikari Senju on 9/21/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTimeLine: nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSDictionary *tweet = self.dataSource[[indexPath row]];
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:tweet];
    
    NSMutableArray *mtweetArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tweetArray"] mutableCopy];
    if (!mtweetArray){
        mtweetArray = [@[] mutableCopy];
    }
    [mtweetArray addObject:myData];
    NSArray *tweetArray = [NSArray arrayWithArray:mtweetArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:tweetArray forKey:@"tweetArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UISearchBar Delegate Methods


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) [self getTimeLine:nil];
    
    [self getTimeLine:searchText];

}


- (void)getTimeLine: (NSString*)searchText {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"20" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 
                 if (searchText){
                     requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                     parameters =
                     [[NSMutableDictionary alloc] init];
                     [parameters setObject:searchText forKey:@"q"];
                     [parameters setObject:@"15" forKey:@"count"];
                 }
                 
                 SLRequest *getRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 getRequest.account = twitterAccount;
                 
                 [getRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      if ([[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] isKindOfClass:[NSArray class]]){
                          self.dataSource = [NSJSONSerialization
                                             JSONObjectWithData:responseData
                                             options:NSJSONReadingMutableLeaves
                                             error:&error];
                      }else {
                          self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error][@"statuses"];
                      }
                      

                      
                      if (self.dataSource.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tweetTableView reloadData];
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
         }
     }];
}

@end
