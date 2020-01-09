//
//  UITableViewCell+CDPRunloopCell.m
//  WorkRunloop
//
//  Created by CDP on 2020/1/9.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "UITableViewCell+CDPRunloopCell.h"
#import <objc/runtime.h>

@implementation UITableViewCell (CDPRunloopCell)



- (NSIndexPath *)currentIndexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, @selector(currentIndexPath));
    return indexPath;
}
- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    objc_setAssociatedObject(self, @selector(currentIndexPath),currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
