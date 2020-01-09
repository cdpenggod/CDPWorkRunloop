//
//  ViewController.m
//  WorkRunloop
//
//  Created by CDP on 2020/1/9.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "ViewController.h"

#import "CDPWorkRunloop.h"//引入头文件

#import "UITableViewCell+CDPRunloopCell.h"//非必须，仅为demo演示用，也可用collectionViewCell实现

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //CDPWorkRunloop将一些在主线程里面执行的操作添加到任务里，提高流畅性
    //demo只写了个tableView的样例，其他的可以在collectionView用或者其他方面
    
    //创建tableView
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
}
#pragma mark - tableViewDelegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 200;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"CDPCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled=NO;
        
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
    }
    //记录indexPath，等会执行任务时可进行判断
    cell.currentIndexPath=indexPath;
    
    //将cell的渲染等操作添加进入任务里
    [[CDPWorkRunloop sharedWork] addTask:^{
        
        //判断是否匹配，不匹配就没必要进行渲染等操作了（非必须，如果不是很复杂的操作，其实不判断，也无所谓）
        if ([cell.currentIndexPath isEqual:indexPath]) {
            cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        }
    }];
    
    return cell;
}


@end
