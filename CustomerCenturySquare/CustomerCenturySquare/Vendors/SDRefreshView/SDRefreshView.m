//
//  SDRefreshView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */
#import "SDRefreshView.h"
#import "UIView+SDExtension.h"

const CGFloat SDRefreshViewDefaultHeight = 74.0f;//刷新的view的高度
const CGFloat SDActivityIndicatorViewMargin = 50.0f;
const CGFloat SDTextIndicatorMargin = 20.0f;
const CGFloat SDTimeIndicatorMargin = 10.0f;

@implementation SDRefreshView
{
    UIImageView *_stateIndicatorView;
    UILabel *_textIndicator;
    UILabel *_timeIndicator;
    NSString *_lastRefreshingTimeString;
    SDRefreshViewStyle _refreshStyle;
    BOOL _hasSetOriginalInsets;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_refreshStyle == SDRefreshViewStyleClassical) {
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [activity startAnimating];
            [self addSubview:activity];
            _activityIndicatorView = activity;
            
            
            // 状态提示图片
            UIImageView *stateIndicator = [[UIImageView alloc] init];
            stateIndicator.image = [UIImage imageNamed:@"sdRefeshView_arrow"];
            [self addSubview:stateIndicator];
            _stateIndicatorView = stateIndicator;
            _stateIndicatorView.bounds = CGRectMake(0, 0, 15, 40);
            
            // 状态提示label
            UILabel *textIndicator = [[UILabel alloc] init];
            textIndicator.bounds = CGRectMake(0, 0, 300, 30);
            textIndicator.textAlignment = NSTextAlignmentCenter;
            textIndicator.backgroundColor = [UIColor clearColor];
            textIndicator.font = [UIFont systemFontOfSize:14];
            textIndicator.textColor = [UIColor lightGrayColor];
            [self addSubview:textIndicator];
            _textIndicator = textIndicator;
            
            // 更新时间提示label
            UILabel *timeIndicator = [[UILabel alloc] init];
            timeIndicator.bounds = CGRectMake(0, 0, 160, 16);;
            timeIndicator.textAlignment = NSTextAlignmentCenter;
            timeIndicator.textColor = [UIColor lightGrayColor];
            timeIndicator.font = [UIFont systemFontOfSize:14];
            [self addSubview:timeIndicator];
            _timeIndicator = timeIndicator;
        }
    }
    return self;
}

+ (instancetype)refreshView
{
    return [[self alloc] init];
}

+ (instancetype)refreshViewWithStyle:(SDRefreshViewStyle)refreshViewStayle
{
    SDRefreshView *refresh = [self alloc];
    [refresh setRefreshStyle:refreshViewStayle];
    
    return [refresh init];
}

- (void)setRefreshStyle:(SDRefreshViewStyle)refreshStyle
{
    _refreshStyle = refreshStyle;
}
//当移动视图前调用
- (void)didMoveToSuperview
{
//    self.bounds = CGRectMake(0, 0, self.scrollView.frame.size.width, SDRefreshViewDefaultHeight);
    self.bounds = CGRectMake(0, 0, BOUNDSWIDTH, SDRefreshViewDefaultHeight);

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _activityIndicatorView.center = CGPointMake(SDActivityIndicatorViewMargin, self.sd_height * 0.5);
    _stateIndicatorView.center = _activityIndicatorView.center;
    
    _textIndicator.center = CGPointMake(self.sd_width * 0.5, _activityIndicatorView.sd_height * 0.5 + SDTextIndicatorMargin);
    _timeIndicator.center = CGPointMake(self.sd_width * 0.5, self.sd_height - _timeIndicator.sd_height * 0.5 - SDTimeIndicatorMargin);
}

- (NSString *)lastRefreshingTimeString
{
    if (_lastRefreshingTimeString == nil) {
        return [self refreshingTimeString];
    }
    return _lastRefreshingTimeString;
}

- (void)addToScrollView:(UIScrollView *)scrollView
{
//    _scrollView = scrollView;
    
    
    [scrollView addSubview:self];
//    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    // 默认是在NavigationController控制下，否则可以调用addToScrollView:isEffectedByNavigationController:(设值为NO) 即可
//    _isEffectedByNavigationController = YES;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) {
        _isEffectedByNavigationController = YES;
        self.scrollView = (UIScrollView *)newSuperview;
        [self addObservers];
    }
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:SDRefreshViewObservingkeyPath options:options context:nil];


}

- (void)removeObservers
{
    if (self.subviews == nil) {
        return;
    }
    
    [self.superview removeObserver:self forKeyPath:SDRefreshViewObservingkeyPath];
}

- (void)addToScrollView:(UIScrollView *)scrollView isEffectedByNavigationController:(BOOL)effectedByNavigationController
{
    [self addToScrollView:scrollView];
    _isEffectedByNavigationController = effectedByNavigationController;
    _originalEdgeInsets = scrollView.contentInset;
}

- (void)addTarget:(id)target refreshAction:(SEL)action
{
    _beginRefreshingTarget = target;
    _beginRefreshingAction = action;
}


// 获得在scrollView的contentInset原来基础上增加一定值之后的新contentInset
- (UIEdgeInsets)syntheticalEdgeInsetsWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    return UIEdgeInsetsMake(_originalEdgeInsets.top + edgeInsets.top, _originalEdgeInsets.left + edgeInsets.left, _originalEdgeInsets.bottom + edgeInsets.bottom, _originalEdgeInsets.right + edgeInsets.right);
    

}

