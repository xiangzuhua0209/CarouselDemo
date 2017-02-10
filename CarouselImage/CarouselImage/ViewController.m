//
//  ViewController.m
//  CarouselImage
//
//  Created by DayHR on 2017/2/8.
//  Copyright © 2017年 haiqinghua. All rights reserved.
//

#import "ViewController.h"

#define imageCount 3//图片的张数
//当前设备的屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//当前设备的屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static NSInteger pageNumber = 0;//用于记录计时器计时循环

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl * pageController;//页面控制器
@property(nonatomic,strong)NSTimer * timer;//计时器
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self initView];
}
#pragma mark -- 初始化对象
-(void)initObject{
}
#pragma mark -- 初始化视图
-(void)initView{
    //添加ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.scrollView.contentSize = CGSizeMake((imageCount + 2)*kScreenWidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentOffset = CGPointMake(1*kScreenWidth, 0);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //添加图片
    for (int i = 0; i < imageCount+2; i++) {
        if (i == 0) {
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, 250)];
            [self.scrollView addSubview:imageV];
            imageV.image = [UIImage imageNamed:@"13.jpg"];
        } else if(i == imageCount + 1){
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, 250)];
            [self.scrollView addSubview:imageV];
            imageV.image = [UIImage imageNamed:@"11.jpg"];
        }else{
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, 250)];
            [self.scrollView addSubview:imageV];
            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"1%d.jpg",i]];
        }
    }
    //在scrollView上添加page
    self.pageController = [[UIPageControl alloc] init];
    [self.view addSubview:self.pageController];
    self.pageController.frame = CGRectMake(kScreenWidth/2 - 50, 250-20, 100, 25);
    self.pageController.numberOfPages = imageCount;
    self.pageController.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageController.currentPageIndicatorTintColor = [UIColor cyanColor];
    self.pageController.currentPage = 0;
    
}
#pragma mark -- 代理方法
#pragma mark -- UIScrollViewDelegate
//scrollView滑动时走的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当scrollView滑动时，设置page
    CGFloat scroll = scrollView.contentOffset.x/kScreenWidth;
    NSInteger number = (NSInteger)scroll;//偏移了几个屏幕宽的距离
    if (number == imageCount+1||(number == imageCount&&scroll - number > kScreenWidth/2)) {//如果偏移为最大值或将要到最大值
        self.pageController.currentPage = 0;
    }else if (number == 0||(number == 0&&scroll-number < kScreenWidth/2)){//如果偏移为最小值或者将要到最小值
        self.pageController.currentPage = imageCount- 1;
    }else{
        if (scroll - number>kScreenWidth/2) {
            self.pageController.currentPage = (number-1)+1;
        }
        if (scroll - number<=kScreenWidth/2) {
            self.pageController.currentPage = (number-1);
        }
    }
}
//scrollView结束减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x == (imageCount + 1)*kScreenWidth) {//手动滑到最后一张ImageView
        self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }else if (self.scrollView.contentOffset.x == 0*kScreenWidth) {//手动滑到第一张ImageView
        self.scrollView.contentOffset = CGPointMake(imageCount*kScreenWidth, 0);//跳到了倒数第二张ImageView(即最后一张图)
    }
    //启动定时器
    [self beginAction];
    //拖拽结束后给记录轮播到第几张的变量赋值
    NSInteger number = (NSInteger)self.scrollView.contentOffset.x/kScreenWidth;
    if (number == imageCount+1){//在最后一张(向左才会到这里)
        pageNumber = 0;
    }else if(number == 0){//在scrollView的第一张(向右才会到这里)
        pageNumber = imageCount -1;
    }else{
        pageNumber = number - 1;
    }
}
//开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //结束计时
    [self stopAction];
}

#pragma mark -- 点击事件
-(void)timerAction{
    if(pageNumber == imageCount){//在第一张图（最后一张ImageView）
        pageNumber = 0;
        //跳到第一张图
        self.scrollView.contentOffset = CGPointMake(kScreenWidth,0);
        //然后滑到视觉上第二张图片
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake((pageNumber+2)*kScreenWidth,0);
        }];
    }else if(pageNumber == 0){//在第一张图(第二张ImageView)
        //滑到视觉上第二张图
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake((pageNumber+2)*kScreenWidth,0);
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake((pageNumber+2)*kScreenWidth,0);
        }];
    }
    pageNumber++;
}
#pragma mark -- 私有方法
-(void)beginAction{
    //如果计时器已开启  先停止
    if (self.timer) [self stopAction];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}
-(void)stopAction{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
