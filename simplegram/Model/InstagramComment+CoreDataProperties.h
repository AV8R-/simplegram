//
//  InstagramComment+CoreDataProperties.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InstagramComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstagramComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdDate;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) InstagramUser *user;

@end

NS_ASSUME_NONNULL_END
