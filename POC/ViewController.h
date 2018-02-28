//
//  ViewController.h
//  POC
//
//  Created by P10-MAC-DEV-02 on 27/02/18.
//  Copyright © 2018 P10-MAC-DEV-02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
    __weak IBOutlet UITableView *tableView;
    UILabel *titleLabel;
    
}
@property (assign, nonatomic) IBOutlet TableViewCell *customCell;
@end

