//
//  InstagramAPI+PrivateMethods.h
//  simplegram
//
//  Created by Admin on 15.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "InstagramAPI.h"

@interface InstagramAPI (PrivateMethods)

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(void (^)(id object))success
        failure:(void (^)(NSError* error, NSInteger serverStatusCode))failure;

@end
