//
//  InstagramAPI.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramAPI : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, copy) NSString *appClientID;
@property (nonatomic, copy) NSString *appRedirectURL;
@property (nonatomic, strong) NSString *accessToken;

#pragma mark Authentication

-(NSURL *)autorizationURL;
-(void) logout;
-(BOOL) isSessionValid;
-(BOOL)receivedValidAccessTokenFromURL:(NSURL *)url;

#pragma mark Media access
- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(NSString *)maxId
                     success:(void (^)(NSArray *media))success
                     failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

@end
