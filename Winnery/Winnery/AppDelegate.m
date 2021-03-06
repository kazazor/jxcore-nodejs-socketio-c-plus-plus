//
//  AppDelegate.m
//  Winnery
//
//  Created by Nilit Rokah on 11/29/15.
//  Copyright © 2015 Action-Item. All rights reserved.
//

#import "AppDelegate.h"

#import "JXcore.h"
#import "AFNetworkReachabilityManager.h"
#import "UIWinesTableViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIWinesTableViewController *winesTableViewController;

/**
 * Starts the JXCore Engine and starts the ios node js server.
 */
- (void)startJXCore;

/**
 * Creates a UIAlertController and shows the given message.
 *
 * @param message   The message to show in the alert.
 */
- (void)showMessage:(NSString *)message;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self startJXCore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    self.winesTableViewController = [[UIWinesTableViewController alloc] initWithNibName:@"UIWinesTableViewController"
                                                                                 bundle:[NSBundle mainBundle]];
    
    [[LogicManager sharedInstance] setValue:@"http://localhost:3000" forKey:@"baseURLString"];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.winesTableViewController];
    [self.window makeKeyAndVisible];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Methods

- (void)startJXCore
{
    // Makes JXcore instance running under it's own thread
    [JXcore useSubThreading];
    
    // Start engine (main file will be JS/main.js. This is the initializer file)
    [JXcore startEngine:@"JS/main"];
    
    // Listen to Errors on the JS land
    [JXcore addNativeBlock:^(NSArray *params, NSString *callbackId) {
        NSString *errorMessage = (NSString*)[params objectAtIndex:0];
        NSString *errorStack = (NSString*)[params objectAtIndex:1];
        
        NSLog(@"Error!: %@\nStack:%@\n", errorMessage, errorStack);
    } withName:@"OnError"];
    
    // Start the application
    NSArray *params = [NSArray arrayWithObjects:@"server.js", nil];
    [JXcore callEventCallback:@"StartApplication" withParams:params];
}

- (void)showMessage:(NSString *)message
{
    [self.winesTableViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }]];
    
    [self.winesTableViewController presentViewController:alertController
                                                 animated:YES
                                               completion:^{
    }];
}

- (void)networkingReachabilityChanged:(NSNotification *)note
{
    AFNetworkReachabilityStatus status = [[note.userInfo valueForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    NSString *message;
    if (status == AFNetworkReachabilityStatusNotReachable)
    {
        message = [NSString stringWithFormat:@"Network unreachable\nOffline Mode"];
        [[LogicManager sharedInstance] setValue:@"http://localhost:2000" forKey:@"baseURLString"];
    }
    else
    {
        message = @"Network is back";
        [[LogicManager sharedInstance] setValue:@"http://localhost:3000" forKey:@"baseURLString"];
    }
    [self showMessage:message];
}

@end
