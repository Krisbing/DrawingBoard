//
//  LZXToolPopoverControllerViewController.h
//  lexue
//
//  Created by songjie on 13-4-18.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXToolButton.h"
#import "LZXCommandSlider.h"
#import "LZXColorPickerView.h"
#import "LZXObject.h"

@interface LZXProductView : UIView
@property (nonatomic, strong) LZXToolButton *button;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGFloat opacity;
@property (nonatomic, weak) UIColor *color;
@end

@interface LZXToolPopoverController : UIViewController

@property (nonatomic, strong) LZXColorPickerView *colorPickerController;
@property (nonatomic, strong) UIPopoverController *toolPopover;
@property (nonatomic, strong) LZXCommandSlider *sizeSlider;
@property (nonatomic, strong) LZXCommandSlider *opacitySlider;
@property (nonatomic, strong) UILabel *sizeLable;
@property (nonatomic, strong) UILabel *opacitLable;
@property (nonatomic, strong) LZXToolButton *barButton;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) NSMutableArray *popoBtnArray;
@property (nonatomic, strong) LZXProductView * productView ;

- (void)setBarButton:(LZXToolButton *)_barButton;
- (void)setSelectedColor:(UIColor *)color;
@end


@interface LZXEraserPopoverController : UIViewController

@property (nonatomic, strong) UIPopoverController *eraserPopover;
@property (nonatomic, strong) LZXCommandSlider    *erasersizeSlider;
@property (nonatomic, strong) LZXToolButton       *barButton;
@property (nonatomic, strong) UILabel             *sizeLable;

- (void)setBarButton:(LZXToolButton *)_barButton;

@end



