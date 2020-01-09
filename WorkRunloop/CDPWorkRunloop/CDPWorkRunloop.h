//
//  CDPWorkRunloop.h
//
//  Created by CDP on 2020/1/9.
//  Copyright © 2020 CDP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  任务进行block
 *  (BOOL返回值确定此次任务是否完成,返回NO则自动进行下一个任务直到返回YES或无任务可进行)
 */
typedef void(^CDPRunloopBlock)(void);






@interface CDPWorkRunloop : NSObject
//CDPWorkRunloop将一些在主线程里面执行的操作添加到任务里，提高流畅性
//demo只写了个tableView的样例，其他的可以在collectionView用或者其他方面

/**
 *  最大任务数(默认30)
 */
@property (nonatomic,assign) NSInteger maxCount;

/**
 *  单例
 */
+(instancetype)sharedWork;

/**
 *  添加任务
 */
-(void)addTask:(CDPRunloopBlock)task;

/**
 *  移除所有任务
 */
-(void)removeAllTask;








@end



