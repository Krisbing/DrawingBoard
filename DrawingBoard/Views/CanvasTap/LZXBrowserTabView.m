//
//  LZXBrowserTabView.m
//  lexue
//
//  Created by songjie on 13-4-22.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#define kDefaultFrame CGRectMake(0,0,kMainScreenWidth - 100,44)
//define width of a tab ,here is the width of the image used to render tab;
//#define TAB_WIDTH 154
#define TAB_WIDTH (kMainScreenWidth - 100 - 35/*colse width*/) / [tabsArray count]
//define overlap width between tabs
#define OVERLAP_WIDTH 15
#define TAB_FOOTER_HEIGHT 5

static NSString *kReuseIdentifier = @"UserIndentifier";

#import "LZXBrowserTabView.h"
#import "LZXObject.h"

@interface LZXBrowserTabView()
-(void)caculateFrame;
@end

@implementation LZXBrowserTabView
@synthesize tabViewBackImage;
@synthesize selectedTabIndex,numberOfTabs;
@synthesize tabsArray,tabFramesArray,drawArrays;

@synthesize reuseQueue;
@synthesize delegate;
@synthesize savedAceView;
//@synthesize tapDrawView;


#pragma mark -
#pragma mark init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //
        //background color is the same color of tab when been selected.
        self.backgroundColor =[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        
        tabFramesArray = [[NSMutableArray alloc]initWithCapacity:0 ];
       // self.tabViewBackImage = [UIImage imageNamed:@"tab_background.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dooletop_bg@2x.png"]];
        page = 1;
    }
    return self;
}
-(void)initWithTabTitles:(NSArray *)titles andDelegate:(id)aDelegate
{
    tabsArray = [[NSMutableArray alloc] initWithCapacity:[titles count]];//tabArrays
    drawArrays = [[NSMutableArray alloc] initWithCapacity:[titles count]];//存放 多个ace
    
    for (int i = 0;i< titles.count ;i++) {
        LZXBrowserTab *tab=[[LZXBrowserTab alloc] initWithReuseIdentifier:kReuseIdentifier andDelegate:self];
        tab.index = i;
        tab.textLabel.text = [titles objectAtIndex:i];
        tab.delegate = self;
        [tabsArray addObject:tab];
        
        //默认初始化DoolView
        CGRect frame = CGRectMake(0, 20, kMainScreenWidth,kMainScreenHeight );
        LZXDooleView *dooleView = [[LZXDooleView alloc] initWithFrame:frame];
//        if(savedAceView != nil){
//            dooleView.drawView.drawTool  = savedAceView.drawTool;
//            dooleView.drawView.lineColor = savedAceView.lineColor;
//            dooleView.drawView.lineWidth = savedAceView.lineWidth;
//            dooleView.drawView.lineAlpha = savedAceView.lineAlpha;
//        }
       // dooleView.mode = LZXDoodleModeBlackboard;
        [drawArrays addObject:dooleView];
    }
    
    [self caculateFrame];
    
    reuseQueue = [[NSMutableArray alloc] init];
    delegate = aDelegate;
    
    if ([self.tabsArray count]) {
        [self setSelectedTabIndex:0 animated:NO];
    }

}

