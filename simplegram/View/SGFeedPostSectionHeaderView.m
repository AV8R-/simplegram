//
//  SGFeedPostSectionHeaderView.m
//  simplegram
//
//  Created by Admin on 16.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGFeedPostSectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "InstagramUser.h"
#import "InstagramUser+CoreDataProperties.h"

@implementation SGFeedPostSectionHeaderView
@synthesize usernameLabel, userPhotoImageView;

- (void)awakeFromNib {
    CALayer *photoLayer = userPhotoImageView.layer;
    [photoLayer setCornerRadius:10];
    //[photoLayer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
