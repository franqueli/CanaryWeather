//
// Created by Franqueli Mendez on 2019-06-27.
// Copyright (c) 2019 Franqueli Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataController : NSObject

- (instancetype) initWithModelName:(NSString *) modelName;

- (void) load: (void(^)(void))completion;
- (NSManagedObjectContext *)viewContext;

@property (nonatomic, readonly) NSManagedObjectContext *backgroundContext;




@end