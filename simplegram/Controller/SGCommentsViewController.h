//
//  SGCommentsViewController.h
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseViewController.h"

@interface SGCommentsViewController : SGBaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, retain) NSManagedObjectID *mediaID;
@property (weak, nonatomic) IBOutlet UITextField *commentPlaceholder;

@end
