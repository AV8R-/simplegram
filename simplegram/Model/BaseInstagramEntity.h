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
 * Виртуальный констркутор, переопределен в подкласах
 * param JSON с полями объекта
 **/
- (instancetype)initWithInfo:(NSDictionary *)info;

/**
 * Конструктор для создания/загрузки сущности в указанном ManagedObjectContext
**/
- (instancetype)initWithInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext* _Nullable)moc;

/**
 * Базовый констркутор создает объект определенноо подласса
 * @param info - JSON с полями объекта
 * @param modelClass - конкретный класс
 **/
- (instancetype)initWithInfo:(NSDictionary *)info subclass:(Class)modelClass withMoc:(NSManagedObjectContext *)moc;

/**
 *Возвращает массив сущностей инстаграма с указанным ID, которые уже храняться в БД
 *@param modelClass - конкретный класс
 *@param instagramID
 **/
+(NSArray *)findExsistingEntity:(Class)modelClass WithInstagramId:(NSString *)instagramID;

/**
 * Вызывается каждый раз при обновлении JSON'ом с сервера Instagram
 * @param info - JSON конкрентной сущности
 **/
-(void) updateDetails:(NSDictionary *)info;

- (BOOL)isEqualToModel:(BaseInstagramEntity *)model;

@end

NS_ASSUME_NONNULL_END

#import "BaseInstagramEntity+CoreDataProperties.h"
