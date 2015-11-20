//
//  BaseInstagramEntity.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "BaseInstagramEntity.h"
#import "BaseInstagramEntity+CoreDataProperties.h"
#import "InstagramAPIConstants.h"
#import "AppDelegate.h"

@implementation BaseInstagramEntity
@synthesize moc;

+(id) findOrCreateEntity:(Class)modelClass
                  WithId:(NSString*)instagramId
               inContext:(NSManagedObjectContext *)context
{
    id model;
    NSArray *sameEntities = [BaseInstagramEntity findExsistingEntity:modelClass
                                                     WithInstagramId:instagramId
                                                managedObjectContext:context];
    if (sameEntities && [sameEntities count]) {
        model = sameEntities[0];
        ((BaseInstagramEntity*)model).moc = context;
    }
    else {
        model = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(modelClass)
                                              inManagedObjectContext:context];
        [(BaseInstagramEntity*)model setValue:instagramId forKey:@"instagramId"];
        ((BaseInstagramEntity*)model).moc = context;
    }
    return model;
}

+(NSArray *)findExsistingEntity:(Class)modelClass WithInstagramId:(NSString *)instagramID managedObjectContext:(NSManagedObjectContext *)moc
{
    [moc.persistentStoreCoordinator lock];
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(modelClass)
                                              inManagedObjectContext:moc];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"instagramId==%@", instagramID];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *entities = [moc executeFetchRequest:request error:&error];
    [moc.persistentStoreCoordinator unlock];
    return entities;
}

- (BOOL)isEqualToModel:(BaseInstagramEntity *)model
{
    
    if (self == model) {
        return YES;
    }
    if (model && [model respondsToSelector:@selector(instagramId)]) {
        return [self.instagramId isEqualToString:model.instagramId];
    }
    return NO;
}

@end
