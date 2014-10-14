//
//  BUChartListTableViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <BrainduDataModel/BrainduDataModel.h>
#import "BUChartListTableViewController.h"
#import "CoreDataStack.h"
#import "BUChartViewController.h"
#import "BUChartCell.h"
#import "BUItemListViewController.h"

@interface BUChartListTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UIView *emptyListView;

@end

@implementation BUChartListTableViewController

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

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *emptyListView = [[UIView alloc] init];
    emptyListView.backgroundColor = [UIColor whiteColor];

    [[BUPUser currentUser] ensureCharts:^(NSMutableArray *charts) {
        if (charts.count == 0) {
            [window addSubview:emptyListView];
        }

        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        BUChartViewController *chartViewController = (BUChartViewController *)segue.destinationViewController;
        chartViewController.chart = [BUPUser currentUser].charts[indexPath.row];
    } else if ([segue.identifier isEqualToString:@"items"]) {
        UIButton *button = sender;
        CGPoint tableViewPoint = [self.tableView convertPoint:button.center fromView:button.superview];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tableViewPoint];
        BUItemListViewController *itemListViewController = (BUItemListViewController *)segue.destinationViewController;
        itemListViewController.chart = [BUPUser currentUser].charts[indexPath.row];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BUPUser currentUser].charts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Configure the cell...

    BUPChart *chart = [BUPUser currentUser].charts[indexPath.row];
    [cell configureCellForChart:chart];

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
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        BUPChart *chart = [BUPUser currentUser].charts[indexPath.row];
        [chart deleteInBackground];
        [[BUPUser currentUser].charts removeObject:chart];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


@end
