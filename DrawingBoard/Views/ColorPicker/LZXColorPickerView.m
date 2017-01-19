//
//  LZXColorPickerViewController.m
//  lexue
//
//  Created by songjie on 13-4-19.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXColorPickerView.h"
#import "UIColor+NEOColor.h"
#import <QuartzCore/QuartzCore.h>

@interface LZXColorPickerView () /*<NEOColorPickerViewDelegate,SSColorPickerDelegate>*/ {
    NSMutableArray *_colorArray;
}

@property (nonatomic, weak) CALayer *selectedColorLayer;
@property (nonatomic, strong) UIColor* savedColor;

@end


@implementation LZXColorPickerView

@synthesize simpleColorGrid;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        _colorArray = [NSMutableArray array];
        
        int colorCountAA = NEOColorPicker4InchDisplay() ? 20 : 16;
        for (int i = 0; i < colorCountAA; i++) {
            UIColor *color = [UIColor colorWithHue:i / (float)colorCountAA saturation:1.0 brightness:1.0 alpha:1.0];
            [_colorArray addObject:color];
        }
        
        colorCountAA = NEOColorPicker4InchDisplay() ? 8 : 4;
        for (int i = 0; i < colorCountAA; i++) {
            UIColor *color = [UIColor colorWithWhite:i/(float)(colorCountAA - 1) alpha:1.0];
            [_colorArray addObject:color];
        }
        [self creatColorView];
       // [self creatFreeColorView];
        
    }
    return self;
}

- (UIView *)creatFreeColorView
{
    //调色板
    colorPacthView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 60.0, 190.0, 250.0)];
    colorPacthView.backgroundColor = [UIColor clearColor];
    
    colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(0.0, 10.0, 190.0, 180.0)];
//    [colorPicker setDelegate:self];
    [colorPicker setBrightness:1.0];
    [colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
    [colorPicker setBackgroundColor:[UIColor clearColor]];
    [colorPacthView addSubview:colorPicker];
    [colorPicker receiveObject:^(id object) {
        self.selectedColor =object;
        [self updateSelectedColor:self.selectedColor];

    }];

    //透明度
    brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(0.0, 220.0, 190.0, 10.0)];
	[brightnessSlider setColorPicker:colorPicker];
	[brightnessSlider setUseCustomSlider:YES]; // Defaults to NO
    [colorPacthView addSubview:brightnessSlider];
    
    return colorPacthView;
}
- (void)creatColorView
{
    self.buttonHue = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 40, 40)];
    self.buttonHue.selected = NO;
    [self.buttonHue addTarget:self action:@selector(colorChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    simpleColorGrid = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 450 - 245, 248)];
    [self addSubview:simpleColorGrid];
    
    if (!self.selectedColor) {
        self.selectedColor = [UIColor blackColor];
    }
    
    if (self.selectedColorText.length != 0)
    {
        self.selectedColorLabel.text = self.selectedColorText;
    }
    simpleColorGrid.backgroundColor = [UIColor clearColor];
    
    [self.buttonHue setBackgroundColor:[UIColor clearColor]];
    [self.buttonHue setImage:[UIImage imageNamed:@"hue_selector"] forState:UIControlStateNormal];
    [self addSubview:self.buttonHue];
    
    CALayer *colorlayer = [CALayer layer];
    colorlayer.frame = CGRectMake(55, 5, 100, 40);
    colorlayer.cornerRadius = 6.0;
    colorlayer.shadowColor = [UIColor blackColor].CGColor;
    colorlayer.shadowOffset = CGSizeMake(0, 2);
    colorlayer.shadowOpacity = 0.8;
    [self.layer addSublayer:colorlayer];
    
    self.selectedColorLayer = colorlayer;
    
    int colorCount = NEOColorPicker4InchDisplay() ? 28 : 20;
    for (int i = 0; i < colorCount && i < _colorArray.count; i++) {
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = 6.0;
        UIColor *color = [_colorArray objectAtIndex:i];
        layer.backgroundColor = color.CGColor;
        
        int column = i % 4;
        int row = i / 4;
        layer.frame = CGRectMake(8 + (column * 50), row * 50  + 2, 40, 40);
        [self setupShadow:layer];
        [simpleColorGrid.layer addSublayer:layer];
    }
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [simpleColorGrid addGestureRecognizer:recognizer];
}

- (void)updateSelectedColor:(UIColor *)selectedColor{
    self.selectedColorLayer.backgroundColor = selectedColor.CGColor;
    [self sendObject:selectedColor];//把选择的颜色发送给 popoController
}


- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:simpleColorGrid];
    int row = (int)((point.y - 8) / 50);
    int column = (int)((point.x - 8) / 50);
    int index = row * 4 + column;
	
	if (index < _colorArray.count) {
		self.selectedColor = [_colorArray objectAtIndex:index];
	}
    [self updateSelectedColor:self.selectedColor];
    
}

#pragma mark -
#pragma mark - colorPickerDelegate
- (void)colorChangeAction:(id)sender{
    //调度调试板
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kTransitionDuration];
    
	[UIView setAnimationTransition:(simpleColorGrid ?
                                    UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
                           forView:self cache:YES];
    
	if ([self.subviews containsObject:simpleColorGrid] == YES){
        [simpleColorGrid removeFromSuperview];
        [self creatFreeColorView];
        [self addSubview:colorPacthView];
	}else
	{
        [colorPacthView removeFromSuperview];
		[self addSubview:simpleColorGrid];
	}
	[UIView commitAnimations];
}

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
    self.selectedColor = [cp selectionColor];
    [self updateSelectedColor:self.selectedColor];
}

@end
