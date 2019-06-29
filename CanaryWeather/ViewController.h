//
//  ViewController.h
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/26/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "ForecastDataSource.h"

@class DataController;

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSFetchedResultsControllerDelegate,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ForecastDataSourceDelegate>

@property (nonatomic, strong) DataController *dataController;

@end

