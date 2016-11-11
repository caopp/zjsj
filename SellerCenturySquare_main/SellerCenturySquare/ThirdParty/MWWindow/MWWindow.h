//
//  MWWindow.h
//  MultipleWindow
//
//  Created by Jeremy Templier on 2/8/14.
// Copyright (c) 2014 Jeremy Templier
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#define kWindowHeaderHeight 224

#define kNextWindowShowAllNotification @"NextWindowShowAllNotification"
#define kNextWindowCloseNotification @"NextWindowCloseNotification"

@interface MWWindow : UIWindow <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL dismissWhenOnTheBottomOfTheScreen;
@property (nonatomic, readonly) UIWindow *superWindow;
@property (nonatomic, readonly) UIWindow *nextWindow;
@property (nonatomic, readonly) UIPanGestureRecognizer *panGesture;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) BOOL tapToCloseEnabled;
- (void)dismissWindowAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)presentWindowAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)showOrClose;
- (void)setPanGestureEnabled:(BOOL)enabled;
- (void)beginStateThenTransitionToUP;
+ (void)dismissAllMWWindows;
@end
