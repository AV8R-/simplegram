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
#import "InstagramComment+CoreDataProperties.h"
#import "SGCommentsViewController.h"

@interface SGFeedTableViewController ()

@end

@implementation SGFeedTableViewController
@synthesize feed,  feedTableView;

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    //Настройка импортера данных
    
    self.importer = [[SGImporter alloc] initWithContext:self.backgroundManagedObjectContext];
    self.importer.delegate = self;
    
    //Настрока экспортера данных
    
    self.exporter = [[SGExporter alloc] initWithManagedObjectContext:self.managedObjectContext];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillFeedWithStore];
    
    UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self action:@selector(refreshFeed:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.activeTasks = [[NSMutableArray alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    if ([[InstagramAPI sharedInstance] isSessionValid]) {
        self.logInOrOutButton.titleLabel.text = @"LogOut";
    }
    else {
        self.logInOrOutButton.titleLabel.text = @"LogIn";
    }
    self.navigationController.hidesBarsOnSwipe = YES;
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = NO;
    [super viewWillDisappear:animated];
}

-(void) loadingFeedDidEnd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fillFeedWithStore];
        [self.refreshControl endRefreshing];
    });
}

-(void) refreshFeed:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing"];
    [self.importer importPopular];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fillFeedWithStore];
        [self.refreshControl endRefreshing];
    });
}

-(void) fillFeedWithStore
{
    feed = [self.exporter readFeed];
    [self.feedTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

/**
 * В секции находится аватар пользователя, юзернейм и время поста
**/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [feed count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 * Вычисляется высота каждого поста.
 * Странно, но API Instagram возвращает размеры картинок 640х640 всегда, хотя большинство имеют другой формат.
**/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForPhotoCellAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 375.0;
}

-(CGFloat)heightForPhotoCellAtIndexPath:(NSIndexPath *)indexPath
{
    static SGPhotoTableViewCell * sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.feedTableView dequeueReusableCellWithIdentifier:@"photo_cell"];
    });
    
    [self configurePhotoCell:sizingCell ForRowAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

-(CGFloat) calculateHeightForConfiguredSizingCell:(UITableViewCell*)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [self photoCellAtIndexPath:indexPath];
    [self downloadImageForCell:(SGPhotoTableViewCell*)cell atIndexPath:indexPath];
    
    return cell;
}

/**
 * Настраивает вид поста
**/
-(SGPhotoTableViewCell *) photoCellAtIndexPath:(NSIndexPath*)indexPath
{
    SGPhotoTableViewCell *cell = [feedTableView dequeueReusableCellWithIdentifier:@"photo_cell" forIndexPath:indexPath];
    [self configurePhotoCell:cell ForRowAtIndexPath:indexPath];
    return cell;
}

-(void) configurePhotoCell:(SGPhotoTableViewCell*)cell ForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramMedia *media = [feed objectAtIndex:indexPath.section];
    InstagramUser *user = [media getCreatorwithManagedObjectContext:self.managedObjectContext];
    InstagramComment *caption = [media getCaptionwithManagedObjectContext:self.managedObjectContext];
    
    CGFloat correctImageViewHeight = media.imageHeight && media.imageWidth ?
    self.feedTableView.frame.size.width * [media.imageHeight floatValue] / [media.imageWidth floatValue] :
    self.feedTableView.frame.size.width;
    
    [cell.photoImageView addConstraint:[NSLayoutConstraint constraintWithItem:cell.photoImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant: correctImageViewHeight]];

    cell.likesCountNumber.text = [NSString stringWithFormat:@"%@", media.likesCount];
    cell.commentsCountLabel.text = [NSString stringWithFormat:@"%@", media.commentCount];
    user ? cell.creatorLabel.text = [NSString stringWithString:user.username] : 0;
    caption ? cell.captionLabel.text = [NSString stringWithString:caption.text] : 0;
    cell.commentsButton.tag = indexPath.section;
    
    NSDictionary *downloadTaskInfo = [self getInfoForDownloadTaskAtIndexPath:indexPath];
    if(downloadTaskInfo) {
        long downloadedSize = [(NSNumber*)downloadTaskInfo[@"downloadedSize"] longValue];
        long totalSize = [(NSNumber*)downloadTaskInfo[@"totalSize"] longValue];
        cell.downloadProgressView.progress = (double)downloadedSize / (double)totalSize;
    }
}

