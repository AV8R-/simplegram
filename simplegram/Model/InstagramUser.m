//
//  InstagramUser.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "InstagramUser.h"
#import "InstagramAPIConstants.h"

@implementation InstagramUser
@synthesize photo;

- (void)updateDetails:(NSDictionary *)info
{
    if (info && [info isKindOfClass:[NSDictionary class]] && self.username == nil) {
        self.username = [[NSString alloc] initWithString:info[kUsername]];
        self.fullName = [[NSString alloc] initWithString:info[kFullName]];

        self.profilePictureURL = (info[kProfilePictureURL]) ? info[kProfilePictureURL] : nil;
        self.bio = (info[kBio]) ? [[NSString alloc] initWithString:info[kBio]] : nil;
        self.website = (info[kWebsite]) ? info[kWebsite] : nil;
        
        if (info[kCounts])
        {
            self.mediaCount = [NSNumber numberWithInteger:[(info[kCounts])[kCountMedia] integerValue]];
            self.followsCount = [NSNumber numberWithInteger:[(info[kCounts])[kCountFollows] integerValue]];
            self.followedByCount = [NSNumber numberWithInteger:[(info[kCounts])[kCountFollowedBy] integerValue]];
        }
    }
}

@end
