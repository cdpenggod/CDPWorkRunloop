//
//  CDPWorkRunloop.m
//
//  Created by CDP on 2020/1/9.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "CDPWorkRunloop.h"

#import <QuartzCore/QuartzCore.h>

@interface CDPWorkRunloop ()


@property (nonatomic,strong) NSMutableArray *taskArr;//任务数组



@end

@implementation CDPWorkRunloop

#pragma mark - 添加删除任务
//添加任务
-(void)addTask:(CDPRunloopBlock)task{
    [self.taskArr addObject:task];
    
    if (self.taskArr.count>self.maxCount) {
        [self.taskArr removeObjectAtIndex:0];
    }
}
//移除所有任务
-(void)removeAllTask{
    [self.taskArr removeAllObjects];
}
#pragma mark - 内部逻辑实现
//单例化
+(instancetype)sharedWork{
    static CDPWorkRunloop *work;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        work=[[CDPWorkRunloop alloc] init];
        work.maxCount=30;
        
        //设置个计时器防止runloop休眠，无法响应任务
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:work
                                                                 selector:@selector(doNothing)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        [work registerObserver];
    });
    return work;
}
//注册observer
-(void)registerObserver{
    //上下文
    CFRunLoopObserverContext context={
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    //创建runloop休眠前observer
    static CFRunLoopObserverRef observer;
    observer=CFRunLoopObserverCreate(kCFAllocatorDefault,
                                     kCFRunLoopBeforeWaiting,
                                     YES,
                                     0,
                                     &callBack,
                                     &context);
    //给主线程runloop添加观察者
    CFRunLoopAddObserver(CFRunLoopGetMain(),observer,kCFRunLoopCommonModes);

    CFRelease(observer);
}
//observer回调
static void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    CDPWorkRunloop *work=(__bridge CDPWorkRunloop *)info;
    
    //无任务
    if (work.taskArr.count==0){
        return;
    }
    
    BOOL isSuccess=NO;
    while (isSuccess==NO&&work.taskArr>0) {
        //从数组中取出任务
        CDPRunloopBlock block=[work.taskArr firstObject];
        
        //完成任务
        if (block) {
            isSuccess=block();
        }
        
        //移除刚完成的任务
        [work.taskArr removeObjectAtIndex:0];
    }
}
#pragma mark - 其他方法
-(NSMutableArray *)taskArr{
    if (_taskArr==nil) {
        _taskArr = [NSMutableArray new];
    }
    return _taskArr;
}
//定时器方法(防止runloop休眠)
-(void)doNothing{
}






@end
