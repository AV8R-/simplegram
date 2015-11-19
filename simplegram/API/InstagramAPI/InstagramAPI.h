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

#pragma mark Base calls

/**
 * Базовый GET-запрос к API Instagram. Получает одну сущность
**/
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSDictionary* json))success
        failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

/**
 * Базовый GET-запрос к API Instagram получает массив сущностей.
**/
- (void)getArrayFromPath:(NSString *)path
              parameters:(NSDictionary *)parameters
           responseModel:(Class)modelClass
                 success:(void (^)(NSArray *models))success
                 failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;


/**
 * Базовый POST-запрос к API Instagram
**/
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
   responseModel:(Class)modelClass
         success:(void (^)(id object))success
         failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

#pragma mark Endpoints
/**
 * Запрос на получение фида "популярное"
**/
- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

/**
 * Запрос на получение собственного фида
**/
- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(NSString *)maxId
                     success:(void (^)(NSArray *media))success
                     failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

@end
