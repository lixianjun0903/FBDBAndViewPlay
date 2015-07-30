//
//  ViewPlayViewController.m
//  video
//
//  Created by 李李贤军 on 15/7/26.
//  Copyright (c) 2015年 TH. All rights reserved.
//

#import "ViewPlayViewController.h"
#import "KrVideoPlayerController.h"
#import "DataBase.h"
#import "videoModel.h"
@interface ViewPlayViewController (){
    double time1;
}
@property(nonatomic,strong)UIView * Play;
@property(nonatomic,strong)KrVideoPlayerController * videoController;
@property(nonatomic,assign)NSTimeInterval currentTime;
@property(nonatomic,strong)UIButton * downLoadButton;

@end

@implementation ViewPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *notification=[NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(movieLoadStateChange:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:self.videoController];
    self.view.backgroundColor =[UIColor whiteColor];
    //创建数据库
    [DataBase shareSQL];
    [self playVideo];
    //退出视频播放
    [self outVideoPlay];
    //离线缓存
    [self createButton];
}

-(void)createButton
{
    UIButton * downLoadBtton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2.0, 220, 80, 80)];
    [downLoadBtton setTitle:@"离线缓存" forState:UIControlStateNormal];
    [downLoadBtton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [downLoadBtton addTarget:self action:@selector(downLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.downLoadButton = downLoadBtton;
    [self.view addSubview:downLoadBtton];
}
#pragma mark- 离线缓存
-(void)downLoadButtonClick
{
    NSLog(@"离线缓存");

}
-(void)outVideoPlay
{
    UIButton  * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 80, 40)];
    [leftButton setTitle:@"退出播放" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
       }

#pragma mark - 退出视频播放，记录当前播放时间，并存储在数据库中
-(void)outClick
{
    
    //获取当前退出时播放的时间
    self.currentTime = self.videoController.currentPlaybackTime ;
    NSLog(@"currentTime==%f",self.currentTime);
    //时间转化
    double time = round(self.currentTime);
    NSLog(@"currentTime==%f",time);
    videoModel *modelNew = [[videoModel alloc] init];
    modelNew.time = [NSString stringWithFormat:@"%f",time];
    modelNew.videoUrl = self.videoPath;
    DataBase *data = [DataBase shareSQL];
    NSArray *array = [data selectFromDB];
    int a = 0;
    for (videoModel *model in array) {
        if ([model.videoUrl isEqualToString:self.videoPath]) {
            a++;
            [data upDate:modelNew];
        }
    }
    //插入数据
    if (a == 0) {
        [data insertDB:modelNew];
    }
    [self.videoController dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)playVideo{
    NSURL *url = [NSURL URLWithString:self.videoPath];
    DataBase *data = [DataBase shareSQL];
    NSArray *array = [data selectFromDB];
    NSLog(@"%@",array);
    
    
//    //当数组内有model的时候 取时间.
//    if (array.count != 0) {
//       videoModel *model = array[0];
//        NSLog(@"%@",model.time);
//        [self addVideoPlayerWithURL:url time:model.time];
//    }else{
//        //无值直接传0.0秒
//        [self addVideoPlayerWithURL:url time:nil];
//    }
    //当数组内有model的时候 取时间.
    
    if (array.count != 0) {
        for (videoModel *model in array) {
            
            if ([model.videoUrl isEqualToString:self.videoPath]&&model.time !=nil) {
                
                NSLog(@"每次进来对比数据库中的标识和现在是视频path%@",model.time);
                [self addVideoPlayerWithURL:url time:model.time];
            }else
            {
            [self addVideoPlayerWithURL:url time:nil];
            }
        }
        
    }
    else
    {
        //无值直接传0.0秒
        [self addVideoPlayerWithURL:url time:nil];
    }
}

- (void)addVideoPlayerWithURL:(NSURL *)url time:(NSString *)time{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            weakSelf.navigationController.navigationBarHidden = NO;
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            weakSelf.navigationController.navigationBarHidden = YES;
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    //接着上次播放的时间继续播放
    if (time != nil) {
        double prograss = [time doubleValue];
        time1 = prograss;
        [self.videoController setCurrentPlaybackTime:floor(prograss)];
        [self.videoController play];
        
    }
    
 
    NSLog(@"持续时间%f",self.videoController.playableDuration);
}
-(void)movieLoadStateChange:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo);
    [self.videoController setCurrentPlaybackTime:floor(time1)];
}
@end
