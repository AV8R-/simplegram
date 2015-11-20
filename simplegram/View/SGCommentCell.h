//
//  SGCommentCell.h
//  simplegram
//
//  Created by Admin on 20.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end
