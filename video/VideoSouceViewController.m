//
//  VideoSouceViewController.m
//  video
//
//  Created by 李李贤军 on 15/7/26.
//  Copyright (c) 2015年 TH. All rights reserved.
//
#import "VideoSouceViewController.h"
#import "ViewPlayViewController.h"
#import "LoginAndRegister.h"
@interface VideoSouceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation VideoSouceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    [LoginAndRegisterRequest registerWithSucc:^(NSDictionary *DataDic) {
    //
    //    } WithUserName:@"wsdwsd" WithPassword:@"wsd2023243" WithUserType:1 WithSource:6 WithPhoneNum:@"13522272537" WithEmail:@"272535439@qq.com"];
    [LoginAndRegister loginWithSucc:^(NSDictionary *DataDic) {
        
    } WithUserName:@"wsdwsd" WithPassword:@"wsd2023243"];
    
    self.title = @"视频地址";
    self.dataArray = [NSMutableArray arrayWithObjects:@"http://zqgbzx.cn:6060/zwapi/videos/ZQ0001.mp4",@"http://zqgbzx.cn:6060/zwapi/videos/zt164.mp4",@"http://zqgbzx.cn:6060/zwapi/videos/zt170.mp4",@"http://zqgbzx.cn:6060/zwapi/videos/zt006.mp4",@"http://zqgbzx.cn:6060/zwapi/videos/xb0802.mp4",@"http://zqgbzx.cn:6060/zwapi/videos/zt126.mp4",@"http://zqgbzx.cn:6060/zwapi/videos/jt027.mp4",@"http://kejian.kj2100.com/fudao/_test/HD/0201/webpage/start.mp4" ,nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}
-(void)createTableView
{

    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
NSString * identifier = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewPlayViewController * view = [[ViewPlayViewController alloc] init];
    view.videoPath = self.dataArray[indexPath.row];
    NSLog(@"view.videoPath%@",view.videoPath);
    [self.navigationController pushViewController:view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
