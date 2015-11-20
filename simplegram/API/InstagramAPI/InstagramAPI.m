//
//  InstagramAPI.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "InstagramAPI.h"
#import "InstagramAPIConstants.h"
#import "BaseInstagramEntity.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"
#import "InstagramComment.h"
#import "AppDelegate.h"

@interface InstagramAPI()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation InstagramAPI

#pragma mark Initialization
#pragma mark -

+(instancetype) sharedInstance
{
    static InstagramAPI *_sharedinstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedinstance = [[InstagramAPI alloc] init];
    });
    
    return _sharedinstance;
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([self isSessionValid]) {
            [config setHTTPAdditionalHeaders:@{kKeyAccessToken: self.accessToken}];
        }
        config.timeoutIntervalForRequest = 30.0;
        config.timeoutIntervalForResource = 60.0;
        
        self.session = [NSURLSession sessionWithConfiguration:config];
        
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        self.appClientID = info[kInstagramClientIdConfigurationKey];
        self.appRedirectURL = info[kInstagramRedirectUrlConfigurationKey];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = [[appDelegate managedObjectContext] persistentStoreCoordinator];
        
        //TODO: Попытаться залогинится с cliendID. Нужно для того, чтобы не вводить пароль повторно при каждом входе в приложение.
    }
    
    return self;
}

#pragma mark Authorization
#pragma mark -

-(NSURL *)autorizationURL
{
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:kInstagramAPIBaseScheme];
    [components setHost:kInstagramAPIBaseUrl];
    [components setPath:kInstagramAuthorizationPath];
    [components setQuery:[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",
                                                      @"client_id", self.appClientID,
                                                      @"redirect_uri", self.appRedirectURL,
                                                      @"response_type", @"token",
                                                      @"scope", @"comments"
                          ]];
    
    return [components URL];
}

- (BOOL)isSessionValid
{
    return self.accessToken != nil;
}

-(void) logout
{
    self.accessToken = nil;
}

- (BOOL)receivedValidAccessTokenFromURL:(NSURL *)url
{
    NSURL *appRedirectURL = [NSURL URLWithString:self.appRedirectURL];
    if (![appRedirectURL.scheme isEqual:url.scheme] || ![appRedirectURL.host isEqual:url.host])
    {
        return NO;
    }
    
    BOOL success = YES;
    NSString *token = [self queryStringParametersFromString:url.fragment][kKeyAccessToken];
    if (token)
    {
        self.accessToken = token;
    }
    else
    {
        success = NO;
    }
    return success;
}

#pragma mark Parameters
#pragma mark -

/**
 * Возвращает парметры с данными авторизации.
**/
- (NSDictionary *)dictionaryWithAccessTokenAndParameters:(NSDictionary *)params
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.accessToken) {
        [mutableDictionary setObject:self.accessToken forKey:kKeyAccessToken];
    }
    else
    {
        [mutableDictionary setObject:self.appClientID forKey:kKeyClientID];
    }
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

/**
 * Разбивает строку парметров GET-запроса на отдельные части. Возвращает словарь параметров
 * Используется чтобы получить token после авторизации
**/
- (NSDictionary *)queryStringParametersFromString:(NSString*)string {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [[string componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString * param, NSUInteger idx, BOOL *stop) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] != 2) return;
        
        NSString *key = [pairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:value forKey:key];
    }];
    return dict;
}

/**
 * Парамметры для запроса определенного количества сущностей
**/
- (NSDictionary *)parametersFromCount:(NSInteger)count maxId:(NSString *)maxId andPaginationKey:(NSString *)key
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (count) {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:kCount];
    }
    if (maxId) {
        [params setObject:maxId forKey:key];
    }
    return [params copy];
}

/**
 * Строит URL для указанного пути
**/
-(NSURLComponents *)urlComponentsForPath:(NSString *)path
{
    NSString *fullPath = [kInstagramBasePath stringByAppendingString:path];
    
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:kInstagramAPIBaseScheme];
    [components setHost:kInstagramAPIBaseUrl];
    [components setPath:fullPath];
    
    return components;
}

