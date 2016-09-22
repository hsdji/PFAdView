//
//  ViewController.m
//  PFAdView
//
//  Created by 小飞 on 16/9/19.
//  Copyright © 2016年 小飞. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PFAdsView.h"
@interface ViewController ()<PFAdsViewdelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.backgroundColor = [UIColor colorWithWhite:20
                                                   alpha:0.3];
    PFAdsView *adsView = [[PFAdsView alloc] initWithWindow:app.window];
    adsView.tag = 10;
    adsView.delegate = self;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.width)];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"视图 %d", i+1];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor redColor];
        label.layer.cornerRadius = adsView.mainContainView.frame.size.width/2;
        label.layer.masksToBounds = YES;
        [array addObject:label];
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.height)];
//        
//        [UIView animateWithDuration:1 animations:^{
//            view.backgroundColor = [UIColor redColor];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 animations:^{
//                view.backgroundColor = [UIColor yellowColor];
//            }];
//        }];
//        view.layer.masksToBounds = YES;
//        view.layer.cornerRadius = CGRectGetWidth(view.bounds)/2.0;
//        [array addObject:view];
    }
    [self.view addSubview:adsView];
    adsView.containerSubViews = array;
    [adsView showAnimatation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hide{
    PFAdsView *adsView = (PFAdsView *)[self.view viewWithTag:10];
    [adsView hidAnimatation:YES];
}



- (void)pfAdsViewDidApper:(PFAdsView *)view{
    NSLog(@"视图出现");
}
- (void)pfAdsViewDidDisApper:(PFAdsView *)view{
    NSLog(@"视图消失");
}

-(void)pfAdsViewTapMainContainView:(PFAdsView *)view currentSelectIndex:(long)selectIndex
{
    NSLog(@"点击主内容视图:--%ld",selectIndex);
}


@end
