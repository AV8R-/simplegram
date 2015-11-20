//
//  SGBaseControllerManager.m
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGBaseControllerManager.h"
#import "AppDelegate.h"

@implementation SGBaseControllerManager

-(instancetype) init
{
    self = [super init];
    
    //Настройка контекстов, их синхронизация.
    
    self.managedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    self.backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSManagedObjectContextDidSaveNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification* note) {
         NSManagedObjectContext *moc = self.managedObjectContext;
         if (note.object != moc) {
             [moc performBlock:^(){
                 [moc mergeChangesFromContextDidSaveNotification:note];
             }];
         }
     }];
    
    return self;
}

- (NSManagedObjectContext *)setupManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    managedObjectContext.persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:appDelegate.managedObjectModel];
    NSError* error;
    [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                  configuration:nil
                                                                            URL:[[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"simplegram.sqlite"]
                                                                        options:nil
                                                                          error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    return managedObjectContext;
}

#pragma mark Micellaneous

-(NSString *) stringIntervalSinceDate:(NSDate *)date
{
    NSString *sinceString;
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSinceDate:date];
    timestamp /= 60.0;
    
    if (timestamp <= 60)
    {
        sinceString = [NSString stringWithFormat:@"%im ago", (int)timestamp];
    }
    else
    {
        timestamp /= 60.0;
        if(timestamp <= 24)
        {
            sinceString = [NSString stringWithFormat:@"%ih ago", (int)timestamp];
        }
        else
        {
            timestamp /= 24;
            sinceString = [NSString stringWithFormat:@"%id ago", (int)timestamp];
        }
    }
    return sinceString;
}


@end
