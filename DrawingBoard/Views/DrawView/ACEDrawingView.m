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

#import "ACEDrawingView.h"
#import "ACEDrawingTools.h"
//#import "LZXAirplayWindow.h"
#import <QuartzCore/QuartzCore.h>
#import "LZXCoordinatingController.h"
//#import "LZXSocketCommunicate.h"
#import "RDPObject.h"
//#import "LZXPlist.h"

#define  kScribbleDataPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data"]
#define SEAVERTAG  0
#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f
#define kDefaultLineAlpha       1.0f
#define kTextViewTag            60
#define kTooBarTag              80

// experimental code
#define PARTIAL_REDRAW          0

@interface ACEDrawingView ()<UIGestureRecognizerDelegate>
@end

//NSString * const SegChandeNotification = @"ChangeTheSelectedNotification";
#pragma mark -
@implementation ACEDrawingView
@synthesize text;
@synthesize dashOrline;
@synthesize array;
@synthesize infoView;
@synthesize drawTool;
@synthesize TextOrPen;
@synthesize currentTool;
@synthesize isRecording;
@synthesize rdpmakeTool;
//@synthesize rdpMake;
@synthesize assist;
@synthesize isSssistDraw;
@synthesize commentMeg;
@synthesize isTouch;
@synthesize formPush;

GZOBJECT_SINGLETON_BOILERPLATE(ACEDrawingView, sharedManager)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    // init the private arrays
    self.pathArray = [NSMutableArray array];
    self.beforPushArray = [NSMutableArray array];
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    ///
//    rdpMake = [[RDPObject alloc] init];
}
- (void)setrdpData:(RDPObject *)newData
{
//    if([[LZXPlist readUser] isEqualToString:teacher])
//    {}else
//    {
//        if ([commentMeg isEqualToString:@""]) {
//             self.rdpMake = newData;
//        }
//        else if ([commentMeg isEqualToString:@""]) {
//            newRdpMake = newData;
//        }
//    }
 //   [self setNeedsDisplay];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    [self.image drawInRect:self.bounds];
    if (self.isclear) {
        [self.currentTool setIsClear:_isclear];
    }
    /*
    if(USERTYPE == 1  && isSssistDraw == YES && isTouch == NO)
    {
        //用于远程协助
        _point(rdpMake.location);
        _point(rdpMake.endPoint);
        LOG(@"--%@--",self.currentTool);
        if (!isToClear) {
            if ([commentMeg isEqualToString:@""]) {
                if (rdpMake.drawTool) {
                    self.drawTool=rdpMake.drawTool;
                    self.currentTool = [self toolWithCurrentSettings];
                    [self.currentTool setLineAlpha:[rdpMake lineAlpha]];
                    [self.currentTool setLineColor:[rdpMake lineColor]];
                    [self.currentTool setLineWidth:[rdpMake lineWidth]];
                    [self.currentTool setInitialPoint:rdpMake.location];
                    [self.currentTool moveFromPoint:rdpMake.location toPoint:rdpMake.endPoint];
                    if (self.currentTool) {
                        [self.pathArray addObject:self.currentTool];
                        [self updateCacheImage:NO];
                        [self.currentTool  draw];
                    }
                }
                else
                {
                    self.drawTool=rdpMake.drawTool;
                    self.currentTool=rdpMake.mark;
                    if (rdpMake.isclear) {
                        [self.currentTool setIsClear:rdpMake.isclear];
                    }
                    [self.currentTool setLineAlpha:[rdpMake lineAlpha]];
                    [self.currentTool setLineColor:[rdpMake lineColor]];
                    [self.currentTool setLineWidth:[rdpMake lineWidth]];
                    [self.currentTool setInitialPoint:rdpMake.location];
                    if (self.currentTool) {
                        [self.pathArray addObject:self.currentTool];
                        [self updateCacheImage:NO];
                        [self.currentTool  draw];
                    }
                }
                return;
            }
            else if([commentMeg isEqualToString:@""])
            {
                if (newRdpMake) {
                    if (newRdpMake.drawTool) {
                        newRdpMake.mark=[self toolWithCurrentSettingsWithDrawTool:newRdpMake.drawTool];
                        [newRdpMake.mark moveFromPoint:newRdpMake.location toPoint:newRdpMake.endPoint];
                    }
                    else{
                        if (newRdpMake.isclear) {
                            [newRdpMake.mark setIsClear:newRdpMake.isclear];
                        }
                    }
                    [newRdpMake.mark setLineAlpha:[newRdpMake lineAlpha]];
                    [newRdpMake.mark setLineColor:[newRdpMake lineColor]];
                    [newRdpMake.mark setLineWidth:[newRdpMake lineWidth]];
                    [newRdpMake.mark setInitialPoint:newRdpMake.location];
                    [self.pathArray addObject:newRdpMake.mark];
                    [self updateCacheImageWith:newRdpMake.mark];
                    [newRdpMake.mark  draw];
                    newRdpMake=nil;
                }
            }
        }
    }
     */
    if(!isToCancel)
    {
        [self.currentTool draw];
    }
    if (isToClear) {
        isToClear=NO;
        isToCancel=NO;
        if (!self.currentTool) {
            self.currentTool= [self toolWithCurrentSettings];
        }
    }
#endif
    // [NSThread detachNewThreadSelector:@selector(updateairimage) toTarget:self withObject:nil];
}
- (void)exitCanvasViewEditor
{
    self.currentTool = [self toolWithCurrentSettings];
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        self.drawTool = ACEDrawingToolTypeMedia;
        self.currentTool = [self toolWithCurrentSettings];
        [self.pathArray addObject:self.currentTool];
    }];
    [self exitEditMode];
    [self setNeedsDisplay];
    LOG(@"%@",self.pathArray);
}
- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        LOG(@"%@",self.pathArray);
        for (id<Mark> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        LOG(@"%@",self.currentTool);
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // useded for airPlayWindow
//    LZXAirplayWindow *airwPlayWindow = [LZXAirplayWindow sharedInstance];
//    if(airwPlayWindow.contectionSwitch == YES){
//        [airwPlayWindow.ariPlayImageView setImage:self.image];
//        [airwPlayWindow.ariPlayImageView setNeedsDisplay];
//    }

    
}

