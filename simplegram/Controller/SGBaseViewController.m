//
//  SGBaseViewController.m
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGBaseViewController.h"
#import "AppDelegate.h"

@interface SGBaseViewController ()

@end

@implementation SGBaseViewController

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
