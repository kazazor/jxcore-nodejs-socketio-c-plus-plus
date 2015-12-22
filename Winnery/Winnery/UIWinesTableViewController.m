//
//  UIWinesTableViewController.m
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import "UIWinesTableViewController.h"

@interface UIWinesTableViewController ()

@property (nonatomic, strong) NSMutableArray *winesArray;

- (void)getAllWines;
- (void)addWine;
- (void)addWineWithSocetIO;
- (void)scrollToBottom;
- (void)showErrorAlert:(NSString *)message;

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
    
    [self getAllWines];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllWines
{
    [[[LogicManager sharedInstance] winesLogic] getAllWines:^(NSArray *winesArray) {
        self.winesArray = [NSMutableArray arrayWithArray:winesArray];
        [self.tableView reloadData];
    }
                                                    failure:^(NSError *error) {
                                                        [self showErrorAlert:error.description];
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
                                                    [self showErrorAlert:error.description];
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
                                                          [self showErrorAlert:error.description];
                                                      }];
}

- (void)scrollToBottom
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1)
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}

- (void)showErrorAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [alertController dismissViewControllerAnimated:YES
                                                                                              completion:^{ }];
                                                      }]];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{ }];
}

- (void)showMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [alertController dismissViewControllerAnimated:YES
                                                                                              completion:^{ }];
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
                                                           [self showErrorAlert:error.description];
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
                                                               [self showMessage:message];
                                                           }
                                                           failure:^(NSError *error) {
                                                               [self showErrorAlert:error.description];
                                                           }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
