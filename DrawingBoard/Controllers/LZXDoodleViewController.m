//
//  LZXDoodleViewController.m
//  lexue
//
//  Created by admin on 12-8-12.
//  Copyright (c) 2012年 lezhixing. All rights reserved.
//

#import "LZXDoodleViewController.h"
#import "LZXCoordinatingController.h"


@interface LZXDoodleViewController ()
{
    UILabel *currentLable ;
    UILabel *totalLable;
}
@end

@implementation LZXDoodleViewController
@synthesize customBtn;
@synthesize backgroundImage;
@synthesize doodleview;
@synthesize popover;
@synthesize canvasBar;
@synthesize addButton;
@synthesize tabController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadCanvasBarWithGenerator:[[StudentCanvasBarGenerator alloc] init]];//学生
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // self.actionBarController.bar.turnWhiteBoardBtn.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    //self.actionBarController.bar.turnWhiteBoardBtn.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
}


#pragma mark -
#pragma mark Loading a CanvasView from a CanvasViewGenerator

- (void) loadCanvasBarWithGenerator:(LZXCanvasViewGenerator *)generator
{
    CGRect aFrame = CGRectMake(0, 0, kMainScreenWidth, kLZXCanvasBarHight);
    //初始化工具条
    canvasBar = [generator canvasBarWithFrame:aFrame];
    [canvasBar receiveObject:^(id object) {
        if ([object isKindOfClass:[UIButton class]]){
            self.customBtn = object;
            [[LZXCoordinatingController sharedInstance] setCanvasViewController:self];
            [[customBtn command] execute];
        }
       
    }];
    [self setCanvasBar:canvasBar];
    //creat doodleview
    tabController = [[LZXBrowserTabView alloc] initWithFrame:CGRectMake(0, kLZXCanvasBarHight - kLZXTabBarHigh, kMainScreenWidth, kLZXTabBarHigh)];
    [tabController  initWithTabTitles:[NSArray arrayWithObjects:@"板书 1", nil] andDelegate:self];
    tabController.delegate = self;
    //初始化dooleView
    self.doodleview = [tabController.drawArrays objectAtIndex:0];
    [tabController setSavedAceView:self.doodleview.drawView];
    [canvasBar setBrowserTabView:tabController];
    [canvasBar setCanvasView:doodleview.drawView];
    //creat add button
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton setImage:[UIImage imageNamed:@"tab_new_add.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(tabController.frame.size.width - 32, 1, 30 , 30);
    [tabController addSubview:addButton];
    [self.view addSubview:self.doodleview];
    [self.view addSubview:tabController];
    [self.view addSubview:canvasBar];
    
    //添加tap 按钮
    UIImage *dropDownIcon = [UIImage imageNamed:@"下拉.png"];
    UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [expandButton setImage:dropDownIcon forState:UIControlStateNormal];
    [expandButton addTarget:self action:@selector(openTapView:) forControlEvents:UIControlEventTouchUpInside];
    [expandButton setTitle:@"显示" forState:UIControlStateNormal];
    [expandButton setFrame:CGRectMake(0, canvasBar.frame.size.height, dropDownIcon.size.width, dropDownIcon.size.height)];
    CGPoint viewcCenter = CGPointMake((canvasBar.frame.origin.x + canvasBar.frame.size.width)/2, dropDownIcon.size.height/2 + canvasBar.frame.size.height);
    [expandButton setCenter:viewcCenter];
    [self.view addSubview:expandButton];
    //page lable
    currentLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
    currentLable.textColor = [UIColor whiteColor];
    currentLable.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    currentLable.shadowOffset = CGSizeMake(1, 1);
    currentLable.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    currentLable.textAlignment = NSTextAlignmentCenter;
    currentLable.text = [NSString stringWithFormat:@"1"];
    currentLable.backgroundColor = [UIColor clearColor];
    [expandButton addSubview:currentLable];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(currentLable.frame.origin.x +  currentLable.frame.size.width + 6, 4, 1, 12)];
    line.layer.cornerRadius = 2.0;
    line.layer.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f].CGColor;
    line.layer.shadowOffset = CGSizeMake(1, 1);
    line.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6f];
    [expandButton addSubview:line];
    
    //of page lable
    totalLable = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 25, 20)];
    totalLable.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    totalLable.textAlignment = NSTextAlignmentCenter;
    totalLable.textColor = [UIColor whiteColor];
    totalLable.textColor = [UIColor whiteColor];
    totalLable.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    totalLable.shadowOffset = CGSizeMake(1, 1);
    totalLable.text = [NSString stringWithFormat:@"of %d",[[tabController tabsArray] count]];
    totalLable.backgroundColor = [UIColor clearColor];
    [expandButton addSubview:totalLable];

    [tabController receiveObject:^(id object) {
        tabController.savedAceView = object;//use for keep setting
        if(tabController.savedAceView != nil){
            doodleview.drawView.drawTool  = tabController.savedAceView.drawTool;
            doodleview.drawView.lineColor = tabController.savedAceView.lineColor;
            doodleview.drawView.lineWidth = tabController.savedAceView.lineWidth;
            doodleview.drawView.lineAlpha = tabController.savedAceView.lineAlpha;
            doodleview.drawView.TextOrPen = tabController.savedAceView.TextOrPen;
            doodleview.drawView.isclear   = tabController.savedAceView.isclear;
        }

    }];
}

