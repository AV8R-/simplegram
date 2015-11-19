//
//  InstagramMedia+CoreDataProperties.h
//  simplegram
//
//  Created by Admin on 19.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InstagramMedia.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstagramMedia (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *commentCount;
@property (nullable, nonatomic, retain) NSDate *createdDate;
@property (nullable, nonatomic, retain) NSNumber *isVideo;
@property (nullable, nonatomic, retain) NSNumber *likesCount;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSData *lowResolutionImageData;
@property (nullable, nonatomic, retain) NSString *lowResolutionImageURL;
@property (nullable, nonatomic, retain) NSData *lowResolutionVideoData;
@property (nullable, nonatomic, retain) NSString *lowResolutionVideoURL;
@property (nullable, nonatomic, retain) NSData *standartResolutionImageData;
@property (nullable, nonatomic, retain) NSString *standartResolutionImageURL;
@property (nullable, nonatomic, retain) NSData *standartResolutionVideoData;
@property (nullable, nonatomic, retain) NSString *standartResolutionVideoURL;
@property (nullable, nonatomic, retain) NSData *thumbnailData;
@property (nullable, nonatomic, retain) NSString *thumbnailURL;
@property (nullable, nonatomic, retain) NSNumber *userHasLiked;
@property (nullable, nonatomic, retain) NSNumber *imageHeight;
@property (nullable, nonatomic, retain) NSNumber *imageWidth;
@property (nullable, nonatomic, retain) InstagramComment *caption;
@property (nullable, nonatomic, retain) NSMutableSet<InstagramComment *> *comments;
@property (nullable, nonatomic, retain) NSMutableSet<InstagramUser *> *likes;
@property (nullable, nonatomic, retain) InstagramUser *user;

@end

@interface InstagramMedia (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(InstagramComment *)value;
- (void)removeCommentsObject:(InstagramComment *)value;
- (void)addComments:(NSSet<InstagramComment *> *)values;
- (void)removeComments:(NSSet<InstagramComment *> *)values;

- (void)addLikesObject:(InstagramUser *)value;
- (void)removeLikesObject:(InstagramUser *)value;
- (void)addLikes:(NSSet<InstagramUser *> *)values;
- (void)removeLikes:(NSSet<InstagramUser *> *)values;

@end

NS_ASSUME_NONNULL_END
