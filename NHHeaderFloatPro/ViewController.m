//
//  ViewController.m
//  NHHeaderFloatPro
//
//  Created by hu jiaju on 15-10-18.
//  Copyright (c) 2015年 Nanhu. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+HeaderFloating.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerFlag;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel* header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 30)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    header.text = [NSString stringWithFormat:@"section:%zd",section+1];
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *title = [NSNumber numberWithInteger:indexPath.row+1].stringValue;
    [cell.textLabel setText:title];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"专题";
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    CGRect bounds = self.view.bounds;
    bounds.origin = CGPointMake(0, 64);
    _tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    CGFloat headHeight = 200;
    CGFloat flagHeight = 40;
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, headHeight)];
    [header setBackgroundColor:[UIColor blueColor]];
    [self.tableView setTableHeaderView:header];
    
    CGPoint offfset = self.tableView.contentOffset;
    offfset.y -= headHeight;
    [self.tableView setContentOffset:offfset];
    
    CGRect infoRect = CGRectMake(0, -flagHeight, mainSize.width, 120);
    UIImageView *img = [[UIImageView alloc] initWithFrame:infoRect];
    img.image = [UIImage imageNamed:@"header.jpg"];
    [self.tableView addSubview:img];
    
    UIView *flag = [[UIView alloc]initWithFrame:CGRectMake(0, headHeight-flagHeight, [[UIScreen mainScreen]bounds].size.width, flagHeight)];
    [flag setBackgroundColor:[UIColor redColor]];
    [self.tableView addSubview:flag];
    
    
    UIEdgeInsets contentInset = [self.tableView contentInset];
//    UIEdgeInsets scrollInset = [self.tableView scrollIndicatorInsets];
    contentInset.top += flagHeight;
//    scrollInset.top+=headHeight;
    [self.tableView setContentInset:contentInset];
    
    _headerFlag = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, flagHeight)];
    _headerFlag.backgroundColor = [UIColor redColor];
    [self.view addSubview:_headerFlag];
    _headerFlag.hidden = true;

}

#pragma mark -- UIScrollView --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    NSLog(@"offset y:%f",offset.y);
    
    BOOL shouldShow = offset.y>(200-40);
    self.headerFlag.hidden = !shouldShow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
