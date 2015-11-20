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
    
    //Настрока tableView

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillFeedWithStore];
    
    UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self action:@selector(refreshFeed:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

-(void) viewWillAppear:(BOOL)animated
{
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
        [self.feedTableView reloadData];
        [self.refreshControl endRefreshing];
    });
}

-(void) refreshFeed:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing"];
    [self.importer importPopular];
}

-(void) fillFeedWithStore
{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InstagramMedia"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSSortDescriptor *createdDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    
    [request setSortDescriptors:@[createdDateDescriptor]];
    
    NSError *error;
    feed = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
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
    }
    else {
        //TODO: Добавить индикатор загрузки
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
                                                                              media.standartResolutionImageData = data;
                                                                              cell.photoImageView.image = media.photo;
                                                                              NSError *error;
                                                                              if(![self.managedObjectContext save:&error])
                                                                              {
                                                                                  abort();
                                                                              }
                                                                          });
                                                                      }];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger mediaIndexInFeedArray = 0;
    
    if([sender isKindOfClass:[UIButton class]]) {
        mediaIndexInFeedArray = [(UIButton*)sender tag];
    }
    
    InstagramMedia *media = [self.feed objectAtIndex:mediaIndexInFeedArray];
    
    SGCommentsViewController *destinationController = [segue destinationViewController];
    destinationController.mediaID = media.objectID;
    
    
    //destinationController.mediaID
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
