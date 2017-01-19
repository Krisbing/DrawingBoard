/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ACEDrawingTools.h"
#import "ACEDrawingView.h"
#import "UIImage-Extensions.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - ACEDrawingPenTool 画笔

@implementation ACEDrawingPenTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize isClear = _isClear;
@synthesize location = _location;
@synthesize endPoint = _endPoint;
- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}
- (void)draw
{
    if (_isClear) {
        [self strokeWithBlendMode:kCGBlendModeClear alpha:0];
        //[self setLineColor:[UIColor redColor]];
    }else{
        [self.lineColor setStroke];
        [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
    }
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - ACEDrawingLineTool 画线

@interface ACEDrawingLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingLineTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize location = _location;
@synthesize endPoint = _endPoint;
@synthesize isClear   = _isClear;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end
#pragma mark - ACEDrawingTextTool 画Text工具

@interface ACEDrawingMediaTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingMediaTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize isClear   = _isClear;
@synthesize location = _location;
@synthesize endPoint = _endPoint;
@synthesize mediaArray;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    LOG(@"draw:%@",mediaArray);
    [mediaArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[UITextView class]])
        {
            UITextView *textView = (UITextView *)obj;
            if ([textView.text isEqualToString:@"请输入批注内容："]) {
                textView.text = nil;
            }
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            CGContextSetFillColorWithColor(context, textView.textColor.CGColor);
            [textView.text drawInRect:CGRectMake(textView.frame.origin.x,textView.frame.origin.y, textView.frame.size.width,textView.frame.size.height) withFont:textView.font];
            CGContextStrokePath(context);
            CGContextFillPath(context);
            
            [textView removeFromSuperview];
            //
            [self sendObject:mediaArray];
            
        }
        if([obj isKindOfClass:[LZXUserResizableView class]])
        {
            LZXUserResizableView *imageView = (LZXUserResizableView *)obj;
            [imageView setNeedsDisplay];
            UIImageView *graffitiView = (UIImageView *)imageView.contentView;
            CGFloat zoomScale = imageView.scale;//[[imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
            CGFloat rotate = [[imageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
            CGFloat _imageScale = imageView.contentView.frame.size.width /graffitiView.image.size.width;
            CGSize _originalImageViewSize =  CGSizeMake(graffitiView.image.size.width*_imageScale, graffitiView.image.size.height*_imageScale);
            CGFloat new_imageScale = graffitiView.image.size.width/_originalImageViewSize.width;
            CGSize cropSize = CGSizeMake(imageView.frame.size.width/imageView.scale, imageView.frame.size.height/imageView.scale);
            CGPoint cropperViewOrigin = CGPointMake((0.0 - imageView.contentView.frame.origin.x)/zoomScale,
                                                    (0.0 - imageView.contentView.frame.origin.y)/zoomScale);
            if((NSInteger)cropSize.width % 2 == 1)
            {
                cropSize.width = ceil(cropSize.width);
            }
            if((NSInteger)cropSize.height % 2 == 1)
            {
                cropSize.height = ceil(cropSize.height);
            }
            
            CGRect CropRectinImage = CGRectMake((CGFloat)(cropperViewOrigin.x*new_imageScale)/2.0 ,(CGFloat)( cropperViewOrigin.y*new_imageScale)/2.0, (CGFloat)(cropSize.width*new_imageScale),(CGFloat)(cropSize.height*new_imageScale));
            
            UIImage *rotInputImage = [graffitiView.image imageRotatedByRadians:rotate];
            CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);
            UIImage *croppedImage = [UIImage imageWithCGImage:tmp scale:1.0 orientation:UIImageOrientationUp];
            CGImageRelease(tmp);
            [croppedImage drawInRect:imageView.frame];
            [imageView removeFromSuperview];
            [self sendObject:mediaArray];
           
            //*stop = YES;
        }
    }];
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - ACEDrawingRectangleTool  画矩形

@interface ACEDrawingRectangleTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingRectangleTool
@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize location = _location;
@synthesize endPoint = _endPoint;
@synthesize isClear   = _isClear;
//@synthesize array;
- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the rectangle
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - ACEDrawingEllipseTool 画椭圆

@interface ACEDrawingEllipseTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingEllipseTool
@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize location = _location;
@synthesize endPoint = _endPoint;
@synthesize isClear   = _isClear;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the ellipse
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end
