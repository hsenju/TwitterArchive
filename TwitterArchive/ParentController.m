//
//  ParentController.m
//  TwitterArchive
//
//  Created by Hikari Senju on 9/21/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "TableViewCell.h"
#import "ImageTableViewCell.h"
#import "ParentController.h"

@interface ParentController ()

@end

@implementation ParentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

+ (CGFloat)heightForCellWithContentString:(NSString *)content {
    CGFloat horizontalTextSpace = ([UIScreen mainScreen].bounds.size.width) - 72.0f - 46.0f;
    
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin // wordwrap?
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                               context:nil].size;
    
    CGFloat singleLineHeight = [@"Test" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                                     context:nil].size.height;
    
    CGFloat multilineHeightAddition = contentSize.height - singleLineHeight;
    
    return 54.0f + fmax(0.0f, multilineHeightAddition);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tweet = _dataSource[(long)[indexPath row]];
    
    NSString *contentString = tweet[@"text"];
    
    if (tweet[@"entities"][@"media"]){
        return [ParentController heightForCellWithContentString:contentString] + 250 ;
    }
    
    
    return [ParentController heightForCellWithContentString:contentString];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tweet = _dataSource[[indexPath row]];
    static NSString *CellIdentifier;
    if (tweet[@"entities"][@"media"]){
        CellIdentifier = @"ImageTweetCell";
        
        ImageTableViewCell *cell = [self.tweetTableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
        }
        
        cell.titleLabel.text = tweet[@"text"];
        cell.subtitleLabel.text = [tweet[@"user"][@"name"] stringByAppendingString:[NSString stringWithFormat:@": @%@",tweet[@"user"][@"screen_name"]]];
        
        
        UIImage *tweetImage  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tweet[@"entities"][@"media"][0][@"media_url"]]]];
        cell.pictureView.image= tweetImage;
        
        return cell;
    
    }
    else {
        CellIdentifier = @"RegularTweetCell";

        TableViewCell *cell = [self.tweetTableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
        }
        
        cell.title.text = tweet[@"text"];
        cell.subtitle.text = [tweet[@"user"][@"name"] stringByAppendingString:[NSString stringWithFormat:@": @%@",tweet[@"user"][@"screen_name"]]];
        
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

}

@end
