//
//  LZXBrowserTabView.h
//  lexue
//
//  Created by songjie on 13-4-22.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXBrowserTab.h"
#import "LZXDooleView.h"
#import "ACEDrawingView.h"
@class LZXBrowserTabView;
@class LZXBrowserTab;

@protocol LZXBrowserTabViewDelegate<NSObject>

@optional
-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView didSelecedAtIndex:(NSUInteger)index;
-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView willRemoveTabAtIndex:(NSUInteger)index;
-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView didRemoveTabAtIndex:(NSUInteger)index;
-(void)BrowserTabView:(LZXBrowserTabView *)browserTabView exchangeTabAtIndex:(NSUInteger)fromIndex withTabAtIndex:(NSUInteger)toIndex;
@end

@interface LZXBrowserTabView : UIView<UIGestureRecognizerDelegate>{
    
    // image for the tabview backgroud
    UIImage *tabViewBackImage;
    
    NSUInteger numberOfTabs;
    
    NSInteger selectedTabIndex;
    
    //array for saving all the tab
    NSMutableArray *tabsArray;
    
    //array for saving  frames of tabs
    NSMutableArray *tabFramesArray;
    
    // reuse queue holds unused tabs
    NSMutableArray *reuseQueue;
    //id<LZXBrowserTabViewDelegate> delegate;
    
    //ACEDrawingView *tapDrawView;
    NSMutableArray *drawArrays;
    int page;
    
}
@property(nonatomic, strong) ACEDrawingView *savedAceView;
@property(nonatomic, strong) UIImage *tabViewBackImage;
@property(nonatomic, assign) NSUInteger numberOfTabs;
@property(nonatomic, assign) NSInteger selectedTabIndex;
@property(nonatomic, strong) NSMutableArray *tabsArray;
@property(nonatomic, strong) NSMutableArray *tabFramesArray;
@property(nonatomic, strong) NSMutableArray *drawArrays;

@property(nonatomic, readonly) NSMutableArray *reuseQueue;
@property(nonatomic, assign) id<LZXBrowserTabViewDelegate> delegate;
//@property(nonatomic, strong) ACEDrawingView *tapDrawView;

-(void)initWithTabTitles:(NSArray *)titles andDelegate:(id)adelegate;
-(void)addTabWithTitle:(NSString *)title;
-(void)setSelectedTabIndex:(NSInteger)aSelectedTabIndex animated:(BOOL)animation;
-(void)removeTabAtIndex:(NSInteger)index animated:(BOOL)animated;

@end