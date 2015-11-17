//
//  BaseInstagramEntity+CoreDataProperties.h
//  simplegram
//
//  Created by Admin on 15.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BaseInstagramEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseInstagramEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *instagramId;

@end

NS_ASSUME_NONNULL_END
