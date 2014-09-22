//
//  SecondViewController.m
//  TwitterArchive
//
//  Created by Hikari Senju on 9/21/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTimeLine];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
     [self getTimeLine];
     [self.archiveTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTimeLine {
    
    NSMutableArray* dataSourceMutable = [[NSMutableArray alloc] init];;
    for (NSData *tweetData in [[NSUserDefaults standardUserDefaults] arrayForKey:@"tweetArray"]){
    
        NSDictionary* tweetDict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:tweetData];
        [dataSourceMutable addObject:tweetDict];
        
    }
    
    self.dataSource = [[[NSArray arrayWithArray:dataSourceMutable] reverseObjectEnumerator] allObjects];

}
@end
