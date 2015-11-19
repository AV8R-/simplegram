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

/*
* Вызывается в каждом конкретном классе
* В первую очередь проверяет есть ли эта сущность уже в БД
* Если есть - она обновляется полученным JSON'ом
* Если нет - создается новая
*/
- (instancetype)initWithInfo:(NSDictionary *)info subclass:(Class)modelClass withMoc:(NSManagedObjectContext*)managedObjectContext
{
    if(info && [info isKindOfClass:[NSDictionary class]]) {
        NSString *instagramID = SGNotNull(info[kID]) ? [[NSString alloc] initWithString:info[kID]] : nil;
        
        NSArray *sameEntities = [BaseInstagramEntity findExsistingEntity:modelClass WithInstagramId:instagramID managedObjectContext:managedObjectContext];
        if (sameEntities && [sameEntities count] > 0) {
            self = [sameEntities objectAtIndex:0];
        }
        else {
            self = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(modelClass)
                                                 inManagedObjectContext:managedObjectContext];
            self.instagramId = instagramID;
        }
        
        if (managedObjectContext != nil) {
            self.moc = managedObjectContext;
        }
        else {
            self.moc = [[NSManagedObjectContext alloc] init];
            self.moc.persistentStoreCoordinator = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) persistentStoreCoordinator];
        }
    }
    
    return self;
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
