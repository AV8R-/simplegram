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
#import "SGBaseTableViewController.h"
#import "SGExporter.h"

@interface SGFeedTableViewController : SGBaseTableViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, SGImporterDelegate, NSURLSessionDownloadDelegate>


@property (strong, nonatomic) IBOutlet UITableView *feedTableView;

/**
 * Массив, в котором хранятся объекты InstagramMedia.
 * Фид, полученный с сервера
**/
@property (strong, nonatomic) NSMutableArray *feed;

/**
 * Доступ к функции проверки логина
**/
@property (nonatomic, strong) InstagramAPI *api;


/**
 * Управляет загрузками данных с севера инстаграмм
 * Сохраняет полученные JSON-ки в сущности Core Data
**/
@property (nonatomic, strong) SGImporter *importer;

/**
 * Управляет чтением данных из БД
**/
@property (nonatomic, strong) SGExporter *exporter;

/**
 * Показывает окно с логином или разлогинивает пользователя.
**/
- (IBAction)logInOrout:(id)sender;

/**
 * Кнопка логина или разлогина. Нужно менять название каждый раз, когда состояние сессии изменяется.
**/
@property (weak, nonatomic) IBOutlet UIButton *logInOrOutButton;

/**
 * Активные загрузки (изображений)
**/
@property (nonatomic, strong) NSMutableArray *activeTasks;

@end
