//
//  LZXToolPopoverControllerViewController.m
//  lexue
//
//  Created by songjie on 13-4-18.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXToolPopoverController.h"
#import "UIView+ZXQuartz.h"
@implementation LZXEraserPopoverController
@synthesize eraserPopover;
@synthesize sizeLable;
@synthesize erasersizeSlider;
@synthesize barButton;

- (void)setBarButton:(LZXToolButton *)_barButton
{
    barButton = _barButton;
    erasersizeSlider.minimumValue = 0.0;//下限
    erasersizeSlider.maximumValue = 60;//上限
    erasersizeSlider.value = barButton.fontSize;//初始大小为40
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 10.0;
    eraserPopover = [[UIPopoverController alloc] initWithContentViewController:self];
    CGSize contentSize = CGSizeMake(250, 70);
    eraserPopover.popoverContentSize = contentSize;
    
    UIView *eraserView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, contentSize.width, 80)];
    eraserView.backgroundColor = [UIColor redColor];
    //[self.view addSubview:eraserView];
    
    //creat sizeLable
//    sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, eraserView.frame.origin.y + eraserView.frame.size.height, 100, 25)];
    sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,5.0f, 100, 25)];
    sizeLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sizeLable];
    
    //eraserSlider
    erasersizeSlider = [[LZXCommandSlider alloc] init];
    [erasersizeSlider setFrame:CGRectMake(10.0f, sizeLable.frame.origin.y + sizeLable.frame.size.height, eraserView.frame.size.width - 10 * 2, 30.0f)];
    sizeLable.text = [NSString stringWithFormat:@"size: %.f px",erasersizeSlider.value];
    erasersizeSlider.continuous = YES ;
    [erasersizeSlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:erasersizeSlider];
    
}
#pragma mark -
#pragma mark Slider event handler
- (void) onCommandSliderValueChanged:(LZXCommandSlider *)_slider
{
    [_slider sendObject:_slider];  //改变橡皮大小
}
@end

@interface LZXToolPopoverController ()


@end

@implementation LZXToolPopoverController

