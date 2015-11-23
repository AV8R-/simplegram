//
//  SGExporter.h
//  simplegram
//
//  Created by Admin on 23.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SGExporter : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(instancetype) initWithManagedObjectContext:(NSManagedObjectContext*)moc;

-(NSMutableArray*) readFeed;

@end
