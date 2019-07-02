//
//  AppDelegate.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/26/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "AppDelegate.h"
#import "ForecastDataSource.h"
#import "DataController.h"
#import "ForecastListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL) application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.dataController = [[DataController alloc] initWithModelName: @"CanaryWeather"];
    [_dataController load: nil];

    UINavigationController *navigationController = (UINavigationController *)_window.rootViewController;
    ForecastListViewController *vc = (ForecastListViewController *)navigationController.topViewController;
    vc.dataController = _dataController;

    return YES;
}


- (void) applicationWillResignActive: (UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void) applicationDidEnterBackground: (UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void) applicationWillEnterForeground: (UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void) applicationDidBecomeActive: (UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void) applicationWillTerminate: (UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (DataController *) dataController {
    @synchronized (self) {
        if (_dataController == nil) {
            _dataController = [[DataController alloc] initWithModelName: @"CanaryWeather"];
        }
    }

    return _dataController;
}


#pragma mark - Core Data Saving support

- (void) saveContext {
    NSManagedObjectContext *context = self.dataController.viewContext;

    NSError *error = nil;
    if ([context hasChanges] && ![context save: &error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
