//
//  SGBaseViewController.h
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SGBaseControllerManager.h"

@interface SGBaseViewController : UIViewController

@property (nonatomic, strong) SGBaseControllerManager *manager;

-(NSManagedObjectContext*)managedObjectContext;

-(NSManagedObjectContext*)backgroundManagedObjectContext;

/**
 * Возвращает строку "прошло врмени с момента публикации
 **/
-(NSString *) stringIntervalSinceDate:(NSDate *)date;

@end
