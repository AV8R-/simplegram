//
//  SGPhotoTableViewCell.h
//  simplegram
//
//  Created by Admin on 16.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGPhotoTableViewCell : UITableViewCell <NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountNumber;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end
