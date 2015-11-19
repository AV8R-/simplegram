//
//  SGUserThumbnailImageView.m
//  simplegram
//
//  Created by Admin on 17.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGUserThumbnailImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SGUserThumbnailImageView


-(void) setImage:(UIImage *)image
{
    [super setImage:image];
    CGFloat radius = self.frame.size.width;
    CALayer *photoLayer = self.layer;
    [photoLayer setCornerRadius:10];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
