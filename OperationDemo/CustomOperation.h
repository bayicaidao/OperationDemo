//
//  CustomOperation.h
//  OperationDemo
//
//  Created by ZhangMeng on 13-12-11.
//  Copyright (c) 2013年 zhangM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomOperation : NSInvocationOperation
{
    BOOL   executing;
    BOOL   finished;
 
}
@end
