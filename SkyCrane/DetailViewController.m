//
//  DetailViewController.m
//  SkyCrane
//
//  Created by Dan Walkowski on 11/12/12.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    sortedKeys = [[_site.record allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
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
  return [sortedKeys count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [sortedKeys objectAtIndex:section];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  id chunk = [_site.record objectForKey:[sortedKeys objectAtIndex: section]];
  
  if ([chunk isKindOfClass:[NSDictionary class]])
  {
    return [[chunk allKeys] count];
  }
  else if ([chunk isKindOfClass:[NSArray class]])
  {
    return [chunk count];
  }
  else
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

  id chunk = [_site.record objectForKey:[sortedKeys objectAtIndex: [indexPath section]]];
  id rowValue;
  
  if ([chunk isKindOfClass:[NSDictionary class]])
  {
    id key = [[chunk allKeys] objectAtIndex:[indexPath row]];
    rowValue = [NSString stringWithFormat:@"%@ : %@", key, [chunk objectForKey:key]];
  }
  else if ([chunk isKindOfClass:[NSArray class]])
  {
    rowValue = [chunk objectAtIndex:[indexPath row]];
  }
  else
    rowValue = chunk;

  
  cell.textLabel.text = [rowValue description];

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Cell Menus
-(void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender
{
  UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (cell.detailTextLabel.text && ![cell.detailTextLabel.text isEqual:@""])
  {
    [gpBoard setString:cell.detailTextLabel.text];
	}
  else
  {
    [gpBoard setString:cell.textLabel.text];
	}
}

-(BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender
{
  if (action == @selector(copy:))
    return YES;
  else return [super canPerformAction:action withSender:sender];
}

-(BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return YES;
}
@end
