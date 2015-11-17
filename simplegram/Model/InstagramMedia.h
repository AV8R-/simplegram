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

@protocol InstagramMediaDownloadDelegate;

@class InstagramComment, InstagramUser;

NS_ASSUME_NONNULL_BEGIN

@interface InstagramMedia : BaseInstagramEntity <NSURLSessionDownloadDelegate>

/**
 * Передает события загрузки изображений, миниатюры и видео
**/
@property (nonatomic, weak) id<InstagramMediaDownloadDelegate> downloadDelegate;

/**
 * Размер миниатюры
**/
@property (nonatomic, readonly) CGSize thumbnailFrameSize;

/**
 *  Размер картинки с маленьким разрешением
 */
@property (nonatomic, readonly) CGSize lowResolutionImageFrameSize;

/**
 * Стандартный размер картинки
**/
@property (nonatomic, readonly) CGSize standardResolutionImageFrameSize;

/**
 * Размер видео с маленьким разрешением
**/
@property (nonatomic, readonly) CGSize lowResolutionVideoFrameSize;

/**
 * Размер видео в стандартном разрешении
**/
@property (nonatomic, readonly) CGSize standardResolutionVideoFrameSize;

@property (nonatomic, strong) UIImage *photo;

- (BOOL)isEqualToMedia:(InstagramMedia *)media;

@end

NS_ASSUME_NONNULL_END

#import "InstagramMedia+CoreDataProperties.h"
