//
//  ViewController.m
//  POC
//
//  Created by P10-MAC-DEV-02 on 27/02/18.
//  Copyright © 2018 P10-MAC-DEV-02. All rights reserved.
//

#import "ViewController.h"
#import "BusinessHandler.h"
#import "TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
{
    
}
 @property (strong) UITableViewCell *cellPrototype;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    CGRect labelFrame = CGRectMake(0.0, 0.0, 120.0, 36.0);
    titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refresh];
    
   
    tableView.separatorColor = [UIColor clearColor];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 80;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{

    [self loadDataToTableView];
    
    
}
-(void)loadDataToTableView
{
    dataArray =nil;
    [[BusinessHandler sharedInstance] GetServiceForPost:@"https://www.dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json" completionHandler:^(NSDictionary *downloadDict){
        
        titleLabel.text = [downloadDict valueForKey:@"title"];
        dataArray = [downloadDict valueForKey:@"rows"];
        [tableView reloadData];
    }
                              andErrorcompletionHandler:^(NSString *errormessage) {
                                  
                              }];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (NSString *)quotationTextForRow:(NSString*)row {
    return row;
}

- (NSString *)attributionTextForRow:(NSString*)row {
    return row;
}

- (CGSize)sizeForLabel:(UILabel *)label {
    
    
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    //    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect textRect = [label.text boundingRectWithSize:constrain
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                               context:nil];
    
    CGSize size = textRect.size;
    
   
    
    
    
    
    return size;
}

- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {
     CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    return [label.text boundingRectWithSize:constrain
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                    context:nil].size;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //set width depending on device orientation
    self.cellPrototype.frame = CGRectMake(self.cellPrototype.frame.origin.x, self.cellPrototype.frame.origin.y, tableView.frame.size.width, self.cellPrototype.frame.size.height);
    
    CGFloat quotationLabelHeight = 0;
    CGFloat attributionLabelHeight = 0;
     if(![[[dataArray objectAtIndex:indexPath.row]valueForKey:@"title"] isKindOfClass:[NSNull class]])
     {
          UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, tableView.frame.size.width-88, 0)];
         //nameLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
         
         nameLabel.text = [[dataArray objectAtIndex:indexPath.row]valueForKey:@"title"];
         nameLabel.font = [UIFont systemFontOfSize:14];
         
            CGSize size =  [self sizeForLabel:nameLabel];
       
         
         quotationLabelHeight =  size.height;
     }
    if(![[[dataArray objectAtIndex:indexPath.row]valueForKey:@"description"] isKindOfClass:[NSNull class]])
    {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, tableView.frame.size.width-88, 0)];
        //nameLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        
        nameLabel.text = [[dataArray objectAtIndex:indexPath.row]valueForKey:@"description"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        
        CGSize size =  [self sizeForLabel:nameLabel];
        
        attributionLabelHeight = size.height;
    }
    
    CGFloat padding = self.cellPrototype.textLabel.frame.origin.y;
    
    CGFloat combinedHeight = padding + quotationLabelHeight + padding/2 + attributionLabelHeight + padding;
    CGFloat minHeight = 80;
    
    return MAX(combinedHeight, minHeight);
}



-(NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section    {
    return [dataArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
      cell.imageView.frame =  CGRectMake(0, 0, 88, 88);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    if(![[[dataArray objectAtIndex:indexPath.row]valueForKey:@"imageHref"] isKindOfClass:[NSNull class]])
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row]valueForKey:@"imageHref"]]
                         placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    CGFloat quotationLabelHeight = 0;
    CGFloat attributionLabelHeight = 0;
    if(![[[dataArray objectAtIndex:indexPath.row]valueForKey:@"title"] isKindOfClass:[NSNull class]])
    {
     quotationLabelHeight = [self sizeOfLabel:cell.textLabel withText:[self quotationTextForRow:[[dataArray objectAtIndex:indexPath.row]valueForKey:@"title"]]].height;
        cell.textLabel.frame = CGRectMake(88, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, quotationLabelHeight);
        cell.textLabel.text = [self quotationTextForRow:[[dataArray objectAtIndex:indexPath.row]valueForKey:@"title"]];
    }
    if(![[[dataArray objectAtIndex:indexPath.row]valueForKey:@"description"] isKindOfClass:[NSNull class]])
    {
     attributionLabelHeight = [self sizeOfLabel:cell.detailTextLabel withText:[self attributionTextForRow:[[dataArray objectAtIndex:indexPath.row]valueForKey:@"description"]]].height;
        cell.detailTextLabel.frame = CGRectMake(88, cell.detailTextLabel.frame.origin.y, cell.detailTextLabel.frame.size.width, attributionLabelHeight);
        cell.detailTextLabel.text = [self attributionTextForRow:[[dataArray objectAtIndex:indexPath.row]valueForKey:@"description"]];
        cell.detailTextLabel.numberOfLines = 4;
    }
    
   
    
   
    
    return cell;
    
    
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
     [refresh endRefreshing];
     [self loadDataToTableView];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
