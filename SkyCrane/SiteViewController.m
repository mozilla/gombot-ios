//
//  SiteViewController.m
//  SkyCrane
//
//  Created by Dan Walkowski on 11/9/12.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import "SiteViewController.h"
#import "LaunchCell.h"
#import "DetailViewController.h"

@interface SiteViewController ()

@end

@implementation SiteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  //not actually sorting at the moment
  _sortedKeys = [_sites allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  return [[_sites allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LaunchCell";
    LaunchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
    // Configure the cell...

    NSDictionary* siteItem = [_sites objectForKey:[_sortedKeys objectAtIndex:[indexPath row]]];
  
    cell.name = [siteItem objectForKey:@"name"];
    cell.login = [siteItem objectForKey:@"login"];
    cell.url = [_sortedKeys objectAtIndex:[indexPath row]];
    cell.pass = [siteItem objectForKey:@"password"];

    cell.nameLbl.text = cell.name;
    cell.loginLbl.text = cell.login;
    cell.urlLbl.text = cell.url;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  LaunchCell *cell = (LaunchCell*)sender;
  //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  
  NSArray* selectionData = @[cell.name, cell.login, cell.url, cell.pass];

  DetailViewController *destination = segue.destinationViewController;
  [destination setData: selectionData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LaunchCell* selectedCell = (LaunchCell*)[tableView cellForRowAtIndexPath:indexPath];
  [selectedCell setSelected:FALSE];
  
  //put password on the pasteboard
  UIPasteboard *board = [UIPasteboard generalPasteboard];
  [board setString:selectedCell.pass];

  //launch to the site
  NSURL *url = [NSURL URLWithString:selectedCell.url];
  NSLog(@"%@", url);
  BOOL result = [[UIApplication sharedApplication] openURL:url];
  if (!result) NSLog(@": url launch failed: %@", url);

}

@end