- (NSUInteger)numberOfTabs
{
	return [self.tabsArray count];
}
-(void)setSelectedTabIndex:(NSInteger)aSelectedTabIndex animated:(BOOL)animation
{
    selectedTabIndex = aSelectedTabIndex;
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:didSelecedAtIndex:)]) {
        [self.delegate BrowserTabView:self didSelecedAtIndex:aSelectedTabIndex];
    }
    
    //tabs before the selected are added in sequence from the first to the selected ;
    for (NSInteger tabIndex = 0; tabIndex < selectedTabIndex; tabIndex++) {
        
        NSValue *tabFrameValue = [tabFramesArray objectAtIndex:tabIndex];
        CGRect tabFrame = [tabFrameValue CGRectValue];
        LZXBrowserTab *tab = [tabsArray objectAtIndex:tabIndex];
        if (animation) {
            [UIView beginAnimations:nil context:nil];
            tab.frame = tabFrame;
            tab.delegate = self;
            [tab setSelected:NO];
            [UIView commitAnimations];
        }else{
            
            tab.frame = tabFrame;
            tab.delegate = self;
            [tab setSelected:NO];
        }
        
        [self addSubview:tab];
        
    }
    
    //tabs after the selected are added in sequence from the last to the selected ;
    for (NSInteger tabIndex = (self.numberOfTabs - 1); tabIndex >= selectedTabIndex; tabIndex--) {
        
        LZXBrowserTab *tab = [tabsArray objectAtIndex:tabIndex];
        if (self.selectedTabIndex == tabIndex) {
            [tab setSelected:YES];
        }else{
            [tab setSelected:NO];
        }
        
        NSValue *tabFrameValue = [tabFramesArray objectAtIndex:tabIndex];
        CGRect tabFrame = [tabFrameValue CGRectValue];
        if (animation) {
            [UIView beginAnimations:nil context:nil];
            tab.frame = tabFrame;
            [UIView commitAnimations];
        }else{
            tab.frame = tabFrame;
            
        }
        [self addSubview:tab];
    }
    
}
// use tabs from the queue
-(LZXBrowserTab *)dequeueTabUsingReuseIdentifier:(NSString *)reuseIdentifier
{
    
    LZXBrowserTab *reuseTab = nil;

    for (LZXBrowserTab *tab in reuseQueue) {
        
        if ([tab.reuseIdentifier isEqualToString:reuseIdentifier]) {
            reuseTab = tab;
            break;
            
        }
        
    }
    if (reuseTab != nil) {
        [reuseQueue removeObject:reuseTab];
    }
    
    [reuseTab prepareForReuse];
    
    return reuseTab;
    
}

- (void)addTabWithTitle:(NSString *)title
{
    //if the new tab is about to be off the tab view's bounds , here simply not adding it ;
    if (TAB_WIDTH *(self.numberOfTabs)> self.bounds.size.width) {
        return;
    }
    LZXBrowserTab *tab = [self dequeueTabUsingReuseIdentifier:kReuseIdentifier];//tab的重用机制
    CGRect frame = CGRectMake(0, 20, kMainScreenWidth,kMainScreenHeight);
    LZXDooleView *dooleView = [[LZXDooleView alloc] initWithFrame:frame];
    if(savedAceView != nil){
        dooleView.drawView.drawTool  = savedAceView.drawTool;
        dooleView.drawView.lineColor = savedAceView.lineColor;
        dooleView.drawView.lineWidth = savedAceView.lineWidth;
        dooleView.drawView.lineAlpha = savedAceView.lineAlpha;
    }
    //dooleView.mode = LZXDoodleModeBlackboard;
    if (tab) {
        tab.delegate = self;
    }else{
        
        tab = [[LZXBrowserTab alloc] initWithReuseIdentifier:kReuseIdentifier andDelegate:self];
    }
    
    page++;
    tab.textLabel.text = [NSString stringWithFormat:@"板书 %d",page];//title;
    
    
    tab.frame = CGRectZero;
    [self.drawArrays addObject:dooleView];
	[self.tabsArray addObject:tab];
    
    for (int i = 0; i < [tabsArray count]; i++) {
        LZXBrowserTab *tab = [tabsArray objectAtIndex:i];
        tab.index = i;
        tab.selected = NO;
    }
    
    [self caculateFrame];
    
    selectedTabIndex = [self.tabsArray count]-1;
    NSValue *tabFrameValue = [tabFramesArray lastObject];
    CGRect tabFrame = [tabFrameValue CGRectValue];
    
    tab.frame = tabFrame;
    tab.selected = YES;
    
    [self setSelectedTabIndex:selectedTabIndex animated:NO];
    
    
}


