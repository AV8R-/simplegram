//
//  SGFeedTableViewController.m
//  simplegram
//
//  Created by Admin on 16.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGFeedTableViewController.h"
#import "SGFeedPostSectionHeaderView.h"
#import "SGPhotoTableViewCell.h"
#import "AppDelegate.h"
#import "InstagramMedia.h"
#import "InstagramUser+CoreDataProperties.h"

@interface SGFeedTableViewController ()

@property NSManagedObjectContext *moc;

@end

@implementation SGFeedTableViewController
@synthesize feed;

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.moc = [[NSManagedObjectContext alloc] init];
    [self.moc setPersistentStoreCoordinator:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] persistentStoreCoordinator]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**/
    
    [self updateStoreFromInstagramAPI];
    [self fillFeedWithStore];
    
    /**
    
    
    /**/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) updateStoreFromInstagramAPI
{
    self.api = [InstagramAPI sharedInstance];
    
    [self.api getPopularMediaWithSuccess:^(NSArray *result) {
        [self fillFeedWithStore];
        [self.feedTableView reloadData];
    }
                                 failure:^(NSError *e, NSInteger statusCode) {
                                     NSLog(@"%@", e);
                                 }];
}

-(void) fillFeedWithStore
{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InstagramMedia"
                                              inManagedObjectContext:self.moc];
    
    [request setEntity:entity];
    
    NSSortDescriptor *createdDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    
    [request setSortDescriptors:@[createdDateDescriptor]];
    
    NSError *error;
    feed = [[self.moc executeFetchRequest:request error:&error] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [feed count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo_cell" forIndexPath:indexPath];
    
    InstagramMedia *media = [feed objectAtIndex:indexPath.section];
    
    if (media.standartResolutionImageData) {
        cell.photoImageView.image = [UIImage imageWithData:media.standartResolutionImageData];
    }
    else {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *getStandartResolutionImageTask = [session dataTaskWithURL: [NSURL URLWithString:media.standartResolutionImageURL]
                                                                      completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error) {
                                                                          UIImage *image = [[UIImage alloc] initWithData:data];
                                                                          media.photo = image;
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              cell.photoImageView.image = media.photo;
                                                                          });
                                                                      }];
        [getStandartResolutionImageTask resume];
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerCellIndentifier = @"username_header";
    
    SGFeedPostSectionHeaderView *view = [tableView dequeueReusableCellWithIdentifier:headerCellIndentifier];
    if (view == nil) {
        view = [[SGFeedPostSectionHeaderView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIndentifier];
    }
    
    InstagramMedia *media = [feed objectAtIndex:section];
    InstagramUser *user = media.user;
    
    view.usernameLabel.text = user.username;
    
    NSString *sinceText = [self stringIntervalSinceDate:media.createdDate];
    
    view.timestampLabel.text = sinceText;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:nil];
    NSURLSessionDataTask *getStandartResolutionImageTask = [session dataTaskWithURL:[NSURL URLWithString:user.profilePictureURL]
                                                                          completionHandler:^(NSData *data,
                                                                                              NSURLResponse *response,
                                                                                              NSError *error) {
                                                                              UIImage *image = [[UIImage alloc] initWithData:data];
                                                                              user.photo = image;
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  view.userPhotoImageView.image = user.photo;
                                                                              });
                                                                              //[tableView setNeedsLayout];
                                                                          }];
    [getStandartResolutionImageTask resume];
    
    return view;
}

-(NSString *) stringIntervalSinceDate:(NSDate *)date
{
    NSString *sinceString;
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSinceDate:date];
    timestamp /= 60.0;
    
    if (timestamp <= 60)
    {
        sinceString = [NSString stringWithFormat:@"%im ago", (int)timestamp];
    }
    else
    {
        timestamp /= 60.0;
        if(timestamp <= 24)
        {
            sinceString = [NSString stringWithFormat:@"%ih ago", (int)timestamp];
        }
        else
        {
            timestamp /= 24;
            sinceString = [NSString stringWithFormat:@"%id ago", (int)timestamp];
        }
    }
    return sinceString;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