@synthesize currentColor;
@synthesize toolPopover;
@synthesize sizeLable;
@synthesize opacitLable;
@synthesize barButton;
@synthesize colorPickerController;
@synthesize sizeSlider;
@synthesize opacitySlider;
@synthesize popoBtnArray;
@synthesize productView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    toolPopover = [[UIPopoverController alloc] initWithContentViewController:self];
    toolPopover.popoverContentSize = CGSizeMake(450, 320);
    
    //popo 的内容区
    productView = [[LZXProductView alloc] initWithFrame:CGRectMake(5, 5, 230, 80)];
    productView.layer.cornerRadius = 10;
    LOG(@"%@",productView);
    productView.layer.masksToBounds = YES;
    productView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:productView];

    UIView * toolView = [[UIView alloc] initWithFrame:CGRectMake(productView.frame.origin.x, productView.frame.origin.y + productView.frame.size.height + 8, productView.frame.size.width, 100)];
    toolView.layer.cornerRadius = 10;
    toolView.backgroundColor = [UIColor whiteColor];

    popoBtnArray = [NSMutableArray array];
    
    NSArray *imageNames = [NSArray arrayWithObjects:@"钢笔-ina@2x.png",@"笔-ina@2x.png",@"圆-ina@2x.png",@"框-ina@2x.png",@"线-ina@2x.png",@"字-ina@2x.png", nil];
    NSArray *imageNamesPressed = [NSArray arrayWithObjects:@"钢笔-a@2x.png",@"笔-a@2x.png",@"圆-a@2x.png",@"框-a@2x.png",@"线-a@2x.png",@"字-a@2x.png", nil];
    
    //
    LZXToolButton *toolBtn;
    for( LZXTooltype toolType = 0; toolType < 6; toolType++) {
        //橡皮 和 iamge 不初始化
        toolBtn = [LZXToolButton buttonWithType:UIButtonTypeCustom];
        toolBtn.backgroundColor = [UIColor clearColor];
        toolBtn.sizeLable.hidden = YES;
        toolBtn.toolType = toolType;
        [toolBtn addTarget:self action:@selector(toolViewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *btnImageNormal = [UIImage imageNamed:[imageNames objectAtIndex:toolType]];
        UIImage *btnImagepressed = [UIImage imageNamed:[imageNamesPressed objectAtIndex:toolType]];
        [toolBtn setImage:btnImageNormal forState:UIControlStateNormal];
        [toolBtn setImage:btnImagepressed forState:UIControlStateSelected];
        [toolView addSubview:toolBtn];
       // [toolBtn setTitle:[NSString stringWithFormat:@"%d",toolType] forState:UIControlStateNormal];
        [toolBtn setFrame:CGRectMake(10.0f + (toolView.frame.size.width/4 ) * (toolType % 4) - (toolType % 4), 5 + toolView.frame.size.height/2 * (toolType / 4), 38 , 38)];
        [popoBtnArray addObject:toolBtn];
    }
    
    //
    [self.view addSubview:toolView];
    
    UIView * toolSetView = [[UIView alloc] initWithFrame:CGRectMake(toolView.frame.origin.x, toolView.frame.origin.y + toolView.frame.size.height + 8, toolView.frame.size.width, 120)];
    toolSetView.layer.cornerRadius = 10;
    toolSetView.backgroundColor = [UIColor whiteColor];
    
    //slider
    sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 25)];
    sizeLable.backgroundColor = [UIColor clearColor];
    [toolSetView addSubview:sizeLable];
    sizeSlider = [[LZXCommandSlider alloc] init];
    [sizeSlider setFrame:CGRectMake(10.0f, 25, toolSetView.frame.size.width - 10 * 2, 30.0f)];
    sizeSlider.continuous = YES ;
    [sizeSlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [toolSetView addSubview:sizeSlider];
    
    opacitLable = [[UILabel alloc] initWithFrame:CGRectMake(10, sizeSlider.frame.origin.y + sizeSlider.frame.size.height + 5, 150, 25)];
    [toolSetView addSubview:opacitLable];
    opacitLable.backgroundColor = [UIColor clearColor];
    opacitySlider = [[LZXCommandSlider alloc] init];
    [opacitySlider setFrame:CGRectMake(10.0f, 80, toolSetView.frame.size.width - 10 * 2, 30.0f)];
   // opacitLable.text = [NSString stringWithFormat:@"opacity: %.f",opacitySlider.value];
    opacitySlider.continuous = YES ;
    [opacitySlider addTarget:self action:@selector(onCommandSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [toolSetView addSubview:opacitySlider];
    
    [self.view addSubview:toolSetView];
       
    colorPickerController = [[LZXColorPickerView alloc] init];
    colorPickerController.frame = CGRectMake(toolSetView.frame.size.width + 10, 0, 450-230 - 10, 320);
    [self.view addSubview:colorPickerController];
        colorPickerController.backgroundColor = [UIColor whiteColor];
    
    [colorPickerController receiveObject:^(id object) {
        //popocontroller 接受到这个对象后发送给 当前打开的按钮
        LOG(@"%@",barButton.titleLabel.text);
        barButton.savedColor = object;
        toolBtn.savedColor = barButton.savedColor;
        [self sendObject:barButton];//通过这个对象
        [productView setNeedsDisplay];
    }];

}
- (void)setSelectedColor:(UIColor *)color
{
    colorPickerController.selectedColor = color;
}
- (void)setBarButton:(LZXToolButton *)_barButton
{
    barButton = _barButton;
    
    sizeSlider.minimumValue = 0.0;//下限
    sizeSlider.maximumValue = 20;//上限
    sizeSlider.value = barButton.fontSize;//初始大小为40
    
    opacitySlider.minimumValue = 0.0;//下限
    opacitySlider.maximumValue = 100.0;//上限
    opacitySlider.value = barButton.spacingSize * 100;
    //绘图区
    productView.button = barButton;
    [productView setNeedsDisplay];
}
#pragma mark -
#pragma mark toolViewBtnPressed
- (void)toolViewBtnPressed:(LZXToolButton *)toolBtn
{
    //barButton.savedColor = colorPickerController.selectedColor;
    //toolBtn.selected = YES;
    [barButton sendObject:toolBtn];
    productView.button = barButton;
    [productView setNeedsDisplay];
}
#pragma mark -
#pragma mark Slider event handler
- (void) onCommandSliderValueChanged:(LZXCommandSlider *)_slider
{
    [_slider sendObject:_slider];  //改变popoView中slider中的标签
    [productView setNeedsDisplay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation LZXProductView
@synthesize button;
@synthesize size,opacity,color;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   if(self){
       //
   }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    replace(button.fontSize, button.spacingSize,button.savedColor);
    switch (button.toolType) {
        case LZXPen:
            [self drawCurveFrom:CGPointMake(30, 40) to:CGPointMake(rect.size.width - 30, 40) controlPoint1:CGPointMake(150, 0) controlPoint2:CGPointMake(50, 80)];
            break;
        case LZXfluorescencePen:
             [self drawCurveFrom:CGPointMake(30, 40) to:CGPointMake(rect.size.width - 30, 40) controlPoint1:CGPointMake(150, 0) controlPoint2:CGPointMake(50, 80)];
            break;
        case LZXRoundness:
            [self drawCircleWithCenter:CGPointMake(80, 10) radius:15];
            break;
        case LZXRectangle:
            [self drawRectangle:CGRectMake(80, 10, 60, 60)];
            break;
        case LZXLine:
            [self drawLineFrom:CGPointMake(30, 40) to:CGPointMake(rect.size.width - 30, 40)];
            break;
        case LZXTextVIew:
            [self drawText:rect];
            break;
        default:
            break;
    }
   
}
@end




