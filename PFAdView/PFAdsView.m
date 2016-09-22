//
//  PFAdsView.m
//  PFAdView
//
//  Created by 小飞 on 16/9/19.
//  Copyright © 2016年 小飞. All rights reserved.
//

#import "PFAdsView.h"
# define CloseButton_with 30    //关闭按钮的宽度
# define Line_with  1.5f        //链接线条的宽度
# define UIcolorFromRGBWithAlpha(rgbValue,a) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:a]

# pragma mark------内容视图

@implementation PFAdsContainerView
{
    UIScrollView *_scroview;
}
@synthesize containerViews;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self buildUI];
    }
    return self;
}
- (void)buildUI{
    _scroview                                   = [[UIScrollView alloc]init];
    _scroview.backgroundColor                   = [UIColor whiteColor];
    _scroview.pagingEnabled                     = YES;
    _scroview.showsVerticalScrollIndicator      = YES;
    _scroview.showsHorizontalScrollIndicator    = YES;
    _scroview.delegate                          = self;
    [self addSubview:_scroview];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    long subViewCount       =   containerViews.count;
    _scroview.frame         =   CGRectInset(self.bounds, 0, 0);
    _scroview.contentSize = CGSizeMake(CGRectGetWidth(_scroview.frame)*subViewCount, CGRectGetHeight(_scroview.frame));
    for (UIView *view in _scroview.subviews)
    {
        [view removeFromSuperview];
    }
    for (int i =0; i < subViewCount; i++)
    {
        UIView *viewToAdd = [containerViews objectAtIndex:i];
        viewToAdd.center = CGPointMake(i*CGRectGetWidth(_scroview.frame)+_scroview.frame.size.width/2.0, _scroview.center.y);
        [_scroview addSubview:viewToAdd];
    }
    _scroview.contentOffset = CGPointZero;
}


- (void)setContainerViews:(NSArray *)containtSubViews{
    if (containtSubViews.count <= 0)
    {
        return;
    }
    containerViews = containtSubViews;
    
    [self layoutSubviews];
}