#pragma mark Base paths calls
#pragma mark -

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSDictionary* json))success
        failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLComponents *components = [self urlComponentsForPath:percentageEscapedPath];
    
    NSMutableString *query = [[NSMutableString alloc] init];
    params ? [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [query appendFormat:@"%@=%@", key, obj];
    }] : 0;
    [components setQuery:query];
    
    NSURLSessionTask *getTask = [self.session dataTaskWithURL:components.URL
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                if (!error) {
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                    if (httpResp.statusCode == 200) {
                                                        NSError *jsonError;
                                                        
                                                        id recievedJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                                          options:NSJSONReadingAllowFragments
                                                                                                            error:&jsonError];
                                                        if (!jsonError && [recievedJSON isKindOfClass:[NSDictionary class]]) {
                                                            NSDictionary *dataDictionary = (NSDictionary*)recievedJSON[kData];
                                                            success(dataDictionary);
                                                        }
                                                        else {
                                                            (failure)? failure(error, httpResp.statusCode) : 0;
                                                        }
                                                    }
                                                }
                                            }];
    [getTask resume];
    
}

- (void)getArrayFromPath:(NSString *)path
              parameters:(NSDictionary *)parameters
           responseModel:(Class)modelClass
                 success:(void (^)(NSArray *models))success
                 failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLComponents *components = [self urlComponentsForPath:percentageEscapedPath];
    
    NSMutableString *query = [[NSMutableString alloc] init];
    params ? [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [query appendFormat:@"%@=%@", key, obj];
    }] : 0;
    [components setQuery:query];
    
    NSURLSessionTask *getTask = [self.session dataTaskWithURL:components.URL
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                if (!error) {
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                    if (httpResp.statusCode == 200) {
                                                        NSError *jsonError;
                                                        
                                                        id recievedJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                     options:NSJSONReadingAllowFragments
                                                                                                                       error:&jsonError];
                                                        if (!jsonError && [recievedJSON isKindOfClass:[NSDictionary class]]) {
                                                            NSArray *dataArray = ((NSDictionary*)recievedJSON)[kData];
                                                            success(dataArray);
                                                        }
                                                        else {
                                                            (failure)? failure(error, httpResp.statusCode) : 0;
                                                        }
                                                    }
                                                }
                                            }];
    [getTask resume];
    
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
   responseModel:(Class)modelClass
         success:(void (^)(id object))success
         failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure
{
    NSDictionary *params = [self dictionaryWithAccessTokenAndParameters:parameters];
    NSURLComponents *components = [self urlComponentsForPath:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
        
        if (error && httpResp.statusCode != 200) {
            (failure) ? failure(error,httpResp.statusCode) : 0;
        }
        else {
            NSError *jsonError;
            
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&jsonError];
            if (jsonError) {
                (failure) ? failure(jsonError, 0) : 0;
            }
            else {
                (success) ? success(jsonDictionary) : 0;
            }
        }
    }];
    
    [postDataTask resume];
}

#pragma mark Endpoints
#pragma mark -
#pragma mark Media

- (void)getPopularMediaWithSuccess:(void (^)(NSArray *media))success
                           failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure
{
    [self getArrayFromPath:@"media/popular"
                parameters:nil
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

- (void)getSelfFeedWithCount:(NSInteger)count
                       maxId:(NSString *)maxId
                     success:(void (^)(NSArray *media))success
                     failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure
{
    NSDictionary *params = [self parametersFromCount:count maxId:maxId andPaginationKey:kPaginationKeyMaxId];
    [self getArrayFromPath:[NSString stringWithFormat:@"users/self/feed"]
                parameters:params
             responseModel:[InstagramMedia class]
                   success:success
                   failure:failure];
}

#pragma mark -
#pragma mark Comments
- (void) sendComment:(NSString*)text
           toMediaID:(NSString*)mediaID
         withSuccess:(void(^)(NSDictionary *serverResponse))success
             failure:(void(^)(NSError* error, NSInteger serverStatusCode))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[text] forKeys:@[@"text"]];
    [self postPath:[NSString stringWithFormat:@"media/%@/comments",mediaID]
        parameters:params
     responseModel:nil
           success:success
           failure:failure];
}
@end
