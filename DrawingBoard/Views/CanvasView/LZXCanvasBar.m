//
//  LZXCanvasBar.m
//  lexue
//
//  Created by songjie on 13-4-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXCanvasBar.h"
#import "LZXObject.h"
#import "PathCommand.h"
#import "LZXCoordinatingController.h"
#import "DeleteScribbleCommand.h"
#import "ChangeBackgroundImageCommand.h"

#define LZXToolViewleftMargin vgView.frame.origin.x

@implementation LZXCanvasBar
@synthesize buttonArray;
@synthesize canvasView;
@synthesize browserTabView;
@synthesize redoBtn,undoBtn,changeBtn;
//@synthesize assistPopoverController;
@synthesize assistActionSheet;
@synthesize assistBtn;


- (ACEDrawingToolType)restoreCurrentToolType
{
    __block ACEDrawingToolType drawTool;
    [buttonArray enumerateObjectsUsingBlock:^(LZXToolButton * toolsBtn, NSUInteger idx, BOOL *stop) {
        if([toolsBtn isSelected]){
            //匹配类型
            switch (toolsBtn.toolType) {
                case LZXPen:
                    drawTool = ACEDrawingToolTypePen;
                    break;
                case LZXfluorescencePen:
                    drawTool = ACEDrawingToolTypePen;
                    break;
                case LZXRoundness:
                    drawTool = ACEDrawingToolTypeEllipseStroke;
                    break;
                case LZXRectangle:
                    drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                case LZXLine:
                    drawTool = ACEDrawingToolTypeLine;
                    break;
                case LZXScrawlImage:
                    drawTool = ACEDrawingToolTypeMedia;
                    break;
                case LZXTextVIew:
                    drawTool = ACEDrawingToolTypeMedia;
                    break;
                case LZXEraser:
                    drawTool = ACEDrawingToolTypePen;
                    break;
                    
                default:
                    break;
            }
            *stop = YES;
        }
    }];
    return drawTool;
}
- (void)verifyTypeWithBtn:(LZXToolButton *)barBtn
{
    [buttonArray enumerateObjectsUsingBlock:^(LZXToolButton * toolsBtn, NSUInteger idx, BOOL *stop) {
        if(barBtn == toolsBtn)
            barBtn.selected = YES;
        else
            toolsBtn.selected = NO;
    }];//实现工具栏单选
    [toolPopoverController.popoBtnArray enumerateObjectsUsingBlock:^(LZXToolButton * popoToolBtn, NSUInteger idx, BOOL *stop) {
        if(popoToolBtn.toolType == barBtn.toolType)
            popoToolBtn.selected = YES;
        else
            popoToolBtn.selected = NO;
    }];
    canvasView.isclear = NO;
    [canvasView stopAddNote];
    self.penColor = barBtn.savedColor;
    canvasView.lineWidth = barBtn.fontSize;//线的宽度
    canvasView.lineAlpha = barBtn.spacingSize;//线的透明度
    canvasView.lineColor = barBtn.savedColor;
    //绘制画板当前view
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    LZXDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
    //    LOG(@"%@",canvasView.array);
    //    LOG(@"%@",[[[canvasViewController doodleview] drawView] array]);
    //
    //退出编辑（切换的时候把上一次的东西都画上去 eg：批准 和 其他切换）
    [[[canvasViewController doodleview] drawView] exitCanvasViewEditor];
    // [canvasView exitCanvasViewEditor];
    switch (barBtn.toolType) {
        case LZXPen:
            //
            LOG(@"pen");
            canvasView.drawTool = ACEDrawingToolTypePen;
            canvasView.isbox=NO;
            break;
        case LZXfluorescencePen:
            LOG(@"LZXfluorescencePen");
            canvasView.drawTool = ACEDrawingToolTypePen;
            canvasView.isbox=NO;
            //
            break;
        case LZXRoundness:
            //
            LOG(@"LZXRoundness");
            canvasView.drawTool = ACEDrawingToolTypeEllipseStroke;
            canvasView.isbox=YES;
            break;
        case LZXRectangle:
            //
            LOG(@"LZXRectangle");
            canvasView.drawTool = ACEDrawingToolTypeRectagleStroke;
            canvasView.isbox=YES;
            break;
        case LZXLine:
            LOG(@"LZXLine");
            canvasView.drawTool = ACEDrawingToolTypeLine;
            canvasView.isbox=YES;
            canvasView.dashOrline=NO;
            //
            break;
        case LZXScrawlImage:
            LOG(@"LZXScrawlImage");
            canvasView.drawTool = ACEDrawingToolTypeMedia;
            canvasView.isbox=NO;
            //
            break;
        case LZXTextVIew:
            LOG(@"LZXTextVIew");
            canvasView.drawTool = ACEDrawingToolTypeMedia;
            [canvasView addNote];
            canvasView.isbox=NO;
            //
            break;
        case LZXEraser:
            LOG(@"LZXEraser");
            canvasView.drawTool = ACEDrawingToolTypePen;
            canvasView.isclear = YES;
            canvasView.isbox=NO;
            break;
            
        default:
            break;
    }
    //通知 tap 保存状态
    [browserTabView sendObject:canvasView];
}
/*
 popoview 中的小按钮点击事件，目的是改变工具栏按钮的状态
 */