/** tell the delegate that the scroView did end scroll*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    long index = _scroview.contentOffset.x/self.frame.size.width;
    if (self.scroViewIndex)
    {
        self.scroViewIndex(index);
    }
}




-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    long index = _scroview.contentOffset.x/self.frame.size.width;
    NSLog(@"%ld",index);
}

@end

# pragma makr------关闭按钮
@implementation pfAdsCloceButton

+(instancetype)buttonWithType:(UIButtonType)buttonType
{
    return [super buttonWithType:buttonType];
}

-(void)drawRect:(CGRect)rect
{

    CGFloat buttonWith              = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat radius                  = buttonWith/2.0;
    self.layer.cornerRadius         = radius;
    self.layer.masksToBounds        = YES;
    self.backgroundColor            = [UIColor clearColor];
    self.layer.borderColor          = self.colseButtonTintColor.CGColor;
    self.layer.borderWidth          = Line_with;

    CGContextRef context            = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.colseButtonTintColor.CGColor);
    CGContextSetLineWidth(context, Line_with);
    
    CGContextBeginPath(context);    //开启上下文
    
    CGPathRef path                  = [UIBezierPath bezierPath].CGPath;
    
    CGContextAddPath(context, path);
    
    CGContextMoveToPoint(context, rect.size.width/4, rect.size.height/4);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect)/4*3, CGRectGetMaxY(rect)/4*3);
    
    CGContextMoveToPoint(context, rect.size.width/4*3, rect.size.height/4);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect)/4, CGRectGetMaxY(rect)/4*3);
    
    CGContextStrokePath(context);
}

@end

#   pragma mark------主视图
@implementation PFAdsView
@synthesize minVertalPadding;//垂直边距
@synthesize minHorizontalPadding;//水平边距
@synthesize proportion;//宽高比例
@synthesize containerSubViews;//存放广告视图的数组
@synthesize closeButton;    //关闭按钮
@synthesize mainContainView;   //主视图
@synthesize lineView;          //直线

- (instancetype)initWithView:(UIView *)view
{
    return [super initWithFrame:view.bounds];
}

-(instancetype)initWithWindow:(UIWindow *)window
{
    return [self initWithFrame:window.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    if (self)
    {
        [self buildUI];
    }
    return self;
}

-(void)setContainerSubViews:(NSArray *)containerSubView
{
    if (containerSubView.count<=0)
    {
        return;
    }
    containerSubViews = containerSubView;
    self.mainContainView.containerViews = containerSubViews;
}

- (void)buildUI{
    self.backgroundColor                    =           UIcolorFromRGBWithAlpha(0x606060,1);
    self.userInteractionEnabled             =           YES;
    self.clipsToBounds                      =           YES;
    UITapGestureRecognizer *tapGesture      =           [[UITapGestureRecognizer alloc]initWithTarget:
                                                         self action:@selector(closeButtonAction:)];
    [self addGestureRecognizer:tapGesture];
    
    mainContainView                         =           [[PFAdsContainerView alloc]initWithFrame:
                                                         CGRectZero];
    mainContainView.backgroundColor         =            [UIColor whiteColor];
    mainContainView.scroViewIndex = ^(long index){
        _selectIndex = index;
    };
    [self addSubview:mainContainView];
    
    UITapGestureRecognizer *containViewTap  =           [[UITapGestureRecognizer alloc]initWithTarget:
                                                         self action:@selector(tapContainView:)];
    [mainContainView addGestureRecognizer:containViewTap];
    
    closeButton                             =           [pfAdsCloceButton buttonWithType:UIButtonTypeCustom];
    closeButton.colseButtonTintColor        =           [UIColor whiteColor];
    [self addSubview:closeButton];
    [closeButton setNeedsDisplay];
    
    lineView                                =           [[UIView alloc]init];
    lineView.backgroundColor                =           [UIColor whiteColor];
    lineView.bounds                         =           CGRectMake(0, 0, 1, 0);
    [self addSubview:lineView];
    
    self.minHorizontalPadding               =            0;
    self.minVertalPadding                   =            0;
    self.proportion                         =            0.875;
    mainContainView.layer.cornerRadius      =            10;
    mainContainView.clipsToBounds           =            YES;

}



#   pragma mark------closeButton Action
/** 关闭按钮调用的方法*/
- (void)closeButtonAction:(UIButton *)sender{
    [self hidAnimatation:YES];
}
/** 点击主视图调用的方法*/
- (void)tapContainView:(UITapGestureRecognizer *)tapgesture{
    [self hidAnimatation:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pfAdsViewTapMainContainView:currentSelectIndex:)])
    {
        [self.delegate pfAdsViewTapMainContainView:self currentSelectIndex:_selectIndex];
    }
}

