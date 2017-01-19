//
//  LZXBrowserTab.h
//  lexue
//
//  Created by songjie on 13-4-22.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXBrowserTabView.h"
@class LZXBrowserTabView;
@interface LZXBrowserTab : UIView{
    //font of tab title
    UIFont *titleFont;
    
    //color for tab title when tab been normal state
    UIColor *normalTitleColor;
    
    //  image  for tab been selected
    UIImage *tabSelectedImage;
    
    //  image  for tab been normal state
    UIImage *tabNormalImage;
    
    NSString *reuseIdentifier;
    UIImageView *imageView;
    UIButton *imageViewClose;
    
    NSInteger index;
    
    BOOL selected;
    
    UIPanGestureRecognizer *panGuesture;
    
   // LZXBrowserTabView *delegate;
}
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, strong) UIImage *tabSelectedImage;
@property(nonatomic, strong) UIImage *tabNormalImage;
@property(nonatomic, strong) UIColor *normalTitleColor;
@property(nonatomic, strong) UIColor *selectedTitleColor;
@property(nonatomic, strong) UIImageView *imageView;;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIButton *imageViewClose;
@property(nonatomic, readonly) NSString *reuseIdentifier;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) LZXBrowserTabView * delegate;
@property(nonatomic, strong) NSMutableArray *pageArray;

-(id)initWithReuseIdentifier:(NSString *)aReuseIdentifier andDelegate:(id)aDelegate;
-(void)prepareForReuse;

@end
