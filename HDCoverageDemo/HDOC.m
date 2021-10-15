//
//  HDOC.m
//  HDCoverageDemo
//
//  Created by denglibing on 2021/10/15.
//

#import "HDOC.h"

@implementation HDOC

+ (void)changeViewColor:(UIView *)view {
    NSInteger random = arc4random();
    if (random % 3 == 0) {
        NSLog(@"random:%d", 0);
        view.backgroundColor = [UIColor orangeColor];
    }
    else if (random % 3 == 1) {
        NSLog(@"random:%d", 1);
        view.backgroundColor = [UIColor redColor];
    }
    else if (random % 3 == 2) {
        NSLog(@"random:%d", 2);
        view.backgroundColor = [UIColor systemGray5Color];
    }
}

@end
