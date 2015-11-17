//
//  InstagramMediaDownloadDelegate.h
//  simplegram
//
//  Created by Admin on 15.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@protocol InstagramMediaDownloadDelegate <NSObject>

-(void) thumbNailDownloaded:(UIImage *)thumbNailImage;
-(void) lowResolutionImageDownloaded:(UIImage *)lowResolutionImage;
-(void) standartResolutionImageDownloaded:(UIImage *)standartResolutionImage;
-(void) standartResolutionImageDownloadingStatus:(double)downloaded;

@end
