//
//  CanvasView.m
//  lexueCanvas
//
//  Created by lezhixing on 13-5-14.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXDooleView.h"
#import "ACEDrawingView.h"
#import "UIColor+Extend.h"
@implementation LZXDooleView
@synthesize drawView;
#pragma mark -
#pragma mark Scribble observer method

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.image = [UIImage imageNamed:@"testbod.jpg"];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"475e45"];
        //初始化 scribble_涂鸦 模型
        drawView = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        drawView.drawTool = ACEDrawingToolTypePen;
        drawView.isclear = NO;
        drawView.lineAlpha = 1.0;
        drawView.lineWidth = 3.0;
        drawView.lineColor = [UIColor yellowColor];
        [self addSubview:drawView];

    }
    return self;
}

@end