//- (void)toolViewBtnPressed:(LZXToolButton *)toolBtn
//{
//    [toolPopoverController.barButton sendObject:toolBtn];
//}
/*
 更新视图. 显示 popoView。 改变 按钮上字号的大小显示 以及type
 */

- (void)replaceDisplayWith:(LZXToolButton *)toolButton change:(LZXToolButton *)Barbtn
{
    LOG(@"%@",toolButton);
    LOG(@"%@",Barbtn.titleLabel.text);
    
    if(toolButton == Barbtn){
        [self showToolPopoverWithObj:toolButton];
    }
    else
    {
        //在popoView 区域中 切换 不同的按钮  tools 上面的 按钮 随之 做出相应的变化
        [toolPopoverController.popoBtnArray enumerateObjectsUsingBlock:^(id popopBtn, NSUInteger idx, BOOL *stop) {
            LZXToolButton *button = (LZXToolButton *)popopBtn;
            if(button == toolButton)
            {
                button.selected = YES;
                UIImage *imageNormal = [button imageForState:UIControlStateSelected];
                UIImage *imageSeled = [button imageForState:UIControlStateNormal];
                //
                [Barbtn setImage:imageSeled forState:UIControlStateNormal];
                [Barbtn setImage:imageNormal forState:UIControlStateSelected];
            }else
            {
                button.selected = NO;
            }
            
        }];
        
        Barbtn.toolType = toolButton.toolType;
        
        [self verifyTypeWithBtn:Barbtn];
    }
}

