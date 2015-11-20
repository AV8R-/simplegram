//
//  InstagramComment.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "InstagramComment.h"
#import "InstagramUser.h"
#import "InstagramComment+CoreDataProperties.h"
#import "InstagramAPIConstants.h"

@implementation InstagramComment
@synthesize moc;

/* Мусор. Вся логика создания была перенесена в базовый класс
-(instancetype) initWithInfo:(NSDictionary *)info
{
    self = [self initWithInfo:info managedObjectContext:nil];
    
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithInfo:info subclass:[InstagramComment class] withMoc:managedObjectContext];
    
    if(self && info && [info isKindOfClass:[NSDictionary class]]) {
        //[self updateDetails:info];
    }
    
    return self;
}
 */

-(void) updateDetails:(NSDictionary *)info
{
    if (info && [info isKindOfClass:[NSDictionary class]] && self.createdDate == nil) {
        self.user = [BaseInstagramEntity findOrCreateEntity:[InstagramUser class]
                                                     WithId:info[kCreator][kID]
                                                  inContext:self.moc];
        [self.user updateDetails:info[kCreator]];
        //self.user = [[InstagramUser alloc] initWithInfo:info[kCreator] managedObjectContext:self.moc];
        self.text = [[NSString alloc] initWithString:info[kText]];
        self.createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
    }
}

#pragma mark Getters
-(InstagramUser*) getCreatorwithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    id creatorID = self.user;
    InstagramUser *creator;
    if ([creator isKindOfClass:[NSManagedObjectID class]]) {
        creator = [managedObjectContext objectWithID:creatorID];
    }
    else {
        creator = (InstagramUser*)creatorID;
    }
    
    return creator;
}


@end
