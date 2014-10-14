//
//  BUItemListViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <BrainduDataModel/BrainduDataModel.h>
#import "BUItemListViewController.h"
#import "CoreDataStack.h"

#import "BUItemViewController.h"
#import "ItemReadViewController.h"
#import "BUItemCell.h"

@interface BUItemListViewController ()

// @property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BUItemListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
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

    self.tableView.separatorColor = [UIColor clearColor];

    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chartListBg.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = NO;

//    [self.chart ensureItems:^(NSMutableArray *items) {
//        [self.tableView reloadData];
//    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.chart ensureItems:^(NSMutableArray *items) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add"]) {
        BUItemViewController *itemView = segue.destinationViewController;
        itemView.chart = self.chart;
    } else if ([segue.identifier isEqualToString:@"edit"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        BUItemViewController *itemViewController = (BUItemViewController *)segue.destinationViewController;
        itemViewController.item = self.chart.items[indexPath.row];
    } else if ([segue.identifier isEqualToString:@"read"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ItemReadViewController *itemReadViewController = (ItemReadViewController *)segue.destinationViewController;
        itemReadViewController.item = self.chart.items[indexPath.row];
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chart.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    self.tableView.opaque = NO;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unselectedCell.png"]];

    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:.25f];

    cell.selectedBackgroundView = view;

    BUPItem *item = self.chart.items[indexPath.row];
    [cell configureCellForItem:item];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        BUPItem *item = self.chart.items[indexPath.row];
        [item deleteInBackground];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