- (void)openTapView:(UIButton *)btn
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         tabController.frame = CGRectMake(0, canvasBar.frame.size.height,  canvasBar.frame.size.width, + (isOpen ? - tabController.frame.size.height: tabController.frame.size.height));
                         btn.frame = CGRectMake(btn.frame.origin.x,btn.frame.origin.y+(isOpen ? - kLZXTabBarHigh : kLZXTabBarHigh), btn.frame.size.width, btn.frame.size.height);
                     }];    
    isOpen = !isOpen;
}
- (void)showCommentView:(NSString *)comment webImage:(UIImage *)image
{
    if([comment length] > 0){
        self.doodleview.drawView .drawTool = ACEDrawingToolTypeMedia;
        LZXToolButton * toolsNotebtn = [canvasBar.buttonArray objectAtIndex:LZXTextVIew];
        self.doodleview.drawView.isclear = NO;
        self.doodleview.drawView.lineColor = [UIColor yellowColor];
        [canvasBar.buttonArray enumerateObjectsUsingBlock:^(LZXToolButton * toolsBtn, NSUInteger idx, BOOL *stop) {
            if(toolsNotebtn == toolsBtn)
                toolsNotebtn.selected = YES;
            else
                toolsBtn.selected = NO;
        }];//实现工具栏单选
        [self.doodleview.drawView showCommentView:comment];
    }
    if(image != nil){
        //呈现图片
        [self.doodleview.drawView showImageView:image];
    }
}


-(void)add:(id)sender
{
    if([tabController.tabsArray count] < 10){
        if(doodleview){
            [doodleview removeFromSuperview];
        }
        LOG(@"新加之前：%@", [self.doodleview.drawView pathArray]);
         NSString *tapTitle = [NSString stringWithFormat:@"板书 %d",[tabController.tabsArray count] + 1];
        [tabController addTabWithTitle:tapTitle];
        self.doodleview = [tabController.drawArrays lastObject];
        [canvasBar setCanvasView:doodleview.drawView];
        _pr(self.doodleview.frame);
        [self.view addSubview:self.doodleview];
        [self.view sendSubviewToBack:self.doodleview];
        LOG(@"新加之后：%@",[self.doodleview.drawView pathArray]);
        
        return;
    }

}
#pragma mark -
#pragma mark BrowserTabViewDelegate
-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView didSelecedAtIndex:(NSUInteger)index
{
    if(doodleview){
        [doodleview removeFromSuperview];
    }
    self.doodleview = [browserTabView.drawArrays objectAtIndex:index];
    if(tabController.savedAceView != nil){
        doodleview.drawView.drawTool  = tabController.savedAceView.drawTool;
        doodleview.drawView.lineColor = tabController.savedAceView.lineColor;
        doodleview.drawView.lineWidth = tabController.savedAceView.lineWidth;
        doodleview.drawView.lineAlpha = tabController.savedAceView.lineAlpha;
        doodleview.drawView.TextOrPen = tabController.savedAceView.TextOrPen;
        doodleview.drawView.isclear   = tabController.savedAceView.isclear;
    }
    [self.view addSubview:self.doodleview];
    [self.view sendSubviewToBack:self.doodleview];
    totalLable.text = [NSString stringWithFormat:@"of %d", browserTabView.tabsArray.count];
    currentLable.text = [NSString stringWithFormat:@"%d", index + 1];

}

-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView didRemoveTabAtIndex:(NSUInteger)index{
    LOG(@"BrowserTabView did Remove Tab at index:  %d",index);
    [browserTabView.drawArrays removeObjectAtIndex:index];
}
-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView exchangeTabAtIndex:(NSUInteger)fromIndex withTabAtIndex:(NSUInteger)toIndex{
    LOG(@"BrowserTabView exchange Tab  at index:  %d with Tab at index :%d ",fromIndex,toIndex);
    [browserTabView.drawArrays exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}

- (void)dealloc
{
    NSLog(@"-----DooleViewDealloc");

}
@end