-(void)updateCacheImageWith:(id<Mark>)newMark
{
     UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    // set the draw point
    [self.image drawAtPoint:CGPointZero];
    [newMark draw];
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (id<Mark>)toolWithCurrentSettings
{
    switch (self.drawTool) {
        case ACEDrawingToolTypePen:
        {
            ACEDrawingPenTool *tool=ACE_AUTORELEASE([ACEDrawingPenTool new]);
            return tool;
        }
        case ACEDrawingToolTypeMedia:
        {
            ACEDrawingMediaTool *tool=ACE_AUTORELEASE([ACEDrawingMediaTool new]);
            [tool receiveObject:^(id object) {
                self.array = object;
                LOG(@"后：%@",self.array);
                self.array = nil;
            }];
            tool.mediaArray = self.array;
            return tool;
        }
        case ACEDrawingToolTypeLine:
        {
            
            ACEDrawingLineTool *tool = ACE_AUTORELEASE([ACEDrawingLineTool new]);
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleStroke:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleFill:
        {
            //全矩形全部填充
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseStroke:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseFill:
        {
            //????
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = YES;
            return tool;
        }
    }
}


 
- (ACEDrawingView *)showCommentView:(NSString *)comment
{
    //添加手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SinglePan:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    
    infoView=[[UITextView alloc]initWithFrame:CGRectZero];
    
    infoView.backgroundColor=[UIColor clearColor];
    //不自动纠错
    [infoView setAutocorrectionType:UITextAutocorrectionTypeNo];
    infoView.delegate=self;
    //    增加边框
    [infoView.layer setBorderColor:[UIColor colorWithRed:166 green:166 blue:166 alpha:0.8].CGColor];
    [infoView.layer setCornerRadius:5.0];
    [infoView.layer setBorderWidth:2.0];
    [infoView.layer setMasksToBounds:NO];
    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    infoView.font=[UIFont fontWithName:@"Arial" size:20.0];
    infoView.textColor=self.lineColor;
    infoView.text = comment;
    [infoView addGestureRecognizer:panGestureRecognizer];
    [self addNote];
    if([infoView.text length]== 0){
        infoView.text = @"请输入批注内容：";
    }else
    {
        NSRange range = NSMakeRange (0, infoView.text.length);
        infoView.frame=CGRectMake(30, 50, 400, 580);
        if (infoView.contentSize.height<580) {
            infoView.frame=CGRectMake(30, 50, 400, infoView.contentSize.height);
        }
        [infoView.delegate textView:infoView shouldChangeTextInRange:range replacementText:infoView.text];
        [infoView.delegate textViewDidChange:infoView];

//        [infoView.delegate textView:infoView shouldChangeTextInRange:range replacementText:infoView.text];
//        [infoView.delegate textViewDidChange:infoView];
//        CGSize size = [infoView.text sizeWithFont: infoView.font constrainedToSize:CGSizeMake(400, 768 - 50 - 50 - 44 - 44) lineBreakMode:UILineBreakModeWordWrap];
//        infoView.frame = CGRectMake(30, 50, size.width, size.height);
//        _ps(size);
         _ps(infoView.frame.size);
    }
    self.text=@"";
    [infoView setTag:kTextViewTag];
    [self addSubview:infoView];
    
    if(self.array == nil){
        self.array = [NSMutableArray array];
    }
    [self.array addObject:infoView];
    self.drawTool = ACEDrawingToolTypeMedia;
    
    return self;
    
}
- (ACEDrawingView *)showImageView:(UIImage *)image
{
    //添加手势
    CGRect aFrame = CGRectMake(0, 0, image.size.width, image.size.height);
  // SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:aFrame];
     LZXUserResizableView *userResizableView = [[LZXUserResizableView alloc] initWithFrame:aFrame];
    userResizableView.delegate = self;
    UIImageView *graffitiView = [[UIImageView alloc] initWithImage:image];//涂鸦
    [graffitiView setUserInteractionEnabled:YES];
    [graffitiView setMultipleTouchEnabled:YES];
    graffitiView.backgroundColor = [UIColor clearColor];
    userResizableView.contentView = graffitiView;//    
    CGPoint center = CGPointMake((self.frame.origin.x + self.frame.size.width)/2,(self.frame.origin.y + self.frame.size.height)/2);
    [userResizableView setCenter:center];
    [self addSubview:userResizableView];
    [userResizableView setNeedsDisplay];
//    //tap
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SinglePan:)];
//    [gestureRecognizer setDelegate:self];
//    [userResizableView addGestureRecognizer:gestureRecognizer];
    
    if (self.array==nil) {
        self.array=[NSMutableArray array];
    }
    [array addObject:userResizableView];
    self.drawTool = ACEDrawingToolTypeMedia;
    //
    [self becomeFirstResponder];
    UIMenuItem *cencelItem = [[UIMenuItem alloc] initWithTitle:@"取消" action:@selector(cencel:)];
    UIMenuItem *doneItem = [[UIMenuItem alloc] initWithTitle:@"确定" action:@selector(done:)];
    [UIMenuController sharedMenuController].menuItems = @[doneItem, cencelItem,];
    
    return self;
    
}

#pragma mark - UIMenu
- (void)cencel:(id)sender
{
    //把涂鸦从array 中移除掉
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[LZXUserResizableView class]]){
            LZXUserResizableView *view = (LZXUserResizableView *)obj;
            [view removeFromSuperview];
            [self.array removeLastObject];
            [self exitCanvasViewEditor];
            *stop = YES;
        }
    }];
    //恢复类型设置
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    LZXDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
    [[[canvasViewController canvasBar] buttonArray] enumerateObjectsUsingBlock:^(LZXToolButton * toolsBtn, NSUInteger idx, BOOL *stop) {
        if([toolsBtn isSelected]){
            //匹配类型
            [[canvasViewController canvasBar] verifyTypeWithBtn:toolsBtn];
            *stop = YES;
        }
    }];
}