- (void)setRefreshState:(SDRefreshViewState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
            // 进入刷新状态
        case SDRefreshViewStateRefreshing:
        {
            if (!_hasSetOriginalInsets) {
                _originalEdgeInsets = self.scrollView.contentInset;
                _hasSetOriginalInsets = YES;
            }
           
           
            _scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];

            [_activityIndicatorView startAnimating];
            _stateIndicatorView.hidden = YES;
            _activityIndicatorView.hidden = NO;
            _lastRefreshingTimeString = [self refreshingTimeString];
            _textIndicator.text = SDRefreshViewRefreshingStateText;//SDRefreshViewRefreshingStateText
            
            if (self.refreshingStateOperationBlock) {
                self.refreshingStateOperationBlock(self, 1.0);
            }
            
            if ([self.delegate respondsToSelector:@selector(refreshView:didBecomeRefreshingStateWithMovingProgress:)]) {
                
                
                [self.delegate refreshView:self didBecomeRefreshingStateWithMovingProgress:1.0];
            }
            
        
            //开始加载数据  lyt
            self.repeat=YES;//重复执行
            
            //执行动画  lyt
            [self makeAni];
         
            
            
            if (self.beginRefreshingOperation) {
                
                self.beginRefreshingOperation();
                
            } else if (self.beginRefreshingTarget) {
                if ([self.beginRefreshingTarget respondsToSelector:self.beginRefreshingAction]) {
                    
                    // 屏蔽performSelector-leak警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.beginRefreshingTarget performSelector:self.beginRefreshingAction];
                }
            }
        }
            break;
            
        case SDRefreshViewStateWillRefresh:
        {
            _textIndicator.text = SDRefreshViewWillRefreshStateText;
            
            
            //将要开始加载数据 lyt
            self.repeat=NO;
            
        
            [self makeHeaderView];
            
            
            
            if ([self.delegate respondsToSelector:@selector(refreshView:didBecomeWillRefreshStateWithMovingProgress:)]) {
                [self.delegate refreshView:self didBecomeWillRefreshStateWithMovingProgress:1.0];
            }
            
            
            if (self.willRefreshStateOperationBlock) {
                self.willRefreshStateOperationBlock(self, 1);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewWillRefreshStateTransformAngle);
            }];
        
        }
            break;
            
        case SDRefreshViewStateNormal:
            
            
            //加载结束
            self.repeat=NO;//不重复执行，停止动画  lyt
            
            
            if ([self.delegate respondsToSelector:@selector(refreshView:didBecomeNormalStateWithMovingProgress:)]) {
                [self.delegate refreshView:self didBecomeNormalStateWithMovingProgress:0];
            }
            
            if (self.normalStateOperationBlock) {
                self.normalStateOperationBlock(self, 0);
            }
            _textIndicator.text = self.textForNormalState;
            _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewNormalTransformAngle);
            _timeIndicator.text = [NSString stringWithFormat:@"最后更新：%@", [self lastRefreshingTimeString]];
            _stateIndicatorView.hidden = NO;
            [_activityIndicatorView stopAnimating];
            _activityIndicatorView.hidden = YES;
            break;
        case SDRefreshViewStateNoData:
            
            
            //加载结束
            self.repeat=NO;//不重复执行，停止动画  lyt
            
            
            if ([self.delegate respondsToSelector:@selector(refreshView:didBecomeNormalStateWithMovingProgress:)]) {
                [self.delegate refreshView:self didBecomeNormalStateWithMovingProgress:0];
            }
            
            if (self.normalStateOperationBlock) {
                self.normalStateOperationBlock(self, 0);
            }
            _textIndicator.text = SDRefreshViewNoDataText;
            
            _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewNormalTransformAngle);
            _timeIndicator.text = @"";
            _stateIndicatorView.hidden = YES;//!隐藏箭头
            [_activityIndicatorView stopAnimating];
            _activityIndicatorView.hidden = YES;
            break;
        
            
        default:
            break;
    }
}


- (void)setNormalStateOperationBlock:(RefreshViewOperationBlock)normalStateOperationBlock
{
    _normalStateOperationBlock = normalStateOperationBlock;
    _normalStateOperationBlock(self, 0);
}

- (void)endRefreshing
{
    [UIView animateWithDuration:0.6 animations:^{
        
        _scrollView.contentInset = _originalEdgeInsets;
        [self setRefreshState:SDRefreshViewStateNormal];
        if (self.isManuallyRefreshing) {
            self.isManuallyRefreshing = NO;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}
//!没有数据的时候
- (void)noDataRefresh
{
    [UIView animateWithDuration:0.6 animations:^{
        
        _scrollView.contentInset = _originalEdgeInsets;
        
        [self setRefreshState:SDRefreshViewStateNoData];
        
        if (self.isManuallyRefreshing) {
            self.isManuallyRefreshing = NO;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


// 更新时间
- (NSString *)refreshingTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

//// 保留！
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    ;
//}

//- (void)dealloc
//{
//    [_scrollView removeObserver:self forKeyPath:SDRefreshViewObservingkeyPath context:nil];
//    [self.superview removeObserver:self forKeyPath:SDRefreshViewObservingkeyPath];
//}

//headerView需要重写的方法 lyt

//创建动画上面需要的UI
-(void)makeHeaderView{


}
//执行动画
-(void)makeAni{

    
}

@end
