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
                
                //Все следующие if-ы - проверка на то существующий это уже объект или новый.
                //Если новый - добавляем связи.
                /*
                if(!media.user && [mediaJSON[kCreator] isKindOfClass:[NSDictionary class]])
                {
                    InstagramUser *creator = [BaseInstagramEntity findOrCreateEntity:[InstagramUser class]
                                                                              WithId:mediaJSON[kCreator][kID]
                                                                           inContext:self.context];
                    [creator updateDetails:mediaJSON[kCreator]];
                    media.user = creator;
                }
                
                if(!media.caption && [mediaJSON[kCaption] isKindOfClass:[NSDictionary class]])
                {
                    InstagramComment *caption = [BaseInstagramEntity findOrCreateEntity:[InstagramComment class]
                                                                                 WithId:mediaJSON[kCaption][kID]
                                                                              inContext:self.context];
                    [caption updateDetails:mediaJSON[kCaption]];
                    media.caption = caption;
                }
                
                if([media.likes count] == 0 && [mediaJSON[kComments] isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary *commentJSON in mediaJSON[kComments][kData]) {
                        InstagramComment *comment = [BaseInstagramEntity findOrCreateEntity:[InstagramComment class]
                                                                                     WithId:commentJSON[kID]
                                                                                  inContext:self.context];
                        [comment updateDetails:commentJSON];
                        [media addCommentsObject:comment];
                    }
                }
                
                if([media.likes count] == 0&& [mediaJSON[kLikes] isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary *userLikedJSON in mediaJSON[kLikes][kData]) {
                        InstagramUser *liked = [BaseInstagramEntity findOrCreateEntity:[InstagramUser class]
                                                                                WithId:userLikedJSON[kID]
                                                                             inContext:self.context];
                        [liked updateDetails:userLikedJSON];
                        [media addLikesObject:liked];
                    }
                }
                */
                
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
