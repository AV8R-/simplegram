//
//  SGCommentsViewController.m
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGCommentsViewController.h"
#import "SGCommentCell.h"
#import "InstagramComment.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"

@interface SGCommentsViewController ()

@end

@implementation SGCommentsViewController
@synthesize mediaID, comments;

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

-(instancetype) init
{
    self = [super init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCommetns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Loading data
-(void) loadCommetns
{
    InstagramMedia *media = [self.managedObjectContext objectWithID:mediaID];
    comments = [media getCommentsWithManagedObjectContext:self.managedObjectContext];
    [self.commentsTableView reloadData];
}

#pragma mark tableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [self commetCellAtIndexPath:indexPath];
    return cell;
}

#pragma mark Configuring Cell Height
/*
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}
 */

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath*)indexPath
{
    static SGCommentCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.commentsTableView dequeueReusableCellWithIdentifier:@"commet_cell" forIndexPath:indexPath];
    });
    
    [self configureCommentCell:sizingCell AthIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

-(CGFloat) calculateHeightForConfiguredSizingCell:(UITableViewCell*)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}
#pragma mark PrepareCell
-(SGCommentCell*) commetCellAtIndexPath:(NSIndexPath*)indexPath
{
    SGCommentCell *cell = [self.commentsTableView dequeueReusableCellWithIdentifier:@"comment_cell" forIndexPath:indexPath];
    
    [self configureCommentCell:cell AthIndexPath:indexPath];
    
    return cell;
}

-(void) configureCommentCell:(SGCommentCell*)cell AthIndexPath:(NSIndexPath*)indexPath
{
    InstagramComment *comment = [self.comments objectAtIndex:indexPath.row];
    InstagramUser *user = [comment getCreatorwithManagedObjectContext:self.managedObjectContext];
    
    cell.usernameLabel.text = [NSString stringWithString:user.username];
    cell.commentLabel.text = [NSString stringWithString:comment.text];
    cell.timestampLabel.text = [self stringIntervalSinceDate:comment.createdDate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
