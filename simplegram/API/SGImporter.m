//
//  SGImporter.m
//  simplegram
//
//  Created by Admin on 18.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGImporter.h"
#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "InstagramComment.h"
#import "InstagramAPIConstants.h"

@implementation SGImporter

-(instancetype) initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    self.webservice = [InstagramAPI sharedInstance];
    self.context = context;
    return self;
}

-(void) importPopular
{
    [self.webservice getPopularMediaWithSuccess:^(NSArray *feed)
    {
        [self.context performBlock:^
        {
            for (NSDictionary *mediaJSON in feed) {
                if (![mediaJSON isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                InstagramMedia *media = [BaseInstagramEntity findOrCreateEntity:[InstagramMedia class]
                                                                         WithId:mediaJSON[kID]
                                                                      inContext:self.context];
                [media updateDetails:mediaJSON];
                
                NSError *error;
                if(![self.context save:&error]) NSLog(@"%@", error);
                
                
                if([self.delegate respondsToSelector:@selector(loadingFeedDidEnd)])
                    [self.delegate loadingFeedDidEnd];
            }
        }];
    } failure:^(NSError *error, NSInteger code)
    {
        NSLog(@"%@", error);
    }];
}

@end