- (void) showToolPopoverWithObj:(LZXToolButton *)button
{
    
    CGRect frame = CGRectMake(button.frame.origin.x + LZXToolViewleftMargin, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
    if(button.toolType == LZXEraser)
    {
        eraserPopoverController.sizeLable.text = [NSString stringWithFormat:@"size: %.f px",button.fontSize];//
        [eraserPopoverController setBarButton:button];
        [eraserPopoverController.eraserPopover presentPopoverFromRect:frame inView:[self superview] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
        toolPopoverController.sizeLable.text = [NSString stringWithFormat:@"size: %.f px",button.fontSize];//
        toolPopoverController.opacitLable.text = [NSString stringWithFormat:@"opacity: %.2f px",button.spacingSize];//
        [toolPopoverController setBarButton:button];
        [toolPopoverController.colorPickerController updateSelectedColor:button.savedColor];
        [toolPopoverController.toolPopover presentPopoverFromRect:frame inView:[self superview] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        buttonArray = [NSMutableArray array];
        self.contentMode = UIViewContentModeScaleToFill;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        UIImage *imagebg = [UIImage imageNamed:@"dooletop_bg@2x.png"];
        
        if(IOS_VERSION >= 5.0){
            //[imagebg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }else{
            [imagebg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        }
        self.layer.contents = (id)imagebg.CGImage;
        
        toolPopoverController = [[LZXToolPopoverController alloc] init];
        toolPopoverController.view.frame = CGRectMake(0, 0,
                                                      450,
                                                      320);
        
        eraserPopoverController = [[LZXEraserPopoverController alloc] init];
        eraserPopoverController.view.frame = CGRectMake(0, 0,
                                                        250,
                                                        150);
        //picker active
        [toolPopoverController receiveObject:^(LZXToolButton *  barButton) {
            [self verifyTypeWithBtn:barButton];//确定画板工具类型
            LOG(@"选择的按钮%@",barButton.titleLabel.text);
        }];
        //sizeSlider active
        [toolPopoverController.sizeSlider receiveObject:^(id object) {
            LZXCommandSlider *slider = (LZXCommandSlider *)object;
            toolPopoverController.barButton.fontSize = slider.value;
            canvasView.lineColor = toolPopoverController.barButton.savedColor;
            canvasView.lineWidth = toolPopoverController.barButton.fontSize ;
            canvasView.infoView.font = [UIFont fontWithName:@"Arial" size:toolPopoverController.barButton.fontSize];//
            toolPopoverController.sizeLable.text = [NSString stringWithFormat:@"size: %.f px",slider.value];
            toolPopoverController.barButton.sizeLable.text = [NSString stringWithFormat:@"%.f",slider.value];
            //通知 tap 保存状态
            [browserTabView sendObject:canvasView];
            
        }];
        //opacitySlider active
        [toolPopoverController.opacitySlider receiveObject:^(id object) {
            LZXCommandSlider *slider = (LZXCommandSlider *)object;
            toolPopoverController.barButton.spacingSize = slider.value / 100;
            canvasView.lineAlpha = toolPopoverController.barButton.spacingSize;// / 100;
            toolPopoverController.opacitLable.text = [NSString stringWithFormat:@"opacity: %.2f px",slider.value/100];
            canvasView.infoView.textColor = [toolPopoverController.barButton.savedColor colorWithAlphaComponent:toolPopoverController.barButton.spacingSize];//text的透明度
            //通知 tap 保存状态
            [browserTabView sendObject:canvasView];
            
            
        }];
        //橡皮 slider
        [eraserPopoverController.erasersizeSlider receiveObject:^(id object) {
            LZXCommandSlider *slider = (LZXCommandSlider *)object;
            eraserPopoverController.barButton.fontSize = slider.value;
            canvasView.isclear = YES;
            canvasView.lineWidth = slider.value;
            canvasView.lineColor = toolPopoverController.barButton.savedColor;
            canvasView.lineAlpha = toolPopoverController.barButton.spacingSize;
            eraserPopoverController.sizeLable.text = [NSString stringWithFormat:@"size: %.f px",slider.value];
        }];
        
        vgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 295, 40)];
        CGPoint vgViewCenter = CGPointMake((self.frame.origin.x + self.frame.size.width)/2,(self.frame.origin.y + self.frame.size.height)/2);
        [vgView setCenter:vgViewCenter];
        vgView.backgroundColor = [UIColor clearColor];
        vgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f].CGColor;
        vgView.layer.cornerRadius = 5.0;
        [self addSubview:vgView];
        //初始化工具栏上面的额按钮
        __block LZXToolButton *penButton = [[LZXToolButton alloc] init];
        penButton.toolType = LZXPen;
       // [penButton setTag:LZXPen];
        [penButton setTitle:@"Pen" forState:UIControlStateNormal];
        penButton.frame=CGRectMake(2, 2, 38, 38);
        penButton.fontSize = 3.0;
        penButton.spacingSize = 1;
        penButton.savedColor = [UIColor yellowColor];
        penButton.sizeLable.text = [NSString stringWithFormat:@"%.f",penButton.fontSize];
        UIImage *penButtonImageNormal = [UIImage imageNamed:@"钢笔-ina@2x.png"];
        UIImage *penButtonImagepressed = [UIImage imageNamed:@"钢笔-a@2x.png"];
        [penButton setImage:penButtonImageNormal forState:UIControlStateNormal];
        [penButton setImage:penButtonImagepressed forState:UIControlStateSelected];
        [penButton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:penButton];
        }];
        [penButton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:penButton];
        penButton.selected = YES;
        [vgView addSubview:penButton];
        
        __block LZXToolButton *fluorescencePenButton = [[LZXToolButton alloc] init];
        fluorescencePenButton.toolType = LZXfluorescencePen;
        //[fluorescencePenButton setTag:LZXfluorescencePen];
        fluorescencePenButton.savedColor = [UIColor yellowColor];
        [fluorescencePenButton setTitle:@"flu" forState:UIControlStateNormal];
        fluorescencePenButton.frame=CGRectMake(penButton.frame.size.width + penButton.frame.origin.x + kBtnMargin, 2, 38, 38);
        fluorescencePenButton.fontSize = 18.0;
        fluorescencePenButton.spacingSize = 0.3;
        fluorescencePenButton.sizeLable.text = [NSString stringWithFormat:@"%.f",fluorescencePenButton.fontSize];
        UIImage *fluorescencePenButtonImageNormal = [UIImage imageNamed:@"笔-ina@2x.png"];
        UIImage *fluorescencePenButtonImagepressed = [UIImage imageNamed:@"笔-a@2x.png"];
        [fluorescencePenButton setImage:fluorescencePenButtonImageNormal forState:UIControlStateNormal];
        [fluorescencePenButton setImage:fluorescencePenButtonImagepressed forState:UIControlStateSelected];
        [fluorescencePenButton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:fluorescencePenButton];
        }];
        [fluorescencePenButton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:fluorescencePenButton];
        [vgView addSubview:fluorescencePenButton];
        
        __block LZXToolButton *roundnessBotton = [[LZXToolButton alloc] init];
        roundnessBotton.toolType = LZXRoundness;
        roundnessBotton.fontSize = 3;
        roundnessBotton.spacingSize = 1;
        roundnessBotton.savedColor = [UIColor yellowColor];
        [roundnessBotton setTitle:@"圆" forState:UIControlStateNormal];
        roundnessBotton.sizeLable.text = [NSString stringWithFormat:@"%.f",roundnessBotton.fontSize];
        roundnessBotton.frame=CGRectMake(fluorescencePenButton.frame.size.width + fluorescencePenButton.frame.origin.x + kBtnMargin, 2, 38, 38);
        UIImage *roundnessBottonImageNormal = [UIImage imageNamed:@"圆-ina@2x.png"];
        UIImage *roundnessBottonImagepressed = [UIImage imageNamed:@"圆-a@2x.png"];
        [roundnessBotton setImage:roundnessBottonImageNormal forState:UIControlStateNormal];
        [roundnessBotton setImage:roundnessBottonImagepressed forState:UIControlStateSelected];
        [roundnessBotton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:roundnessBotton];
        }];
        [roundnessBotton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:roundnessBotton];
        [vgView addSubview:roundnessBotton];
        
        __block LZXToolButton *rectangleButton = [[LZXToolButton alloc] init];
        rectangleButton.toolType = LZXRectangle;
        rectangleButton.fontSize = 3;
        rectangleButton.spacingSize = 1;
        rectangleButton.savedColor = [UIColor yellowColor];
        [rectangleButton setTitle:@"Rect" forState:UIControlStateNormal];
        rectangleButton.sizeLable.text = [NSString stringWithFormat:@"%.f",rectangleButton.fontSize];
        rectangleButton.frame=CGRectMake(roundnessBotton.frame.size.width + roundnessBotton.frame.origin.x + kBtnMargin, 2, 38, 38);
        UIImage *rectangleButtonImageNormal = [UIImage imageNamed:@"框-ina@2x.png"];
        UIImage *rectangleButtonImagepressed = [UIImage imageNamed:@"框-a@2x.png"];
        [rectangleButton setImage:rectangleButtonImageNormal forState:UIControlStateNormal];
        [rectangleButton setImage:rectangleButtonImagepressed forState:UIControlStateSelected];
        [rectangleButton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:rectangleButton];
        }];
        [rectangleButton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:rectangleButton];
        [vgView addSubview:rectangleButton];
        
        __block LZXToolButton *lineButton = [[LZXToolButton alloc] init];
        lineButton.toolType = LZXLine;
        lineButton.fontSize = 3;
        lineButton.spacingSize = 1;
        lineButton.savedColor = [UIColor yellowColor];
        [lineButton setTitle:@"line" forState:UIControlStateNormal];
        lineButton.sizeLable.text = [NSString stringWithFormat:@"%.f",lineButton.fontSize];
        lineButton.frame=CGRectMake(rectangleButton.frame.size.width + rectangleButton.frame.origin.x + kBtnMargin, 2, 38, 38);
        UIImage *lineButtonImageNormal = [UIImage imageNamed:@"线-ina@2x.png"];
        UIImage *lineButtonImagepressed = [UIImage imageNamed:@"线-a@2x.png"];
        [lineButton setImage:lineButtonImageNormal forState:UIControlStateNormal];
        [lineButton setImage:lineButtonImagepressed forState:UIControlStateSelected];
        [lineButton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:lineButton];
        }];
        [lineButton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:lineButton];
        [vgView addSubview:lineButton];
        
        __block LZXToolButton *noteButton = [[LZXToolButton alloc] init];
        noteButton.toolType = LZXTextVIew;
        //[noteButton setTag:LZXTextVIew];
        noteButton.fontSize = 18;
        noteButton.spacingSize = 1;
        noteButton.savedColor = [UIColor yellowColor];
        [noteButton setTitle:@"note" forState:UIControlStateNormal];
        noteButton.sizeLable.text = [NSString stringWithFormat:@"%.f",noteButton.fontSize];
        noteButton.frame=CGRectMake(lineButton.frame.size.width + lineButton.frame.origin.x + kBtnMargin, 2, 38, 38);
        UIImage *noteButtonImageNormal = [UIImage imageNamed:@"字-ina@2x.png"];
        UIImage *lnoteButtonImagepressed = [UIImage imageNamed:@"字-a@2x.png"];
        [noteButton setImage:noteButtonImageNormal forState:UIControlStateNormal];
        [noteButton setImage:lnoteButtonImagepressed forState:UIControlStateSelected];
        [noteButton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:noteButton];
        }];
        [noteButton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:noteButton];
        [vgView addSubview:noteButton];
        
        __block LZXToolButton *eraserButton = [[LZXToolButton alloc] init];
        eraserButton.toolType = LZXEraser;
        eraserButton.fontSize = 20.0;
        eraserButton.savedColor = [UIColor clearColor];
        [eraserButton.sizeLable setHidden:YES];
        [eraserButton setTitle:@"er" forState:UIControlStateNormal];
        eraserButton.frame=CGRectMake(noteButton.frame.size.width + noteButton.frame.origin.x + kBtnMargin, 2, 38, 38);
        [eraserButton addTarget:self action:@selector(verifyTypeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *eraserButtonImageNormal = [UIImage imageNamed:@"橡皮-ina@2x.png"];
        UIImage *eraserButtonImagepressed = [UIImage imageNamed:@"橡皮-a@2x.png"];
        [eraserButton setImage:eraserButtonImageNormal forState:UIControlStateNormal];
        [eraserButton setImage:eraserButtonImagepressed forState:UIControlStateSelected];
        [eraserButton receiveObject:^(id object) {
            [self replaceDisplayWith:object change:eraserButton];
        }];
        
        [buttonArray addObject:eraserButton];
        [vgView addSubview:eraserButton];
        
        //录制
        UIImage * recordImage = [UIImage imageNamed:@"录制bg.png"];
        UIImage *thumbNarmal = [UIImage imageNamed:@"录制-ina.png"];
        UIImage *thumbPressed = [UIImage imageNamed:@"录制-a.png"];
        recordBtn = [LZXCommandBtn buttonWithType:UIButtonTypeCustom];
        [recordBtn setBackgroundImage:recordImage forState:UIControlStateNormal];
        [recordBtn setBackgroundImage:recordImage forState:UIControlStateHighlighted];
        [recordBtn setImage:thumbNarmal forState:UIControlStateNormal];
        [recordBtn setImage:thumbPressed forState:UIControlStateSelected];
        [recordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];//水平对齐
        [recordBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [recordBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        recordBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        [recordBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //recordBtn.showsTouchWhenHighlighted = YES;
        [recordBtn setTitle:@"录制" forState:UIControlStateNormal];
        recordBtn.frame = CGRectMake(vgView.frame.origin.x - recordImage.size.width - 20, 10, recordImage.size.width, recordImage.size.height);
        //recordBtn.command = [[RecordingCommand alloc] init];
        [self addSubview:recordBtn];
        
        //切换背景
        UIImage *backgroundImage = [UIImage imageNamed:@"切换背景.png"];
        changeBtn = [LZXCommandBtn buttonWithType:UIButtonTypeCustom];
        [changeBtn setImage:backgroundImage forState:UIControlStateNormal];
        [changeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        changeBtn.showsTouchWhenHighlighted = YES;
        [changeBtn setTitle:@"切换背景" forState:UIControlStateNormal];
        changeBtn.frame = CGRectMake(vgView.frame.origin.x + vgView.frame.size.width + 80, 10, backgroundImage.size.width, backgroundImage.size.height);
        changeBtn.command = [[ChangeBackgroundImageCommand alloc] init];
        [self addSubview:changeBtn];
        
        //撤销
        undoBtn = [LZXCommandBtn buttonWithType:UIButtonTypeCustom];
        UIImage *dundoBtnBtnImageNormal = [UIImage imageNamed:@"撤消.png"];
        [undoBtn setImage:dundoBtnBtnImageNormal forState:UIControlStateNormal];
        [undoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
        undoBtn.showsTouchWhenHighlighted = YES;
        undoBtn.frame = CGRectMake(recordBtn.frame.origin.x - dundoBtnBtnImageNormal.size.width - 20 , 10, dundoBtnBtnImageNormal.size.width,  dundoBtnBtnImageNormal.size.height);
        undoBtn.command = [[UndoCommand alloc] init];
        [self addSubview:undoBtn];
        //删除
        deleateBtn = [LZXCommandBtn buttonWithType:UIButtonTypeCustom];
        UIImage *deleateBtnImageNormal = [UIImage imageNamed:@"删除.png"];
        [deleateBtn setImage:deleateBtnImageNormal forState:UIControlStateNormal];
        [deleateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        deleateBtn.showsTouchWhenHighlighted = YES;
        [deleateBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleateBtn.frame = CGRectMake(undoBtn.frame.origin.x - 20 - deleateBtnImageNormal.size.width, 10, deleateBtnImageNormal.size.width, deleateBtnImageNormal.size.height);
         deleateBtn.command = [[DeleteScribbleCommand alloc] init];
        [self addSubview:deleateBtn];
        
    }
    return self;
}
- (void)initFeedbackBtn{
    //
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

#pragma mark -
#pragma mark - acr
- (void)buttonClick:(UIButton *)sender{
    [self sendObject:sender];
}
@end
