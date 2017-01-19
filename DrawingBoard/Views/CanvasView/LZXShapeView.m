//
//  LZXShapeView.m
//  lexue
//
//  Created by songjie on 13-4-25.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXShapeView.h"
#import "UIView+ZXQuartz.h"

@implementation LZXShapeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self drawCurveFrom:CGPointMake(10, 12)
                         to:CGPointMake(80, 45)
              controlPoint1:CGPointMake(15, 0)
              controlPoint2:CGPointMake(8, 20)];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *blue = [UIColor colorWithRed:80.f/255.f
                                    green:150.f/255.f
                                     blue:225.f/255.f
                                    alpha:1];
//
//    UIColor *white = [UIColor colorWithRed:1
//                                     green:1
//                                      blue:1
//                                     alpha:1];
//    [blue setStroke];//设置线条颜色
//    [white setFill]; //设置填充颜色
//    
//    //画背景矩形框
//    [self drawRectangle:CGRectMake(10, 10, 30, 30)];
//    
//    //画圆角矩形
//   // [self drawRectangle:CGRectMake(15, 15, 290, 290) withRadius:10];
    

    //画波浪线
    [self drawCurveFrom:CGPointMake(10, 12)
                     to:CGPointMake(80, 45)
          controlPoint1:CGPointMake(15, 0)
          controlPoint2:CGPointMake(8, 20)];
    [blue setFill];//设置蓝色填充
//    //画大圆
//    [self drawCircleWithCenter:CGPointMake(30, 30)
//                        radius:50];
//    
//    [blue setFill];//设置蓝色填充
//    
}

@end
