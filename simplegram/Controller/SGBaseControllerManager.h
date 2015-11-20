//
//  SGBaseControllerManager.h
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SGBaseControllerManager : NSObject

/**
 * Основной MOC используется для получения данных из БД, Оперативной работы с БД
 **/
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/**
 * Фоновый MOC используется для фоновой подгрузки новых данных с севрера Instagram
 **/
@property (nonatomic, strong) NSManagedObjectContext *backgroundManagedObjectContext;

/**
 * Возвращает строку "прошло врмени с момента публикации
 **/
-(NSString *) stringIntervalSinceDate:(NSDate *)date;

@end
