//
//  InstagramUser+CoreDataProperties.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InstagramUser+CoreDataProperties.h"

@implementation InstagramUser (CoreDataProperties)

@dynamic username;
@dynamic fullName;
@dynamic profilePictureURL;
@dynamic bio;
@dynamic website;
@dynamic mediaCount;
@dynamic followsCount;
@dynamic followedByCount;

@end
