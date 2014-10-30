//
//  TestObj.h
//  VinTest
//
//  Created by kingpoint on 14-7-22.
//  Copyright (c) 2014年 kingpoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObj : NSObject

+ (void)logToLimit:(int)limit WithBlock:(int (^) (int, int))block;

+ (void)logAsyncWithBloc:(void (^) (BOOL))result;

@end
