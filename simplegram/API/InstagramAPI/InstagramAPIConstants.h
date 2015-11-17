//
//  InstagramAPIConstants.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramUser;
@class InstagramMedia;
@class BaseInstagramEntity;

extern NSString *const kInstagramAPIBaseScheme;
extern NSString *const kInstagramAPIBaseUrl;
extern NSString *const kInstagramBasePath;
extern NSString *const kInstagramAuthorizationPath;

extern NSString *const kInstagramClientIdConfigurationKey;
extern NSString *const kInstagramRedirectUrlConfigurationKey;

extern NSString *const kKeyClientID;
extern NSString *const kKeyAccessToken;

extern NSString *const kPaginationKeyMaxId;


extern NSString *const kID;
extern NSString *const kCount;
extern NSString *const kURL;
extern NSString *const kHeight;
extern NSString *const kWidth;
extern NSString *const kData;

extern NSString *const kThumbnail;
extern NSString *const kLowResolution;
extern NSString *const kStandardResolution;

extern NSString *const kMediaTypeImage;
extern NSString *const kMediaTypeVideo;

extern NSString *const kUser;
extern NSString *const kUserHasLiked;
extern NSString *const kCreatedDate;
extern NSString *const kLink;
extern NSString *const kCaption;
extern NSString *const kLikes;
extern NSString *const kComments;
extern NSString *const kFilter;
extern NSString *const kTags;
extern NSString *const kImages;
extern NSString *const kVideos;
extern NSString *const kLocation;
extern NSString *const kType;

extern NSString *const kCreator;
extern NSString *const kText;

extern NSString *const kUsername;
extern NSString *const kFullName;
extern NSString *const kFirstName;
extern NSString *const kLastName;
extern NSString *const kProfilePictureURL;
extern NSString *const kBio;
extern NSString *const kWebsite;

extern NSString *const kCounts;
extern NSString *const kCountMedia;
extern NSString *const kCountFollows;
extern NSString *const kCountFollowedBy;

extern NSString *const kTagMediaCount;
extern NSString *const kTagName;

extern NSString *const kLocationLatitude;
extern NSString *const kLocationLongitude;
extern NSString *const kLocationName;

#define SGNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]) )