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

-(instancetype) initWithInfo:(NSDictionary *)info
{
    self = [self initWithInfo:info managedObjectContext:nil];
    
    return self;
}

- (instancetype)initWithInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithInfo:info subclass:[InstagramComment class] withMoc:managedObjectContext];
    
    [self updateDetails:info];
    
    return self;
}

-(void) updateDetails:(NSDictionary *)info
{
    if (info && [info isKindOfClass:[NSDictionary class]]) {
        self.user = [[InstagramUser alloc] initWithInfo:info[kCreator] managedObjectContext:self.moc];
        self.text = [[NSString alloc] initWithString:info[kText]];
        self.createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
    }
    
    NSError *error;
    [self.moc save:&error];
    if(error) {
        NSLog(@"%@", error);
    }
}


@end
