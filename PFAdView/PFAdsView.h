//
//  PFAdsView.h
//  PFAdView
//
//  Created by 小飞 on 16/9/19.
//  Copyright © 2016年 小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

# pragma mark------广告内容视图
/**
 *     @author xiaofei, 16-09-19 11:09:41
 *
 *     @brief 广告内容明显需要放到一个视图上，广告内容有可能是需要滑动的，所以要继承自UIView并且遵守UIScroViewDelegate
 */
@interface PFAdsContainerView : UIView<UIScrollViewDelegate>

/**用于存放每个广告的内容的数组*/
@property (nonatomic,strong)NSArray *containerViews;
/**获取实时的索引值*/
@property (nonatomic,copy)void (^scroViewIndex)(long index);

@end



@interface pfAdsCloceButton : UIButton
/** 关闭按钮前景色 */
@property (nonatomic,retain)UIColor *colseButtonTintColor;
@end




# pragma -mark------存放广告视图的主视图
@class PFAdsView;

@protocol PFAdsViewdelegate <NSObject>
@optional
/**
 *     @author xiaofei, 16-09-19 13:09:15
 *
 *     @brief 广告视图已经出现
 *
 *     @param view 弹框视图
 */
- (void)pfAdsViewDidApper:(PFAdsView *)view;

/**
 *     @author xiaofei, 16-09-19 17:09:44
 *
 *     @brief 广告视图已经出现
 *
 *     @param view 弹框视图
 */
- (void)pfAdsViewDidDisApper:(PFAdsView *)view;

/**
 *     @author xiaofei, 16-09-19 17:09:03
 *
 *     @brief 点击主内容视图
 *
 *     @param view        弹框视图
 *     @param selectIndex 当前选中的索引值
 */
- (void)pfAdsViewTapMainContainView:(PFAdsView *)view currentSelectIndex:(long)selectIndex;

@end






/**
 *     @author xiaofei, 16-09-21 14:09:40
 *
 *     @brief 单个广告的内容视图
 */
@interface PFAdsView : UIView
{
/**     当前展示的索引值       */
    long _selectIndex;
}
/** 存放广告内容视图的数组      */
@property (nonatomic,retain)NSArray *containerSubViews;
/** 主内容视图               */
@property (nonatomic,retain)PFAdsContainerView *mainContainView;
/** 关闭按钮                 */
@property (nonatomic,retain)pfAdsCloceButton *closeButton;
/** 关闭按钮链接广告内容的直线   */
@property (nonatomic,retain)UIView *lineView;
/** 水平边距                  */
@property (nonatomic,assign)float minHorizontalPadding;
/** 垂直编剧                  */
@property (nonatomic,assign)float minVertalPadding;
/** 宽高比例                  */
@property (nonatomic,assign)float proportion;

@property (nonatomic,weak)id <PFAdsViewdelegate>delegate;

- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithWindow:(UIWindow *)window;
- (void)showAnimatation:(BOOL)animatation;
- (void)hidAnimatation:(BOOL)animatation;

@end
