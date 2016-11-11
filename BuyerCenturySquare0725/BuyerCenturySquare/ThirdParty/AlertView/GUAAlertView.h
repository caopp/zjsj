//
//  GUAAlertView.h
//  GUAAlertView
//
//  Created by gua on 11/11/14.
//  Copyright (c) 2014 GUA. All rights reserved.
//

//@import UIKit;
#import "UIImage+ImageEffects.h"
// !颜色
#import "UIColor+UIColor.h"

typedef void (^GUAAlertViewBlock)(void);


@interface GUAAlertView : UIView

/**
 *
 *  @param title             标题 可为nil
 *  @param titleColor        标题颜色
 *  @param titleFont         标题字体大小（和下面方法不一样的地方）如果为默认的，则传0即可
 *  @param message           信息
 *  @param messageColor      信息颜色
 *  @param buttonTitle       右边按钮文字（被称为 “第一个按钮”）
 *  @param okButtonColor     右边按钮文字的颜色
 *  @param cancelButtonTitle 左边按钮文字（被称为“第二个按钮”）
 *  @param cancelBtnColor    左边按钮文字的颜色
 *  @param shotView          要添加alert的view  不可以为nil
 *  @param buttonBlock       右边按钮的事件
 *  @param dismissBlock      左边按钮的事件
 
 */
+ (instancetype)alertViewWithTitle:(NSString *)title  withTitleClor:(UIColor *)titleColor  withTitleFont:(CGFloat )titleFont  message:(NSString *)message                                                        withMessageColor:(UIColor *)messageColor
                     oKButtonTitle:(NSString *)buttonTitle
                 withOkButtonColor:(UIColor *)okButtonColor
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 withOkCancelColor:(UIColor *)cancelBtnColor  withView:(UIView *)shotView
               buttonTouchedAction:(GUAAlertViewBlock)buttonBlock
                     dismissAction:(GUAAlertViewBlock)dismissBlock;



/**
 *
 *  @param title             标题 
 *  @param titleColor        标题颜色
 *  @param message           信息
 *  @param messageColor      信息颜色
 *  @param buttonTitle       右边按钮文字（被称为 “第一个按钮”）
 *  @param okButtonColor     右边按钮文字的颜色
 *  @param cancelButtonTitle 左边按钮文字（被称为“第二个按钮”）
 *  @param cancelBtnColor    左边按钮文字的颜色
 *  @param shotView          要添加alert的view   不可以为nil
 *  @param buttonBlock       右边按钮的事件
 *  @param dismissBlock      左边按钮的事件
 */
+ (instancetype)alertViewWithTitle:(NSString *)title  withTitleClor:(UIColor *)titleColor    message:(NSString *)message  withMessageColor:(UIColor *)messageColor
                     oKButtonTitle:(NSString *)buttonTitle
                 withOkButtonColor:(UIColor *)okButtonColor
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 withOkCancelColor:(UIColor *)cancelBtnColor  withView:(UIView *)shotView
               buttonTouchedAction:(GUAAlertViewBlock)buttonBlock
                     dismissAction:(GUAAlertViewBlock)dismissBlock;

/**
 *  最后一个字体的颜色
 */
@property (nonatomic ,strong) UIColor *lastTextColor;
- (void)show;
- (void)dismiss;

//!是否需要判断 有弹出框的存在
@property(nonatomic,assign)BOOL withJudge;


@end
