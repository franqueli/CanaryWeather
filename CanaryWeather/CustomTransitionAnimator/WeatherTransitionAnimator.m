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
    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey: UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];

    CGRect fromStartFrame = [transitionContext initialFrameForViewController: fromViewController];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController: toViewController];

    containerView.backgroundColor = [UIColor lightGrayColor];
    [containerView insertSubview: toView belowSubview: fromView];
    toView.frame = toFinalFrame;

    UIViewPropertyAnimator *animator1 = [[UIViewPropertyAnimator alloc] initWithDuration: _duration / 3.0 curve: UIViewAnimationCurveEaseIn
            animations: ^{
                // move from diagonally
                fromView.frame = CGRectOffset(fromView.frame, -100.0, 200.0);
     }];

    UIViewPropertyAnimator *animator2 = [[UIViewPropertyAnimator alloc] initWithDuration: _duration / 3.0 curve: UIViewAnimationCurveEaseIn animations: ^{
        CGFloat width = containerView.frame.size.width;
        CGFloat height = containerView.frame.size.height;
        toView.frame = CGRectOffset(toView.frame, width - 100.0, -height + 200.0);
    }];

    UIViewPropertyAnimator *animator3 = [[UIViewPropertyAnimator alloc] initWithDuration: _duration / 3.0 curve: UIViewAnimationCurveEaseIn animations: ^{
        [containerView bringSubviewToFront: toView];
        toView.frame = toFinalFrame;

    }];

    [animator1 addCompletion: ^(UIViewAnimatingPosition finalPosition) {
        [animator2 startAnimation];
    }];

    [animator2 addCompletion: ^(UIViewAnimatingPosition finalPosition) {
        [animator3 startAnimation];
    }];

    [animator3 addCompletion: ^(UIViewAnimatingPosition finalPosition) {
        BOOL success = ![transitionContext transitionWasCancelled];

        fromView.frame = fromStartFrame;
        [transitionContext completeTransition: success];
    }];

    [animator1 startAnimation];
}


@end
