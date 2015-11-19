//
//  InstagramMedia.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "BaseInstagramEntity.h"

@class InstagramComment, InstagramUser;

NS_ASSUME_NONNULL_BEGIN

@interface InstagramMedia : BaseInstagramEntity <NSURLSessionDownloadDelegate>

/**
 * Указатель на фотографию поста
**/
@property (nonatomic, retain) UIImage *photo;

/**
 * По пока невыясненным причинам иногда юзер хранится моделью в ОЗУ, иногда ссылкой на сущность БД
 * Поэтому эта функция возвращает создателя поста
**/
-(InstagramUser*) getCreatorwithManagedObjectContext:(NSManagedObjectContext*)moc;

/**
 * ^^^
 * По той же причине аналогичный геттер для описания
**/
-(InstagramComment*) getCaptionwithManagedObjectContext:(NSManagedObjectContext*)moc;

- (BOOL)isEqualToMedia:(InstagramMedia *)media;

@end

NS_ASSUME_NONNULL_END

#import "InstagramMedia+CoreDataProperties.h"
