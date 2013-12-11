//
//  CustomOperation.m
//  OperationDemo
//
//  Created by ZhangMeng on 13-12-11.
//  Copyright (c) 2013年 zhangM. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

- (BOOL) isConcurrent{

    return  YES;
}

- (void) start{

    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];


}


- (void) main{

    @try {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        finished = NO;
        
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }
    @catch (NSException *exception) {
        NSLog(@"exception   is %@",exception.name);
    }
    @finally {
        
    }


}
@end
