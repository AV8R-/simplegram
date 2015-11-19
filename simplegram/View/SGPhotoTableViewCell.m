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

-(void) setImageWithURL:(NSURL *)imageURL
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *getStandartResolutionImageTask = [session downloadTaskWithURL:imageURL];
    [getStandartResolutionImageTask resume];
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [_downloadProgressView setProgress:(float)totalBytesWritten/totalBytesExpectedToWrite];
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:imageData];
    [_photoImageView setImage:image];
    _downloadProgressView.hidden = YES;
}

-(void) prepareForReuse
{
    self.photoImageView.image = nil;
}

@end
