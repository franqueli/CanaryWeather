//
//  WeatherTransitionAnimator.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 7/2/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "WeatherTransitionAnimator.h"

@interface WeatherTransitionAnimator() {
    NSTimeInterval _duration;
}

@end

@implementation WeatherTransitionAnimator

- (instancetype) init {
    self = [super init];
    if (self) {
        _duration = 1.0;
    }

    return self;
}


- (NSTimeInterval) transitionDuration: (nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>)transitionContext {
//  Three steps to an animator
//    Getting the animation parameters.
//
//    Creating the animations using Core Animation or UIView animation methods.
//
//    Cleaning up and completing the transition.
//

    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey: UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];

    CGRect fromStartFrame = [transitionContext initialFrameForViewController: fromViewController];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController: toViewController];

// This should be reversed on dismiss
    // Card switch transition animation
    // Stack from on top of to view controllers
    // Animate from diagonally so back peeks out
    // Animate toVC so it clears the top right corner
    // Animate toVC so it ends up filling the screen
    // From view controller starts normally then
//    BOOL presenting = YES;
//    if (presenting) {
//
//    }
    // Presenting transition

    [containerView addSubview: toView];
    toView.frame = toFinalFrame;
    toView.alpha = 0;
//    [containerView insertSubview: toView belowSubview: fromView];
//    toView.frame = fromStartFrame;


    UIViewPropertyAnimator *viewPropertyAnimator = [[UIViewPropertyAnimator alloc] initWithDuration: _duration curve: UIViewAnimationCurveEaseIn
            animations: ^{
                // move from diagonally
//                fromView.frame = CGRectMake(fromStartFrame.origin.x - 100.0, fromStartFrame.origin.y + 100.0, fromStartFrame.size.width, fromStartFrame.size.height);
                fromView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                toView.alpha = 1.0;
            }];

    //    [viewPropertyAnimator addAnimations: ^{
//
//    }];

    [viewPropertyAnimator addCompletion: ^(UIViewAnimatingPosition finalPosition) {
        BOOL success = ![transitionContext transitionWasCancelled];

//        if (finalPosition == UIViewAnimatingPositionEnd && !success) {
////            [toView removeFromSuperview];
//        }
        fromView.transform = CGAffineTransformIdentity;

        [transitionContext completeTransition: success];
    }];

    [viewPropertyAnimator startAnimation];
}


@end
