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
#import "InstagramAPI.h"

@interface SGCommentsViewController ()
{
    InstagramAPI *api;
    NSString *instagramId;
}

@end

@implementation SGCommentsViewController
@synthesize mediaID, comments;

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCommetns];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[InstagramAPI sharedInstance] isSessionValid]) {
        [self.commentPlaceholder setEnabled:YES];
        self.commentPlaceholder.placeholder = @"Leave a comment";
        self.commentPlaceholder.returnKeyType = UIReturnKeySend;
    }
    else {
        [self.commentPlaceholder setEnabled:NO];
        self.commentPlaceholder.placeholder = @"Sign in to leave a comment";
    }
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
    
    instagramId = media.instagramId;
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}
 
 

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath*)indexPath
{
    static SGCommentCell *sizingCell = nil;
    static dispatch_once_t onceCommentToken;
    dispatch_once(&onceCommentToken, ^{
        sizingCell = [self.commentsTableView dequeueReusableCellWithIdentifier:@"comment_cell"];
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

#pragma mark Text Field
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[InstagramAPI sharedInstance] sendComment:textField.text
                                     toMediaID:instagramId
                                   withSuccess:nil //TODO: Обновить комментарии.
                                       failure:nil];
    textField.text = @"";
    [textField resignFirstResponder];
    return NO;
}

@end
