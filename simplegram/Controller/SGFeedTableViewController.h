//
//  SGFeedTableViewController.h
//  simplegram
//
//  Created by Admin on 16.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramAPI.h"

@interface SGFeedTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSMutableArray *feed;
@property (strong, nonatomic) NSMutableArray *feedUserThumbnails;
@property (strong, nonatomic) NSMutableArray *feedStandartResolutionImages;
@property (nonatomic, strong) InstagramAPI *api;

@end
