//
//  InstagramComment.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInstagramEntity.h"

@class InstagramUser;

NS_ASSUME_NONNULL_BEGIN

@interface InstagramComment : BaseInstagramEntity

-(InstagramUser*) getCreatorwithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "InstagramComment+CoreDataProperties.h"
