//
//  ViewController.m
//  PhotoRateDemo
//
//  Created by leslie on 15/4/21.
//  Copyright (c) 2015年 leslie. All rights reserved.
//

#import "ViewController.h"

#import "UIView+Addition.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    PhotoRateListView *photoRateListView;
    UIView * headerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    _tableView.tableHeaderView = headerView;

    photoRateListView = [[PhotoRateListView alloc] init];

    
    photoRateListView.size = CGSizeMake(300, 500);
    photoRateListView.center = self.view.center;
    [photoRateListView setUpContentView:nil];
    
    
    
    
    
    [self.view addSubview:photoRateListView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"celldemo";
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
