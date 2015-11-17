//
//  InstagramUser+CoreDataProperties.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InstagramUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstagramUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *profilePictureURL;
@property (nullable, nonatomic, retain) NSString *bio;
@property (nullable, nonatomic, retain) NSString *website;
@property (nullable, nonatomic, retain) NSNumber *mediaCount;
@property (nullable, nonatomic, retain) NSNumber *followsCount;
@property (nullable, nonatomic, retain) NSNumber *followedByCount;

@end

NS_ASSUME_NONNULL_END
