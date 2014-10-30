//
//  TestObj.m
//  VinTest
//
//  Created by kingpoint on 14-7-22.
//  Copyright (c) 2014年 kingpoint. All rights reserved.
//

#import "TestObj.h"

@implementation TestObj

+ (void)logToLimit:(int)limit WithBlock:(int (^) (int, int))block {
    for (int i = 0; i < limit; i ++) {
        sleep(2);
        int result = block(i, 2);
        NSLog(@"====== %d ========", result);
    }
}

+ (void)logAsyncWithBloc:(void (^) (BOOL))result {
    NSLog(@"do async");
    result(YES);
}

@end
