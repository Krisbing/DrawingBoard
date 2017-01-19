//
//  LZXUserResizableView.m
//  lexue-teacher
//
//  Created by lezhixing on 13-7-10.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXUserResizableView.h"
#import "QuartzCore/QuartzCore.h"
#import "UIView+ZXQuartz.h"

#define kSPUserResizableViewGlobalInset 2.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0

@interface LZXGripViewBorderView : UIView
@end
@implementation LZXGripViewBorderView
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [self drawEditboxLines:rect];
}
@end

@interface LZXUserResizableView()
{
    @private
    CGSize _originalImageViewSize;
}
@end
@implementation LZXUserResizableView
@synthesize contentView = _contentView;

@synthesize touchCenter = _touchCenter;
@synthesize scaleCenter = _scaleCenter;
@synthesize rotationCenter = _rotationCenter;
@synthesize scale = _scale;

//限制缩放
@synthesize gestureCount = _gestureCount;
@synthesize outputWidth = _outputWidth;
@synthesize minimumScale = _minimumScale;
@synthesize maximumScale = _maximumScale;

@synthesize delegate = _delegate;

- (void) initialize
{
    self.opaque = NO;
    self.layer.opacity = 0.7;
    self.backgroundColor = [UIColor clearColor];
    //creat backgroudView
    borderView = [[LZXGripViewBorderView alloc] initWithFrame:CGRectInset(self.frame, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    [borderView setHidden:YES];
    [self addSubview:borderView];
    [borderView setNeedsDisplay];
    _scale = 1.0;
    //建立手势
     UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];//慢慢拖动
    panRecognizer.cancelsTouchesInView = NO;
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];//捏合
    pinchRecognizer.cancelsTouchesInView = NO;
    pinchRecognizer.delegate = self;
    [self addGestureRecognizer:pinchRecognizer];
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];//旋转
    rotationRecognizer.cancelsTouchesInView = NO;
    rotationRecognizer.delegate = self;
    [self addGestureRecognizer:rotationRecognizer];
     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];//单击
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if(self) {
//        [self initialize];
//    }
//    return self;
//}
- (void)setContentView:(UIView *)newContentView {
    if(_contentView){
        [_contentView removeFromSuperview];
    }
    _contentView = newContentView;
    _contentView.frame = CGRectInset(self.frame, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    [self addSubview:_contentView];
    [self insertSubview:_contentView belowSubview:borderView];
    //
   
}
#pragma mark Touches

- (void)handleTouches:(NSSet*)touches
{
    self.touchCenter = CGPointZero;
    if(touches.count < 2) return;
    
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = (UITouch*)obj;
        CGPoint touchLocation = [touch locationInView:self];
        self.touchCenter = CGPointMake(self.touchCenter.x + touchLocation.x, self.touchCenter.y +touchLocation.y);
    }];
    self.touchCenter = CGPointMake(self.touchCenter.x/touches.count, self.touchCenter.y/touches.count);
    
    _point(self.touchCenter);
    // Notify the delegate we've ended our editing session.
//    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
//        [self.delegate userResizableViewDidEndEditing:self];
//    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
        [self.delegate userResizableViewDidBeginEditing:self];
    }
    [self reset:YES];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    UITouch *touch = [touches anyObject];
    _pr(touch.view.frame);
    // Notify the delegate we've ended our editing session.
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
        [self.delegate userResizableViewDidEndEditing:self];
    }

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    // Notify the delegate we've ended our editing session.
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
        [self.delegate userResizableViewDidEndEditing:self];
    }

}
#pragma mark Gestures
- (BOOL)handleGestureState:(UIGestureRecognizerState)state
{
    BOOL handle = YES;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.gestureCount++;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            self.gestureCount--;
            handle = NO;
            if(self.gestureCount == 0) {
                CGFloat scale = self.scale;
                if(self.minimumScale != 0 && self.scale < self.minimumScale) {
                    scale = self.minimumScale;
                } else if(self.maximumScale != 0 && self.scale > self.maximumScale) {
                    scale = self.maximumScale;
                }
                if(scale != self.scale) {
                    CGFloat deltaX = self.scaleCenter.x-self.bounds.size.width/2.0;
                    CGFloat deltaY = self.scaleCenter.y-self.bounds.size.height/2.0;
                    
                    CGAffineTransform transform =  CGAffineTransformTranslate(self.transform, deltaX, deltaY);
                    transform = CGAffineTransformScale(transform, scale/self.scale , scale/self.scale);
                    transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
                    self.userInteractionEnabled = NO;
                    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.transform = transform;
                    } completion:^(BOOL finished) {
                        self.userInteractionEnabled = YES;
                        self.scale = scale;
                    }];
                    
                }
            }
        } break;
        default:
            break;
    }
    return handle;
}
- (void)handleTap:(UITapGestureRecognizer *)recogniser {
    [self reset:YES];
    //显示边框
}
- (void)handlePan:(UIPanGestureRecognizer*)recognizer//拖动
{
    if([self handleGestureState:recognizer.state]) {
        CGPoint translation = [recognizer translationInView:self];
        CGAffineTransform transform = CGAffineTransformTranslate( self.transform, translation.x, translation.y);
        self.transform = transform;
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
    LOG(@"recognizer------?%@",recognizer.view);
    NSLog(@"x->%f   y-> %f",recognizer.view.frame.origin.x,recognizer.view.frame.origin.y);
}
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer//捏合
{
    if([self handleGestureState:recognizer.state]) {
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.scaleCenter = self.touchCenter;
        }
        CGFloat deltaX = self.scaleCenter.x-self.bounds.size.width/2.0;
        CGFloat deltaY = self.scaleCenter.y-self.bounds.size.height/2.0;
        
        CGAffineTransform transform =  CGAffineTransformTranslate(self.transform, deltaX, deltaY);
        transform = CGAffineTransformScale(transform, recognizer.scale, recognizer.scale);
        transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
        self.scale *= recognizer.scale;
        LOG(@"%f",self.scale);
        self.transform = transform;
        
        recognizer.scale = 1;
    }
}
- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer//旋转
{
    if([self handleGestureState:recognizer.state]) {
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.rotationCenter = self.touchCenter;
        }
        CGFloat deltaX = self.rotationCenter.x-self.bounds.size.width/2;
        CGFloat deltaY = self.rotationCenter.y-self.bounds.size.height/2;
        
        CGAffineTransform transform =  CGAffineTransformTranslate(self.transform,deltaX,deltaY);
        transform = CGAffineTransformRotate(transform, recognizer.rotation);
        transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
       // self.rotation *= recognizer.rotation;
        self.transform = transform;
        recognizer.rotation = 0;
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark Public methods
-(void)reset:(BOOL)animated
{
     [borderView setHidden:NO];
}
//test
#ifdef _FOR_DEBUG_
- (BOOL) respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector];
}
#endif
- (void)dealloc
{
    LOG(@"USerresizableView");
}
@end
