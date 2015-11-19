//
//  InstagramMedia+CoreDataProperties.m
//  simplegram
//
//  Created by Admin on 19.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InstagramMedia+CoreDataProperties.h"
#import "InstagramAPIConstants.h"

@implementation InstagramMedia (CoreDataProperties)

@dynamic commentCount;
@dynamic createdDate;
@dynamic isVideo;
@dynamic likesCount;
@dynamic link;
@dynamic lowResolutionImageData;
@dynamic lowResolutionImageURL;
@dynamic lowResolutionVideoData;
@dynamic lowResolutionVideoURL;
@dynamic standartResolutionImageData;
@dynamic standartResolutionImageURL;
@dynamic standartResolutionVideoData;
@dynamic standartResolutionVideoURL;
@dynamic thumbnailData;
@dynamic thumbnailURL;
@dynamic userHasLiked;
@dynamic imageHeight;
@dynamic imageWidth;
@dynamic caption;
@dynamic comments;
@dynamic likes;
@dynamic user;

#pragma mark Liskes manipulation

- (void)addLikesObject:(InstagramUser *)value
{
    [self.likes addObject:value];
}
- (void)removeLikesObject:(InstagramUser *)value
{
    [self.likes removeObject:value];
}
- (void)addLikes:(NSSet<InstagramUser *> *)values
{
    [self.likes addObjectsFromArray:[values allObjects]];
}

- (void)removeLikes:(NSSet<InstagramUser *> *)values
{
    NSEnumerator *enumerator = [values objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        [self removeLikesObject:value];
    }
}

#pragma mark Comments manipulation

- (void)addCommentsObject:(InstagramComment *)value
{
    [self.comments addObject:value];
}

- (void)removeCommentsObject:(InstagramComment *)value
{
    [self.comments removeObject:value];
}

- (void)addComments:(NSSet<InstagramComment *> *)values
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kCreatedDate ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSArray *sortedValues = [values sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.comments addObjectsFromArray:sortedValues];
}

- (void)removeComments:(NSSet<InstagramComment *> *)values
{
    NSEnumerator *enumerator = [values objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        [self removeCommentsObject:value];
    }
}

@end