#pragma mark------带看
# pragma mark----set/get
- (void)setMinHorizontalPadding:(float)minHorizontalPadding1{
    
    minHorizontalPadding               = minHorizontalPadding1;
    CGRect containRect                 = mainContainView.frame;
    containRect.origin.x               = minHorizontalPadding;
    containRect.size.width             = self.frame.size.width - minHorizontalPadding *2;
    mainContainView.frame              = containRect;
    
}
- (void)setMinVertalPadding:(float)minVertalPadding1{
    
    minVertalPadding                   = minVertalPadding1;
    CGRect containRect                 = mainContainView.frame;
    containRect.origin.y               = minVertalPadding;
    containRect.size.height            = self.frame.size.height - minVertalPadding *2;
    mainContainView.frame              = containRect;
    
    
}
- (void)setProportion:(float)proportionValue{
    
    if (proportionValue <= 0) {
        return;
    }
    proportion = proportionValue;
    CGRect containRect                 = mainContainView.frame;
    containRect.size.height            = containRect.size.width / proportion;
    //    containRect.origin.y               = (self.frame.size.height - containRect.size.height)/2;
    containRect.origin.y               = self.frame.size.height;
    mainContainView.frame              = containRect;
    
    closeButton.bounds                 = CGRectMake(0, 0,CloseButton_with,CloseButton_with);
    closeButton.center                 = CGPointMake(CGRectGetMaxX(mainContainView.frame) - closeButton.bounds.size.width/2, -closeButton.frame.size.height);
    closeButton.layer.cornerRadius     = closeButton.frame.size.width/2;
    closeButton.clipsToBounds          = YES;
    [closeButton addTarget:self
                    action:@selector(closeButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)showAnimatation:(BOOL)animatation{
    
    __weak PFAdsView *weakSelf = self;
    CGRect rect = self.frame;
    rect.origin.y = 0;
    self.frame = rect;
    
    if (animatation) {
        [UIView animateWithDuration:.75f
                              delay:0.2
             usingSpringWithDamping:0.65f
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             CGRect containRect = weakSelf.mainContainView.frame;
                             containRect.origin.y = (weakSelf.frame.size.height - weakSelf.mainContainView.frame.size.height)/2;
                             weakSelf.mainContainView.frame = containRect;
                             
                             
                             
                             weakSelf.closeButton.center                 = CGPointMake(CGRectGetMaxX(weakSelf.mainContainView.frame) - weakSelf.closeButton.bounds.size.width/2,CGRectGetMinY(weakSelf.mainContainView.frame)/2);
                         }
                         completion:^(BOOL finished) {
                             CGRect lineRect = weakSelf.lineView.frame;
                             lineRect.origin.y = CGRectGetMaxY(weakSelf.closeButton.frame);
                             lineRect.size.height = CGRectGetMinY(weakSelf.mainContainView.frame) - CGRectGetMaxY(weakSelf.closeButton.frame);
                             lineRect.origin.x = weakSelf.closeButton.center.x;
                             weakSelf.lineView.frame = lineRect;
                             
                         }];
    }
    else {
        self.alpha = 1.0f;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pfAdsViewDidApper:)]) {
        [self.delegate pfAdsViewDidApper:self];
    }
    
}
- (void)hidAnimatation:(BOOL)animatation{
    
    __weak PFAdsView *weakSelf = self;
    if (animatation) {
        [UIView animateWithDuration:.5f
                              delay:0.2
             usingSpringWithDamping:0.65f
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect containRect = weakSelf.mainContainView.frame;
                             containRect.origin.y = weakSelf.frame.size.height;
                             weakSelf.mainContainView.frame = containRect;
                             
                             weakSelf.closeButton.center                 = CGPointMake(CGRectGetMaxX(weakSelf.mainContainView.frame) - weakSelf.closeButton.bounds.size.width/2,weakSelf.frame.size.height+ weakSelf.closeButton.frame.size.height/2);
                             CGRect lineRect = weakSelf.lineView.frame;
                             lineRect.origin.y = CGRectGetMaxY(weakSelf.closeButton.frame);
                             weakSelf.lineView.frame = lineRect;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             CGRect rect = weakSelf.frame;
                             rect.origin.y = weakSelf.frame.size.height;
                             weakSelf.frame = rect;
                             weakSelf.alpha = 0.0f;
                             [weakSelf removeFromSuperview];
                         }];
    }
    else {
        [self removeFromSuperview];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pfAdsViewDidDisApper:)]) {
        [self.delegate pfAdsViewDidDisApper:self];
    }
    
}



/**
 *  画线
 *
 *  @param superView 父视图
 *  @param width     线条宽度
 *  @param color     线条颜色
 *  @param sPoint    开始点
 *  @param ePoint    结束点
 */
- (void)drawLineOnView:(UIView *)superView
             lineWidth:(CGFloat )width
          strokeColor :(UIColor *)color
            startPoint:(CGPoint )sPoint
              endPoint:(CGPoint )ePoint
{
    CAShapeLayer *lineShape   = nil;
    CGMutablePathRef linePath = nil;
    linePath                  = CGPathCreateMutable();
    lineShape                 = [CAShapeLayer layer];
    lineShape.lineWidth       = width;
    lineShape.lineCap         = kCALineCapRound;
    lineShape.strokeColor     = color.CGColor;
    CGPathMoveToPoint(linePath, NULL, sPoint.x , sPoint.y );
    CGPathAddLineToPoint(linePath, NULL, ePoint.x , ePoint.y);
    lineShape.path            = linePath;
    CGPathRelease(linePath);
    [superView.layer addSublayer:lineShape];
}

@end

