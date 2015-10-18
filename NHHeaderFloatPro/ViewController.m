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
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *sectionYs;

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

    _sectionYs = [NSMutableArray array];
    NSInteger counts = [self.tableView numberOfSections];
    for (int i = 0; i < counts; i++) {
        CGRect bounds = [self.tableView rectForHeaderInSection:i];
        NSNumber *tmpy = [NSNumber numberWithFloat:bounds.origin.y];
        [_sectionYs addObject:tmpy];
    }
    
}

#pragma mark -- UIScrollView --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
//    NSLog(@"offset y:%f",offset.y);
    
    BOOL shouldShow = offset.y>(200-40);
    self.headerFlag.hidden = !shouldShow;
    
    __block NSUInteger dstIndex;
    if (_sectionYs) {
        [_sectionYs enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"%@****%zd",obj,idx);
            if ( obj.floatValue > offset.y + 40) {
                dstIndex = idx;
                *stop = true;
            }
        }];
    }
//    NSLog(@"tmp:%zd---cur:%zd",dstIndex,_currentIndex);
    if (_currentIndex != dstIndex) {
        _currentIndex = dstIndex;
        _headerFlag.backgroundColor = [self randomColor];
    }
    
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
