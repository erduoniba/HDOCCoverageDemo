//
//  HDOCFramework.m
//  HDCoverFramework
//
//  Created by denglibing on 2021/10/15.
//

#import "HDOCFramework.h"

@implementation HDOCFramework

+ (void)changeViewColor:(UIView *)view {
    NSInteger random = arc4random() % 3;
    if (random == 0) {
        NSLog(@"HDOCFramework random:%d", 0);
        view.backgroundColor = [UIColor orangeColor];
    }
    else if (random == 1) {
        NSLog(@"HDOCFramework random:%d", 1);
        view.backgroundColor = [UIColor redColor];
    }
    else if (random == 2) {
        NSLog(@"HDOCFramework random:%d", 2);
        view.backgroundColor = [UIColor systemGray5Color];
    }
}

@end
