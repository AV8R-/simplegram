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

/**
 * Возвращает URL авторизации для открытия его в webView
**/
-(NSURL *)autorizationURL;

/**
 * Метод разлогина. По сути удаляет только токен. Разлогин на сервере не происходит.
 * При следующей попытке авторизации на сервере, он вернет токен без запроса логина и пароля
**/
-(void) logout;

/**
 * Проверяет залонился ли пользователь
 * Внутри просто проверяет указан ли токен.
**/
-(BOOL) isSessionValid;

/**
 * Парсит токен, полученый в url и сохраняет его.
**/
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

/**
 * Отправляет запрос на создание комментария
**/
- (void) sendComment:(NSString*)text
           toMediaID:(NSString*)mediaID
         withSuccess:(void(^)(NSDictionary *serverResponse))success
             failure:(void(^)(NSError* error, NSInteger serverStatusCode))failure;
/**
 * Загружает картинку для InstagramMedia
 * @param URL - URL картинки
 * @param loading - callback, вызываемый во время загрузки, преедает состояние загрузки
 * @param loadDidEnd - callback, вызываемый когда загрузка завершилась
**/
- (void) downloadImageFromURL:(NSURL*)url
          withLoadingCallback:(void(^)(NSNumber *progress))loading;

@end
