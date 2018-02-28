//
//  TableViewCell.h
//  POC
//
//  Created by P10-MAC-DEV-02 on 27/02/18.
//  Copyright © 2018 P10-MAC-DEV-02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
{
    @public
     __weak IBOutlet UIImageView *profileImage;
     __weak IBOutlet UILabel *title;
     __weak IBOutlet UILabel *description;
}
+ (NSString *)reuseIdentifier;
@end
