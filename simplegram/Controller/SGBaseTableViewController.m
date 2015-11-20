//
//  SGBaseTableViewController.m
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGBaseTableViewController.h"

@interface SGBaseTableViewController ()

@end

@implementation SGBaseTableViewController

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.manager = [[SGBaseControllerManager alloc] init];
    
    return self;
}

-(NSManagedObjectContext*)managedObjectContext
{
    return self.manager.managedObjectContext;
}

-(NSManagedObjectContext*)backgroundManagedObjectContext
{
    return self.manager.backgroundManagedObjectContext;
}

/**
 * Возвращает строку "прошло врмени с момента публикации
 **/
-(NSString *) stringIntervalSinceDate:(NSDate *)date
{
    return [self.manager stringIntervalSinceDate:date];
}

@end