/**
 * Подгружает картинку из БД, или если ее там нет,
 * Скачивает ее с сервера Instagram
**/
-(void) downloadImageForCell:(SGPhotoTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    InstagramMedia *media = [feed objectAtIndex:indexPath.section];
    if (media.standartResolutionImageData) {
        cell.photoImageView.image = [UIImage imageWithData:media.standartResolutionImageData];
        cell.downloadProgressView.hidden = YES;
    }
    else if ([self getInfoForDownloadTaskAtIndexPath:indexPath] == nil) {
        cell.downloadProgressView.hidden = NO;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                              delegate:self
                                                         delegateQueue:nil];
        NSURLSessionDownloadTask *getStandartResolutionImageTask = [session downloadTaskWithURL:[NSURL URLWithString:media.standartResolutionImageURL]];
        
        
        NSMutableDictionary *downloadTaskInfo = [[NSMutableDictionary alloc] init];
        [downloadTaskInfo setObject:getStandartResolutionImageTask forKey:@"downloadTask"];
        [downloadTaskInfo setObject:[indexPath copy] forKey:@"indexPath"];
        [downloadTaskInfo setObject:[NSNumber numberWithInt:999] forKey:@"totalSize"];
        [downloadTaskInfo setObject:[NSNumber numberWithInt:0] forKey:@"downloadedSize"];
        [downloadTaskInfo setObject:media forKey:@"media"];
        
        [self.activeTasks addObject:downloadTaskInfo];
        
        [getStandartResolutionImageTask resume];
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerCellIndentifier = @"username_header";
    
    SGFeedPostSectionHeaderView *view = [tableView dequeueReusableCellWithIdentifier:headerCellIndentifier];
    if (view == nil) {
        view = [[SGFeedPostSectionHeaderView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIndentifier];
    }
    
    InstagramMedia *media = [feed objectAtIndex:section];
    InstagramUser *user = [media getCreatorwithManagedObjectContext:self.managedObjectContext];
    
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
                                                                          }];
    [getStandartResolutionImageTask resume];
    
    return view;
}

#pragma mark Download tasks info
-(NSMutableDictionary*)getInfoForDownloadTask:(NSURLSessionDownloadTask*)downloadTask
{
    for (NSMutableDictionary *info in self.activeTasks) {
        if (info[@"downloadTask"] == downloadTask) {
            return info;
        }
    }
    return nil;
}

-(NSMutableDictionary*)getInfoForDownloadTaskAtIndexPath:(NSIndexPath*)indexPath
{
    for (NSMutableDictionary *info in self.activeTasks) {
        NSIndexPath *candidateIndexPath = info[@"indexPath"];
        if (candidateIndexPath.section == indexPath.section) {
            return info;
        }
    }
    return nil;
}

#pragma mark URLSession delegate methods
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSMutableDictionary *info = [self getInfoForDownloadTask:downloadTask];
    [info setObject:[NSNumber numberWithLong:expectedTotalBytes] forKey:@"totalSize"];
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSMutableDictionary *downloadTaskInfo = [self getInfoForDownloadTask:downloadTask];
    [downloadTaskInfo setObject:[NSNumber numberWithLong:totalBytesWritten] forKey:@"downloadedSize"];
    
    NSIndexPath *indexPath = downloadTaskInfo[@"indexPath"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"%@",error);
        }
        [self.feedTableView beginUpdates];
        [self.feedTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                                  withRowAnimation:UITableViewRowAnimationNone];
        [self.feedTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                          withRowAnimation:UITableViewRowAnimationNone];
        [self.feedTableView endUpdates];
    });
    NSLog(@"Downloading for section %li: %f", (long)indexPath.section, (double)totalBytesWritten/(double)totalBytesExpectedToWrite);
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(nonnull NSURL *)location
{
    NSData *downloadedData = [NSData dataWithContentsOfURL:location];
    
    NSMutableDictionary *downloadInfo = [self getInfoForDownloadTask:downloadTask];
    InstagramMedia *media = downloadInfo[@"media"];
    [self.managedObjectContext performBlock:^{
        media.standartResolutionImageData = downloadedData;
        
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"%@", error);
        }

    }];
    
    
    NSIndexPath *indexPath = downloadInfo[@"indexPath"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.feedTableView beginUpdates];
        [self.feedTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
        [self.feedTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                          withRowAnimation:UITableViewRowAnimationNone];
        [self.feedTableView endUpdates];
    });
    
    NSLog(@"Downloaded image for section %li", indexPath.section);
    [self.activeTasks removeObject:downloadTask];
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"comments_segue"]) {
        NSInteger mediaIndexInFeedArray = 0;
        
        if([sender isKindOfClass:[UIButton class]]) {
            mediaIndexInFeedArray = [(UIButton*)sender tag];
        }
        
        InstagramMedia *media = [self.feed objectAtIndex:mediaIndexInFeedArray];
        
        SGCommentsViewController *destinationController = [segue destinationViewController];
        destinationController.mediaID = media.objectID;
    }
}

#pragma mark Actions
- (IBAction)logInOrout:(id)sender {
    if ([self.api isSessionValid]) {
        [self.api logout];
    }
    else {
        [self performSegueWithIdentifier:@"login_segue" sender:self];
    }
}
@end
