//
//  CDPWorkRunloop.h
//
//  Created by CDP on 2020/1/9.
//  Copyright © 2020 CDP. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 任务进行block
/// BOOL 返回值, 用来确定此次任务是否完成, 返回 NO 则自动进行下一个任务直到返回 YES 或 无任务可进行
/// 可防止浪费时间去执行已经没必要执行的任务
typedef BOOL(^CDPRunloopBlock)(void);


@interface CDPWorkRunloop : NSObject
/// CDPWorkRunloop将一些在主线程里面执行的操作添加到任务里，提高流畅性
/// demo只写了个tableView的样例，其他的可以在collectionView用或者其他方面

/// 是否开启最大任务数限制 (默认 NO)
/// 开启后，可以防止当前任务数过多，控制数量，但是如果 超出最大数量限制，那么老任务可能 未执行就被移除 了
@property (nonatomic, assign) BOOL openMaxLimit;

/// 同一时间待执行最大任务数 (默认 30)
/// 当添加任务时，如果 已有任务数量大于最大数量，会 按顺序把任务池里面 最久的老任务移除，达到 控制任务数量目的
@property (nonatomic, assign) NSInteger maxCount;

/// 单例
+ (instancetype)sharedWork;

/// 添加任务
/// @param task 要添加的任务
- (void)addTask:(CDPRunloopBlock)task;

/// 移除当前所有任务
- (void)removeAllTask;





@end



