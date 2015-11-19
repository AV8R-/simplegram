//
//  SGFeedTableViewController.h
//  simplegram
//
//  Created by Admin on 16.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramAPI.h"
#import "SGImporterDelegate.h"
#import "SGImporter.h"

@interface SGFeedTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, SGImporterDelegate>


@property (strong, nonatomic) IBOutlet UITableView *feedTableView;

/**
 * Массив, в котором храняться объекты InstagramMedia. 
 * Фид, полученный с сервера
**/
@property (strong, nonatomic) NSMutableArray *feed;
//@property (nonatomic, strong) InstagramAPI *api;

/**
 * Основной MOC используется для получения данных из БД, Оперативной работы с БД
**/
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/**
 * Фоновый MOC используется для фоновой подгрузки новых данных с севрера Instagram
**/
@property (nonatomic, strong) NSManagedObjectContext *backgroundManagedObjectContext;

/**
 * Управляет загрузками данных с севера инстаграмм
 * Маппит полученные JSON-ки в сущности Core Data
**/
@property (nonatomic, strong) SGImporter *importer;

@end
