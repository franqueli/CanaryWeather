//
// Created by Franqueli Mendez on 2019-06-27.
// Copyright (c) 2019 Franqueli Mendez. All rights reserved.
//

#import "DataController.h"

@interface DataController()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;

@end

@implementation DataController {

}

- (instancetype) initWithModelName:(NSString *) modelName {
    self = [super init];
    if (self) {
        self.persistentContainer = [[NSPersistentContainer alloc] initWithName: modelName];
    }

    return self;
}

- (NSManagedObjectContext *) viewContext {
    return _persistentContainer.viewContext;
}

- (void) configureContexts {
    self.backgroundContext = [_persistentContainer newBackgroundContext];

    NSManagedObjectContext *viewContext = _persistentContainer.viewContext;
    viewContext.automaticallyMergesChangesFromParent = true;
    _backgroundContext.automaticallyMergesChangesFromParent = true;

    _backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrumpMergePolicy;
    viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrumpMergePolicy;
}


- (void) load: (void (^)(void))completion {
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
            */
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }

        [self configureContexts];
    }];

    if (completion) {
        completion();
    }
}

- (void) autoSaveViewContext {
    [self autoSaveViewContextWithInterval: 30];
}

- (void) autoSaveViewContextWithInterval:(NSTimeInterval)interval {
    NSLog(@"**** AutoSaving ****");
    if (interval < 3) {
        interval = 3;   // Make sure we have a minimum autosave of 3 secs
    }

    NSManagedObjectContext *viewContext = [self viewContext];
    NSError *error;
    if ([viewContext hasChanges] && [viewContext save: &error]) {
        if (error) {
            NSLog(@"*** Error saving view context: %@ %@", error, error.userInfo);
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self autoSaveViewContextWithInterval: interval];
    });


}




@end