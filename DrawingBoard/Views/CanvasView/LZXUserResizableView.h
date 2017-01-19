//
//  LZXUserResizableView.h
//  lexue-teacher
//
//  Created by lezhixing on 13-7-10.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZXGripViewBorderView;
@class LZXUserResizableView;

@protocol LZXUserResizableViewDelegate <NSObject>
@optional
// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(LZXUserResizableView *)userResizableView;
// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(LZXUserResizableView *)userResizableView;
@end

@interface LZXUserResizableView : UIView <UIGestureRecognizerDelegate>
{
    UIView *contentView;
    LZXGripViewBorderView *borderView;
}

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGPoint touchCenter;//拖动中心
@property (nonatomic, assign) CGPoint scaleCenter;//捏合中心
@property (nonatomic, assign) CGPoint rotationCenter;//旋转中心
@property (nonatomic, assign) CGFloat scale;// 缩放比例
//used for 限制缩放
@property (nonatomic, assign) NSUInteger gestureCount;
@property (nonatomic, assign) CGFloat outputWidth;
@property (nonatomic, assign) CGFloat minimumScale;
@property (nonatomic, assign) CGFloat maximumScale;

@property (nonatomic, assign) id <LZXUserResizableViewDelegate> delegate;

- (void)reset:(BOOL)animated;//显示边框

@end
