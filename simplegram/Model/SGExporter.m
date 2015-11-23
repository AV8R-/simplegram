//
//  SGExporter.m
//  simplegram
//
//  Created by Admin on 23.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGExporter.h"


@implementation SGExporter

-(instancetype) initWithManagedObjectContext:(NSManagedObjectContext*)moc
{
    self = [super init];
    
    self.managedObjectContext = moc;
    
    return self;
}

-(NSMutableArray*) readFeed
{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InstagramMedia"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSSortDescriptor *createdDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    
    [request setSortDescriptors:@[createdDateDescriptor]];
    
    NSError *error;
    NSMutableArray *feed = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

    return feed;
}

@end

