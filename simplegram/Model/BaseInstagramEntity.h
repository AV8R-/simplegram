//
//  BaseInstagramEntity.h
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseInstagramEntity : NSManagedObject

@property (nonatomic, retain) NSManagedObjectContext *moc;

/**
 * Конструктор для поиска в БД или создания сущности Instagram API с указанным Instagram ID
 * @param modelClass - указать конкретный класс создаваемой сущности
 * @param instagramId - ID сущности, полученный с сервера Instagram
 * @param context - контекст Core Data в котором создается или ищется сущность
**/
+(id) findOrCreateEntity:(Class)modelClass
                  WithId:(NSString*)instagramId
               inContext:(NSManagedObjectContext *)context;

/**
 *Возвращает массив сущностей инстаграма с указанным ID, которые уже хранятся в БД
 *@param modelClass - конкретный класс
 *@param instagramID
 **/
+(NSArray *)findExsistingEntity:(Class)modelClass
                WithInstagramId:(NSString *)instagramID;

/**
 * Абстрактный метод, должен быть переопределен в подклассах
 * Вызывается каждый раз при обновлении JSON'ом с сервера Instagram
 * @param info - JSON конкрентной сущности
 **/
-(void)updateDetails:(NSDictionary *)info;

/**
 * Проверка сущностей на тождественность
**/
-(BOOL)isEqualToModel:(BaseInstagramEntity *)model;

@end

NS_ASSUME_NONNULL_END

#import "BaseInstagramEntity+CoreDataProperties.h"
