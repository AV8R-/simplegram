//
//  InstagramMedia.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "InstagramAPIConstants.h"
#import "InstagramMedia.h"
#import "InstagramComment.h"
#import "InstagramUser.h"
#import "InstagramMedia+CoreDataProperties.h"
#import "BaseInstagramEntity+CoreDataProperties.h"

@implementation InstagramMedia
{
    NSInteger downloadStandartResolutionTask;
}
@synthesize thumbnailFrameSize,
            lowResolutionImageFrameSize,
            standardResolutionImageFrameSize,
            lowResolutionVideoFrameSize,
            standardResolutionVideoFrameSize,
            photo,
            moc;

#pragma mark Init

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [self initWithInfo:info managedObjectContext:nil];
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithInfo:info subclass:[InstagramMedia class] withMoc:managedObjectContext];
    if (self && info) {
        [self updateDetails:info];
        //[self downLoadImages];
    }
    return self;
}

-(void) updateDetails:(NSDictionary *)info
{
    self.user = [[InstagramUser alloc] initWithInfo:info[kUser] managedObjectContext:self.moc];
    self.userHasLiked = [NSNumber numberWithBool:[info[kUserHasLiked] boolValue]];
    self.createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
    self.link = [[NSString alloc] initWithString:info[kLink]];
    self.caption = [[InstagramComment alloc] initWithInfo:info[kCaption] managedObjectContext:self.moc];
    self.likesCount = (info[kLikes])[kCount];
    self.likes = [[NSMutableSet alloc] init];
    for (NSDictionary *userInfo in (info[kLikes])[kData]) {
        InstagramUser *user = [[InstagramUser alloc] initWithInfo:userInfo managedObjectContext:self.moc];
        [self addLikesObject:user];
    }
    
    self.commentCount = (info[kComments])[kCount];
    self.comments = [[NSMutableSet alloc] init];
    for (NSDictionary *commentInfo in (info[kComments])[kData]) {
        InstagramComment *comment = [[InstagramComment alloc] initWithInfo:commentInfo managedObjectContext:self.moc];
        [self addCommentsObject:comment];
    }
    
    
    [self initializeImages:info[kImages]];
    
    NSString* mediaType = info[kType];
    self.isVideo = [NSNumber numberWithBool:[mediaType isEqualToString:[NSString stringWithFormat:@"%@",kMediaTypeVideo]]];
    if (self.isVideo) {
        //[self initializeVideos:info[kVideos]];
    }
    
    NSError *error;
    [self.moc save:&error];
    if(error) {
        NSLog(@"%@", error);
    }
}

#pragma mark Initialize content

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = imagesInfo[kThumbnail];
    self.thumbnailURL = (thumbInfo[kURL]) ? thumbInfo[kURL] : nil;
    thumbnailFrameSize = CGSizeMake([thumbInfo[kWidth] floatValue], [thumbInfo[kHeight] floatValue]);
    
    NSDictionary *lowResInfo = imagesInfo[kLowResolution];
    self.lowResolutionImageURL = lowResInfo[kURL]? lowResInfo[kURL] : nil;
    lowResolutionImageFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = imagesInfo[kStandardResolution];
    self.standartResolutionImageURL = standardResInfo[kURL]? standardResInfo[kURL] : nil;
    standardResolutionImageFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = videosInfo[kLowResolution];
    self.lowResolutionVideoURL = lowResInfo[kURL] ? lowResInfo[kURL] : nil;
    lowResolutionVideoFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = videosInfo[kStandardResolution];
    self.standartResolutionVideoURL = standardResInfo[kURL]? standardResInfo[kURL] : nil;
    standardResolutionVideoFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

#pragma mark Download content
-(void) downLoadImages
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *getThumbnailTask = [session downloadTaskWithURL:[NSURL URLWithString:self.thumbnailURL]
                                                            completionHandler:^(NSURL *location,
                                                                                NSURLResponse *response,
                                                                                NSError *error) {
                                                                self.thumbnailData = [NSData dataWithContentsOfURL:location];
                                                            }];
    [getThumbnailTask resume];
    
    NSURLSessionDownloadTask *getLowResolutionTask = [session downloadTaskWithURL:[NSURL URLWithString:self.lowResolutionImageURL]
                                                                completionHandler:^(NSURL *location,
                                                                                    NSURLResponse *response,
                                                                                    NSError *error) {
                                                                    self.lowResolutionImageData = [NSData dataWithContentsOfURL:location];
                                                                }];
    [getLowResolutionTask resume];
    
    NSURLSessionDownloadTask *getStandartResolutionImageTask = [session downloadTaskWithURL:[NSURL URLWithString:self.standartResolutionImageURL]];
    downloadStandartResolutionTask = getStandartResolutionImageTask.taskIdentifier;
    [getStandartResolutionImageTask resume];
    
}

#pragma mark Download Task Delegate methods
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (downloadTask.taskIdentifier == downloadStandartResolutionTask) {
        NSLog(@"Downloaded: %f", (double)totalBytesWritten/totalBytesExpectedToWrite);
    }
}

#pragma Comparing

- (BOOL)isEqualToMedia:(InstagramMedia *)media
{
    return [super isEqualToModel:media];
}

#pragma mark Setters
-(void) setPhoto:(UIImage *)photo
{
    self->photo = photo;
    NSData *imageData = UIImageJPEGRepresentation(photo, 1.0);
    self.standartResolutionImageData = imageData;
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

@end