- (void)done:(id)sender
{
    [self exitCanvasViewEditor];
    LOG(@"%@",self.array);
   // [self restoration];//恢复类型
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cencel:) || action == @selector(done:))
        return YES;
    return [super canPerformAction:action withSender:sender];
}
#pragma mark - SPUserResizableViewDeleaget
- (void)userResizableViewDidBeginEditing:(LZXUserResizableView *)userResizableView
{
     [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
- (void)userResizableViewDidEndEditing:(LZXUserResizableView *)userResizableView
{
    _pr(userResizableView.frame);
    LOG(@"end");
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:[userResizableView frame] inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}
#pragma mark - SPUserResizableViewDeleagetEed
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)SinglePan:(UIPanGestureRecognizer*)recognizer
{
    UIView *panView = [recognizer view];
    [self adjustAnchorPointForGestureRecognizer:recognizer];
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:[panView superview]];
        
        [panView setCenter:CGPointMake([panView center].x + translation.x, [panView center].y + translation.y)];
        [recognizer setTranslation:CGPointZero inView:[panView superview]];
    }
}
#pragma mark - UIPanGestureRecognizer delegate

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
- (void)  exitEditMode
{
    /*
    if(assist == YES){
        if([[LZXPlist readUser] isEqualToString:teacher])
        {
            if ([commentMeg isEqualToString:REMOTEASSISTANCESTART]) {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               commentMeg, @"command",
                                               rdpMake, @"drawpath",nil];
                [LZXSocketCommunicate sendSocketMessage:params];
            }
        }
        else
        {
            if ([commentMeg isEqualToString:MANYPEOPLEINTERACTSTART]) {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               commentMeg, @"command",
                                               rdpMake, @"drawpath",nil];
                [LZXSocketCommunicate sendSocketMessage:params];
            }
        }
    }
     */
    // init the bezier path
    self.currentTool.lineAlpha = self.lineAlpha;
    // update the image
    [self updateCacheImage:NO];
    // clear the current tool
    self.currentTool = nil;
    // clear the redo queue
     [self setNeedsDisplay];
  
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
- (ACEDrawingToolType) restoration//恢复类型
{
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    LZXDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
    //如果当前画布中又 UItextView or UIImageView 的话给他设置为媒体类型。
    if(self.array == nil)
         return  [canvasViewController.canvasBar restoreCurrentToolType];
    else
         return ACEDrawingToolTypeMedia;
}
#pragma mark - Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // add the first touch
    UITouch *touch = [touches anyObject];
    if(isRecording&&self.isbox)
    {
        boxBeganPoint=[touch locationInView:self];
    }
    if([touch.view isKindOfClass:[self class]])
    {
        // init the bezier path
        LOG(@"%@",self.array);
//        if(!formPush){
//            self.drawTool = [self restoration];//恢复类型
//        }
        CGPoint point=[touch locationInView:self];
        self.currentTool = [self toolWithCurrentSettings];
        self.currentTool.lineWidth = self.lineWidth;
        self.currentTool.lineColor = self.lineColor;
        self.currentTool.lineAlpha = self.lineAlpha;
        if(self.drawTool == ACEDrawingToolTypeMedia && self.array == nil)
        {
            [self showCommentView:nil];
            UIView *textView=(UIView *)[self viewWithTag:kTextViewTag];
            textView.frame = CGRectMake(point.x, point.y, 400,  80);
            return;
        }
        [self.pathArray addObject:self.currentTool];
        // add the first touch
        UITouch *touch = [touches anyObject];
        [self.currentTool setInitialPoint:[touch locationInView:self]];
        /*
        rdpMake.location = point;
        if (!self.drawTool) {
            rdpMake.mark = self.currentTool;
        }
        rdpMake.lineColor = self.lineColor;
        rdpMake.lineAlpha = self.lineAlpha;
        rdpMake.lineWidth = self.lineWidth;
        rdpMake.drawTool = self.drawTool;
        rdpMake.isclear=self.isclear;
         */
    }
    isTouch = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
    //[self.currentTool setEndPoint:currentLocation];//远程用
    /*
    rdpMake.endPoint = currentLocation;
    if (!self.drawTool) {
        rdpMake.mark = self.currentTool;
    }
    rdpMake.lineColor = self.lineColor;
    rdpMake.lineAlpha = self.lineAlpha;
    rdpMake.lineWidth = self.lineWidth;
    rdpMake.drawTool = self.drawTool;
    rdpMake.isclear=self.isclear;
     */
    
    if(self.drawTool == ACEDrawingToolTypeMedia){
        [self setNeedsDisplay];
        return;
    }
    /* use for record
    if (isRecording&&(!self.isbox)) {
        CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 1.0;
        CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 1.0;
        CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 1.0;
        CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 1.0;
        [self setNeedsDisplayInRect:CGRectMake(lastPoint.x-2,lastPoint.y-2, (lastPoint2.x+4 - lastPoint.x), (lastPoint2.y+4-lastPoint.y))];
        lastPoint=CGPointMake(minX, minY);
        lastPoint2=CGPointMake(maxX, maxY);
        [self setNeedsDisplayInRect:CGRectMake(minX , minY, (maxX- minX), (maxY- minY))];
    }else if(isRecording&&self.isbox){
        CGFloat minX1 = fmin(boxBeganPoint.x, previousLocation.x) - self.lineWidth * 1.0;
        CGFloat minY1 = fmin(boxBeganPoint.y, previousLocation.y) - self.lineWidth * 1.0;
        CGFloat maxX1 = fmax(boxBeganPoint.x, previousLocation.x) + self.lineWidth * 1.0;
        CGFloat maxY1 = fmax(boxBeganPoint.y, previousLocation.y) + self.lineWidth * 1.0;
        [self setNeedsDisplayInRect:CGRectMake(minX1-2 , minY1-2, (maxX1+4- minX1), (maxY1+4- minY1))];
        CGFloat minX = fmin(boxBeganPoint.x, currentLocation.x) - self.lineWidth * 1.0;
        CGFloat minY = fmin(boxBeganPoint.y, currentLocation.y) - self.lineWidth * 1.0;
        CGFloat maxX = fmax(boxBeganPoint.x, currentLocation.x) + self.lineWidth * 1.0;
        CGFloat maxY = fmax(boxBeganPoint.y, currentLocation.y) + self.lineWidth * 1.0;
        [self setNeedsDisplayInRect:CGRectMake(minX-2 , minY-2, (maxX+4- minX), (maxY+4- minY))];
    } else{
        [self setNeedsDisplay];
    }*/
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    UITouch *touch = [touches anyObject];
    if([touch.view isKindOfClass:[self class]]){
        // make sure a point is recorded
//        [self touchesMoved:touches withEvent:event];
//        LOG(@"1类型：%@",self.pathArray);
        [self exitEditMode];
        isTouch = NO;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}
#pragma -textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //   开始编辑 自动去掉提示语
    if ([textView.text isEqualToString:@"请输入批注内容："]) {
        textView.text=@"";
    }
    self.text=textView.text;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.text=textView.text;
    NSString *desContent=textView.text;
    //获取原始UITextView的frame
    CGRect orgRect=textView.frame;
    CGSize  mysize = [desContent sizeWithFont:[UIFont fontWithName:@"Arial" size:20.0] constrainedToSize:CGSizeMake(400, 768 - 50 - 50 - 44 - 44) lineBreakMode:UILineBreakModeWordWrap];
    //获取自适应文本内容高度
    if (mysize.height < 20) {
        mysize.height = 25;
    }
    orgRect.size.height=mysize.height+55;
    //重设UITextView的frame
    textView.frame=orgRect;
    //  如果是首次编辑下层的视图也改变高度(编辑一次后，父视图已经变为drawView)
    //    if (textView.superview.tag==90) {
    //        textView.superview.frame=CGRectMake(textView.superview.frame.origin.x,textView.superview.frame.origin.y,textView.superview.frame.size.width, orgRect.size.height+100);
    //    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)str
{
   /* NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:str];
    
    if([toBeString length] > 300)
    {
        return NO;
        //textView.text = [toBeString substringToIndex:300];
    }*/
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
}

#pragma mark - Actions
-(void)addNote
{
    TextOrPen=YES;
}
-(void)stopAddNote
{
    TextOrPen=NO;
}
- (void)clear
{
    isToClear=YES;
    self.array = nil;
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    // 将添加的批注也清空
    for (UITextView *textView in self.subviews) {
        [textView removeFromSuperview];
    }
    for (UIImageView *imageView in self.subviews) {
        [imageView removeFromSuperview];
    }
    self.currentTool = nil;
    [self setNeedsDisplay];
}
#pragma mark - Undo / Redo
- (void)undoLatestStep
{
    if([self.pathArray count] != 0)
    {
        id<Mark>tool = [self.pathArray lastObject];
        if ([self.pathArray containsObject:tool])
        {
            [self.pathArray removeObject:tool];
            [self.beforPushArray addObject:tool];
            [self updateCacheImage:YES];
            [self setNeedsDisplay];
        }
    }
}
- (void)rodoLatestStep
{
    if([self.beforPushArray count] != 0)
    {
        id<Mark>tool = [self.beforPushArray lastObject];
        [self.pathArray addObject:tool];
        [self.beforPushArray removeObject:tool];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}


#if !ACE_HAS_ARC
- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    [super dealloc];
}
#endif

@end
