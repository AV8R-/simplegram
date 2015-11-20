//
//  SGPhotoTableViewCell.m
//  simplegram
//
//  Created by Admin on 16.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGPhotoTableViewCell.h"

@implementation SGPhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageWithData:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    [_photoImageView setImage:image];
    _downloadProgressView.hidden = YES;
}

@end
