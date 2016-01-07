//
//  UIWinesTableViewController.m
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 Action-Item. All rights reserved.
//

#import "UIWinesTableViewController.h"

@interface UIWinesTableViewController ()

@property (nonatomic, strong) NSMutableArray *winesArray;

/**
 * Calls WinesLogic getAllWines to get all items.
 * On success, will reload the table with the data.
 * On failure, will call clearDataAndShowServerError.
 */
- (void)getAllWines;

/**
 * Calls WinesLogic addWine to add the object.
 * On success, will reload the table with the new object.
 * On failure, will call clearDataAndShowServerError.
 */
- (void)addWine;

/**
 * Calls WinesLogic socketAddWine to add the object.
 * On success, will reload the table with the new object.
 * On failure, will call clearDataAndShowServerError.
 */
- (void)addWineWithSocetIO;

/** 
 * Removes all items in winesArray, reloads the table, and calls showMessage with the error.
 *
 * @param error     The server error to show.
 */
- (void)clearDataAndShowServerError:(NSError *)error;

/**
 * Scrolls the table to the last item.
 */
- (void)scrollToBottom;

/**
 * Creates a UIAlertController and shows the message with title given.
 *
 * @param message   The message to show in the alert.
 * @param title     The title for the alert.
 */
- (void)showMessage:(NSString *)message withTitle:(NSString *)title;

@end

@implementation UIWinesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(getAllWines)];
    
    UIBarButtonItem *newWineBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(addWine)];
    UIBarButtonItem *newWineWithSocetIOBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"NewWIO" style:UIBarButtonItemStylePlain target:self action:@selector(addWineWithSocetIO)];
    self.navigationItem.leftBarButtonItems = @[newWineBarButtonItem, newWineWithSocetIOBarButtonItem];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UIWinesTableViewCell"];
    
    [[LogicManager sharedInstance] addObserver:self
                                    forKeyPath:@"baseURLString"
                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"baseURLString"]) {
        NSLog(@"change: %@", change);
        [self getAllWines];
    }
}

#pragma - Private Methods

- (void)getAllWines
{
    [[[LogicManager sharedInstance] winesLogic] getAllWines:^(NSArray *winesArray) {
        self.winesArray = [NSMutableArray arrayWithArray:winesArray];
        [self.tableView reloadData];
    }
                                                    failure:^(NSError *error) {
                                                        [self clearDataAndShowServerError:error];
                                                    }];
}

- (void)addWine
{
    Wine *newWine = [[Wine alloc] init];
    newWine.name = @"Test";
    
    [[[LogicManager sharedInstance] winesLogic] addWine:newWine
                                                success:^{
                                                    [self.winesArray addObject:newWine];
                                                    [self.tableView reloadData];
                                                    [self scrollToBottom];
                                                }
                                                failure:^(NSError *error) {
                                                    [self clearDataAndShowServerError:error];
                                                }];
}

- (void)addWineWithSocetIO
{
    Wine *newWine = [[Wine alloc] init];
    newWine.name = @"Test Socet IO";
    
    [[[LogicManager sharedInstance] winesLogic] socketAddWine:newWine
                                                      success:^{
                                                          [self.winesArray addObject:newWine];
                                                          [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                                                                           withObject:nil
                                                                                        waitUntilDone:YES];
                                                          [self scrollToBottom];
                                                      }
                                                      failure:^(NSError *error) {
                                                          [self clearDataAndShowServerError:error];
                                                      }];
}

- (void)clearDataAndShowServerError:(NSError *)error
{
    [self.winesArray removeAllObjects];
    [self.tableView reloadData];
    [self showMessage:error.description withTitle:@"Error"];
}

- (void)scrollToBottom
{
    if ([self.tableView numberOfRowsInSection:0] > 1)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1)
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

- (void)showMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }]];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{ }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.winesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIWinesTableViewCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UIWinesTableViewCell"];
    }
    
    cell.textLabel.text = ((Wine *)[_winesArray objectAtIndex:indexPath.row]).name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;//YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Wine *wineToDelete = [_winesArray objectAtIndex:indexPath.row];
        [[[LogicManager sharedInstance] winesLogic] deleteWine:wineToDelete
                                                       success:^{ }
                                                       failure:^(NSError *error) {
                                                           [self showMessage:error.description withTitle:@"Error"];
                                                           [self.winesArray insertObject:wineToDelete atIndex:indexPath.row];
                                                           [self.tableView reloadData];
                                                       }];
        [self.winesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[LogicManager sharedInstance] winesLogic] socketWineSelected:[_winesArray objectAtIndex:indexPath.row]
                                                           success:^(NSString *message) {
                                                               [self showMessage:message withTitle:@""];
                                                           }
                                                           failure:^(NSError *error) {
                                                               [self showMessage:error.description withTitle:@"Error"];
                                                           }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
