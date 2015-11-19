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

/* мусор. Логика создания была полностью перенесена в базовый класс
- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [self initWithInfo:info managedObjectContext:nil];
    
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)moc
{
    self = [super initWithInfo:info subclass:[InstagramUser class] withMoc:moc];
    
    if (self && info && [info isKindOfClass:[NSDictionary class]]) {
        //[self updateDetails:info];
    }
    
    return self;
}
 */

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
