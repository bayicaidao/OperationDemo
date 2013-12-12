//
//  ViewController.m
//  OperationDemo
//
//  Created by ZhangMeng on 13-12-11.
//  Copyright (c) 2013年 zhangM. All rights reserved.
//

#import "ViewController.h"


#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//if (IOS7_OR_LATER)
//{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
//    [self prefersStatusBarHidden];
//    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    [self.view setFrame:CGRectMake(MinX(self.view), MinY(self.view), WIDTH(self.view), HEIGHT(self.view)-kStatusBarHeight)];
//}

#endif	  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000



@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInvocationOperation *invacationOperation = [[NSInvocationOperation alloc ] initWithTarget:self selector:@selector(doSomething) object:nil];
    invacationOperation.threadPriority = 0.5; // 设置线程优先级
    /*
     Operation状态变化
     我们可以通过KVO机制来监听Operation的一下状态改变，比如一个Operation的执行状态或完成状态。这些状态的keypath包括以下几个：
     isCancelled
     isConcurrent
     isExecuting
     isFinished
     isReady
     dependencies
     queuePriority
     completionBlock
     */
    [invacationOperation start];
    
    
    
    //  NSOperationQueue
    /*
     1. Operation 的依赖关系（Dependency）      有时候我们对任务的执行顺序有要求，一个任务必须在另一个任务执行之前完成，这就需要用到Operation的依赖（Dependency）属性
     
     2.Operation在队列中执行的优先级     默认为FIFO（First In First Out）
     3.最大并发Operation数目 maxConcurrentOperationCount          在一个Operation Queue中是可以同时执行多个Operation的，Operation Queue会动态的创建多个线程来完成相应Operation。具体的线程数是由Operation Queue来优化配置的，这一般取决与系统CPU的性能，比如CPU的核心数，和CPU的负载。但我们还是可以设置一个最大并发数的，那么Operation Queue就不会创建超过最大并发数量的线程。
     
     */
    NSBlockOperation *operation5s = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation5s begin");
        sleep(5);
        NSLog(@"operation5s end");
    }];
    
    operation5s.queuePriority = NSOperationQueuePriorityHigh;
    
    NSBlockOperation *operation1s = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation1s begin");
        sleep(1);
        NSLog(@"operation1s end");
    }];
    
    NSBlockOperation *operation2s = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation2s begin");
        sleep(2);
        NSLog(@"operation2s end");
    }];
    
    operation1s.completionBlock = ^{
        NSLog(@"operation1s finished in completionBlock");
    };
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [queue addOperation:operation1s];
    [queue addOperation:operation2s];
    [queue addOperation:operation5s];
    [queue waitUntilAllOperationsAreFinished];
    
    /*  注意事项
     
     当一个Operation被加入Queue中后，请不要对这个Operation再进行任何修改。因为一旦加入Queue，它随时就有可能会被执行，对它的任何修改都有可能导致它的运行状态不可控制。
     
     threadPriority仅仅影响了main执行时的线程优先级，其他的方法包括completionBlock都是以默认的优先级来执行的。如果自定义的话，也要注意在main执行前设置好threadPriority，执行完毕后要还原默认线程优先级。
     
     经测试，Operation的threadPriority字段只有在Operation单独执行时有效，在Operation Queue中是无效的。
     
     第一个加入到Operation Queue中的Operation，无论它的优先级有多么低，总是会第一个执行。
     
     */
    
    

}

//  汉子转拼音
- (NSString *)getPinYinFrom:(NSString *)chinese
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (CFMutableStringRef)[NSMutableString stringWithString:chinese]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    return (NSString *)string;
}


- (void) doSomething{

    NSLog(@"invacationOperation do something");

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
