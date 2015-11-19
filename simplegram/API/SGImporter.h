//
//  SGImporter.h
//  simplegram
//
//  Created by Admin on 18.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "InstagramAPI.h"
#import "SGImporterDelegate.h"

/**
 * Обрабатывает события окончания загрузки фида.
**/
@protocol SGImporterDelegate;

/**
 * Класс импортирует полученные данные с API Instagram в БД
**/
@interface SGImporter : NSObject

@property (nonatomic, retain) InstagramAPI *webservice;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, weak) id<SGImporterDelegate> delegate;

-(instancetype) initWithContext:(NSManagedObjectContext *)context;

/**
 * Импортировать популярные записи
**/
-(void) importPopular;

/**
 * Импортировать фид авторизированного юзера
**/
-(void) importSelfFeed;

@end
