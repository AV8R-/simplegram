//
//  InstagramUser.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseInstagramEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstagramUser : BaseInstagramEntity

@property (nonatomic, strong) UIImage *photo;

- (void)updateDetails:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END

#import "InstagramUser+CoreDataProperties.h"
