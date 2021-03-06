//
//  SiteViewController.m
//  SkyCrane
//
//  Created by Dan Walkowski on 11/9/12.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import"AppDelegate.h"
#import "SiteViewController.h"
#import "LaunchCell.h"
#import "DetailViewController.h"
#import "Site.h"
#import "GombotDB.h"

@interface SiteViewController ()

@end

@implementation SiteViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//
//    }
//    return self;
//}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //hide the search bar until they swipe it down
  self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
  _searchHits = [NSMutableArray array];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(refreshTable)
   name:@"DataRefreshed"
   object:nil];

}

- (void) refreshTable
{
  @try
  {
    [GombotDB loadDataFile];
  }
  @catch (NSException *exception)
  {
    NSLog(@"%@", exception);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Error"
                          message: @"Error Loading Data"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];  
    return;
  }

  [self.tableView reloadData];
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
  if (tableView == self.tableView)
  {
    return [[GombotDB getSites] count];
  }
  else
    return [_searchHits count];
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  if (section == 0)
  {
    UILabel* info = [[UILabel alloc] init];
    info.numberOfLines = 1;
    info.text = @"tap to copy password and launch";
    info.backgroundColor = [UIColor blackColor];
    info.textColor = [UIColor whiteColor];
    info.font = [UIFont boldSystemFontOfSize:16];
    info.textAlignment = NSTextAlignmentCenter;
    return info;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LaunchCell";
    LaunchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (tableView == self.tableView)
      cell.site = [[GombotDB getSites] objectAtIndex:[indexPath row]];
    else
      cell.site = [_searchHits objectAtIndex:[indexPath row]];
    [cell reset];
    return cell;
}


#pragma mark - segue code

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  LaunchCell *cell = (LaunchCell*)sender;
  //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  
  DetailViewController *destination = segue.destinationViewController;
  [destination setSite: cell.site];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchString];
 _searchHits = [[GombotDB getSites] filteredArrayUsingPredicate:match];

  return YES;
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
  [board setString:selectedCell.site.pass];

  AppDelegate* myApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  [myApp setLastCopyValue:selectedCell.site.pass];

  //launch to the site
  NSURL *url = [NSURL URLWithString:selectedCell.site.url];
  NSLog(@"%@", url);
  BOOL result = [[UIApplication sharedApplication] openURL:url];
  if (!result) NSLog(@": url launch failed: %@", url);

}

@end
