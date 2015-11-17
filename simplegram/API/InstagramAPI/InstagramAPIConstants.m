//
//  InstagramAPIConstants.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "InstagramAPIConstants.h"

NSString *const kInstagramAPIBaseScheme = @"https";
NSString *const kInstagramAPIBaseUrl = @"api.instagram.com";
NSString *const kInstagramBasePath = @"/v1/";
NSString *const kInstagramAuthorizationPath = @"/oauth/authorize/";

NSString *const kInstagramClientIdConfigurationKey = @"InstagramAppClientId";

NSString *const kInstagramRedirectUrlConfigurationKey = @"InstagramAppRedirectURL";

NSString *const kKeyClientID = @"client_id";
NSString *const kKeyAccessToken = @"access_token";

NSString *const kPaginationKeyMaxId = @"max_id";


#pragma mark JSON keys


NSString *const kID = @"id";
NSString *const kCount = @"count";
NSString *const kURL = @"url";
NSString *const kHeight = @"height";
NSString *const kWidth = @"width";
NSString *const kData = @"data";

NSString *const kThumbnail = @"thumbnail";
NSString *const kLowResolution = @"low_resolution";
NSString *const kStandardResolution = @"standard_resolution";

NSString *const kMediaTypeImage = @"image";
NSString *const kMediaTypeVideo = @"video";

NSString *const kUser = @"user";
NSString *const kUserHasLiked = @"user_has_liked";
NSString *const kCreatedDate = @"created_time";
NSString *const kLink = @"link";
NSString *const kCaption = @"caption";
NSString *const kLikes = @"likes";
NSString *const kComments = @"comments";
NSString *const kFilter = @"filter";
NSString *const kTags = @"tags";
NSString *const kImages = @"images";
NSString *const kVideos = @"videos";
NSString *const kLocation = @"location";
NSString *const kType = @"type";

NSString *const kCreator = @"from";
NSString *const kText = @"text";

NSString *const kUsername = @"username";
NSString *const kFullName = @"full_name";
NSString *const kFirstName = @"first_name";
NSString *const kLastName = @"last_name";
NSString *const kProfilePictureURL = @"profile_picture";
NSString *const kBio = @"bio";
NSString *const kWebsite = @"website";

NSString *const kCounts = @"counts";
NSString *const kCountMedia = @"media";
NSString *const kCountFollows = @"follows";
NSString *const kCountFollowedBy = @"followed_by";

NSString *const kTagMediaCount = @"media_count";
NSString *const kTagName = @"name";

NSString *const kLocationLatitude = @"latitude";
NSString *const kLocationLongitude = @"longitude";
NSString *const kLocationName = @"name";

NSString *const kNextURL = @"next_url";
NSString *const kNextMaxId = @"next_max_id";
NSString *const kNextMaxLikeId = @"next_max_like_id";
NSString *const kNextMaxTagId = @"next_max_tag_id";
NSString *const kNextCursor = @"next_cursor";

NSString *const kMaxId = @"max_id";
NSString *const kMaxLikeId = @"max_like_id";
NSString *const kMaxTagId = @"max_tag_id";
NSString *const kCursor = @"cursor";