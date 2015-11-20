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
@synthesize photo;

#pragma mark Init

-(void) updateDetails:(NSDictionary *)info
{
    if([info[kUser] isKindOfClass:[NSDictionary class]]) {
        self.user = [BaseInstagramEntity findOrCreateEntity:[InstagramUser class]
                                                     WithId:info[kUser][kID] inContext:self.moc];
        [self.user updateDetails:info[kUser]];
    }
    self.userHasLiked = [NSNumber numberWithBool:[info[kUserHasLiked] boolValue]];
    self.createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
    self.link = [[NSString alloc] initWithString:info[kLink]];
    if([info[kCaption] isKindOfClass:[NSDictionary class]]) {
        self.caption = [BaseInstagramEntity findOrCreateEntity:[InstagramComment class]
                                                        WithId:info[kCaption][kID]
                                                     inContext:self.moc];
        [self.caption updateDetails:info[kCaption]];
    }
    self.likesCount = (info[kLikes])[kCount];
    self.likes = [[NSMutableSet alloc] init];
    for (NSDictionary *userInfo in (info[kLikes])[kData]) {
        if([userInfo isKindOfClass:[NSDictionary class]]) {
            InstagramUser *user = [BaseInstagramEntity findOrCreateEntity:[InstagramUser class]
                                                                   WithId:userInfo[kID]
                                                                inContext:self.moc];
            [user updateDetails:userInfo];
            [self addLikesObject:user];
        }
    }
    
    self.commentCount = (info[kComments])[kCount];
    self.comments = [[NSMutableSet alloc] init];
    for (NSDictionary *commentInfo in (info[kComments])[kData]) {
        if([commentInfo isKindOfClass:[NSDictionary class]]) {
            InstagramComment *comment = [BaseInstagramEntity findOrCreateEntity:[InstagramComment class]
                                                                         WithId:commentInfo[kID]
                                                                      inContext:self.moc];
            [comment updateDetails:commentInfo];
            [self addCommentsObject:comment];
        }
    }
    
    
    [self initializeImages:info[kImages]];
    
    NSString* mediaType = info[kType];
    self.isVideo = [NSNumber numberWithBool:[mediaType isEqualToString:[NSString stringWithFormat:@"%@",kMediaTypeVideo]]];
    if (self.isVideo) {
    }
}

#pragma mark Initialize content

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = imagesInfo[kThumbnail];
    self.thumbnailURL = (thumbInfo[kURL]) ? thumbInfo[kURL] : nil;
    
    NSDictionary *lowResInfo = imagesInfo[kLowResolution];
    self.lowResolutionImageURL = lowResInfo[kURL]? lowResInfo[kURL] : nil;
    
    NSDictionary *standardResInfo = imagesInfo[kStandardResolution];
    self.imageHeight = [NSNumber numberWithFloat:[standardResInfo[kWidth] floatValue]];
    self.imageWidth = [NSNumber numberWithFloat:[standardResInfo[kHeight] floatValue]];
    
    self.standartResolutionImageURL = standardResInfo[kURL]? standardResInfo[kURL] : nil;
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = videosInfo[kLowResolution];
    self.lowResolutionVideoURL = lowResInfo[kURL] ? lowResInfo[kURL] : nil;
    
    NSDictionary *standardResInfo = videosInfo[kStandardResolution];
    self.standartResolutionVideoURL = standardResInfo[kURL]? standardResInfo[kURL] : nil;
}

#pragma mark Getters
-(InstagramUser*) getCreatorwithManagedObjectContext:(NSManagedObjectContext*)moc
{
    id creatorID = self.user;
    InstagramUser *creator;
    if ([creator isKindOfClass:[NSManagedObjectID class]]) {
        creator = [moc objectWithID:creatorID];
    }
    else {
        creator = (InstagramUser*)creatorID;
    }
    
    return creator;
}

-(InstagramComment*) getCaptionwithManagedObjectContext:(NSManagedObjectContext*)moc
{
    id commentID = self.caption;
    InstagramComment *comment;
    if ([commentID isKindOfClass:[NSManagedObjectID class]]) {
        comment = [moc objectWithID:commentID];
    }
    else {
        comment = (InstagramComment*)commentID;
    }
    
    return comment;
}

-(NSArray*) getCommentsWithManagedObjectContext:(NSManagedObjectContext*)moc
{
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    for (id commentId in self.comments) {
        InstagramComment *comment;
        if([commentId isKindOfClass:[NSManagedObjectID class]]) {
            comment = [moc objectWithID:commentId];
        }
        else {
            comment = (InstagramComment*)commentId;
        }
        [comments addObject:comment];
    }
    return [NSArray arrayWithArray:comments];
}

#pragma mark Comparing

- (BOOL)isEqualToMedia:(InstagramMedia *)media
{
    return [super isEqualToModel:media];
}


@end