-(void)removeTabAtIndex:(NSInteger)index animated:(BOOL)animated
{
    
    if (index < 0 || index >= [tabsArray count]) {
        return;
    }
    LZXBrowserTab *tab = [tabsArray objectAtIndex:index];
    //the last one tab not allowed to remove,return;
    NSUInteger newIndex = tab.index;
    if (self.numberOfTabs == 1 || !self.numberOfTabs) {
        return;
    }
    
    //if previous selected index was the last tab ,keep the coming last one selected
    if (index == self.numberOfTabs-1) {
        newIndex = index -1;
    }
    
    [reuseQueue addObject:[tabsArray objectAtIndex:index]];
    [tabsArray removeObject:tab];
    
    [tab removeFromSuperview];
    
    NSInteger tabIndex = 0;
    for (LZXBrowserTab *tab in tabsArray) {
        
        tab.index = tabIndex;
        
        tabIndex++;
        
    }
    
    [self caculateFrame];
    
    [ self setSelectedTabIndex:newIndex animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:didRemoveTabAtIndex:)]) {
        [self.delegate BrowserTabView:self didRemoveTabAtIndex:index];
    }
    
}
-(void)caculateFrame
{
    CGFloat height = self.bounds.size.height;
    CGFloat right = 0;
    
    [tabFramesArray removeAllObjects];
    
    for (NSInteger tabIndex = 0; tabIndex <self.numberOfTabs; tabIndex++) {
        
        CGRect tabFrame = CGRectMake(right, 0, TAB_WIDTH, height/*- TAB_FOOTER_HEIGHT*/);
        
        [tabFramesArray addObject:[NSValue valueWithCGRect:tabFrame]];
        
        right += TAB_WIDTH;
        
    }
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
   // CGFloat height = self.bounds.size.height;
	
    //left 5 dp to show the background, and give a look that tab has footer
    
    //设置背景
	//[tabViewBackImage drawInRect:CGRectMake(0, 0, self.frame.size.width, height - TAB_FOOTER_HEIGHT)];
    
}

#pragma mark -
#pragma mark UIPanGestureRecognizer
- (void)handlePanGuesture:(UIPanGestureRecognizer *)sender {
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	//// The following algorithm for handling panguesture inspired from  https://github.com/graetzer/SGTabs
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    LZXBrowserTab *panTab = (LZXBrowserTab *)sender.view;
    NSUInteger panPosition = [self.tabsArray indexOfObject:panTab];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setSelectedTabIndex:panPosition animated:NO];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint position = [sender translationInView:self];
        CGPoint center = CGPointMake(sender.view.center.x + position.x, sender.view.center.y);
        // Don't move the tab out of the tabview
        if (center.x < self.bounds.size.width-5  &&  center.x > 5) {
            sender.view.center = center;
            [sender setTranslation:CGPointZero inView:self];
            CGFloat width = TAB_WIDTH;
            //NSLog(@"width::::::: %f",width);
            // If more than half the tab width is moved, exchange the positions
            if (abs(center.x - width*panPosition - width/2) > width/2) {
                NSUInteger nextPos = position.x > 0 ? panPosition+1 : panPosition-1;
                
                if (nextPos >= self.numberOfTabs)
                    return;
                
                LZXBrowserTab *nextTab = [self.tabsArray objectAtIndex:nextPos];
                if (nextTab) {
//                    if (selectedTabIndex == panPosition)
//                        selectedTabIndex = nextPos;
                    [self.tabsArray exchangeObjectAtIndex:panPosition withObjectAtIndex:nextPos];
                    
                    for (int i = 0; i < [tabsArray count]; i++) {
                        LZXBrowserTab *tab = [tabsArray objectAtIndex:i];
                        tab.index = i;
                        tab.selected = NO;
                        if (i == selectedTabIndex) {
                            tab.selected = YES;
                        }
                    }
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        nextTab.frame = CGRectMake(width*panPosition + 5, 0, width, self.bounds.size.height /*- 5*/);
                        
                        if ([self.delegate respondsToSelector:@selector(BrowserTabView:exchangeTabAtIndex:withTabAtIndex:)]) {
                            [self.delegate BrowserTabView:self exchangeTabAtIndex:panPosition withTabAtIndex:nextPos];
                        }
                        
                    }];
                }
            }
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3 animations:^{
            panTab.center = CGPointMake(panTab.center.x , panTab.center.y);
            [self setSelectedTabIndex:selectedTabIndex animated:YES];
        }];
    }
}
@end
