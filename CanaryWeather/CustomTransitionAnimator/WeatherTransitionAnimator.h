//
//  WeatherTransitionAnimator.h
//  CanaryWeather
//
//  Created by Franqueli Mendez on 7/2/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;

@end

NS_ASSUME_NONNULL_END
