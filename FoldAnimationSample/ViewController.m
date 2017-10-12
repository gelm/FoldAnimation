//
//  ViewController.m
//  FoldAnimationSample
//
//  Created by 各连明 on 2017/10/12.
//  Copyright © 2017年 ming. All rights reserved.
//

#import "ViewController.h"
#import "JHYearListView.h"

@interface ViewController ()<JHYearListViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JHYearListView *yearListView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate new]];
    self.yearListView.defaultIndex = [self.yearListView indexWithYear:[year integerValue]];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.yearListView showAnimationInView:self.view];
}

- (void)yearListView:(JHYearListView *)yearListView didSelected:(NSString *)year {
    NSLog(@">>> %@",year);
}

- (JHYearListView *)yearListView {
    if(!_yearListView){
        _yearListView = [[JHYearListView alloc]initWithFrame:self.view.bounds];
        _yearListView.delegate = self;
    }
    return _yearListView;
}

@end
