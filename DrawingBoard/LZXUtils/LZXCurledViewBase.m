//
//  LZXCurledViewBase.m
//  lexue-teacher
//
//  Created by lezhixing on 13-7-19.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXCurledViewBase.h"

@implementation LZXCurledViewBase

+(UIBezierPath*)curlShadowPathWithShadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset forView:(UIView*)view
{
    
    CGSize viewSize = [view bounds].size;
    CGPoint polyTopLeft = CGPointMake(0.0, controlPointYOffset);
    CGPoint polyTopRight = CGPointMake(viewSize.width, controlPointYOffset);
    CGPoint polyBottomLeft = CGPointMake(0.0, viewSize.height + shadowDepth);
    CGPoint polyBottomRight = CGPointMake(viewSize.width, viewSize.height +  shadowDepth);
    
    CGPoint controlPointLeft = CGPointMake(controlPointXOffset , controlPointYOffset);
    CGPoint controlPointRight = CGPointMake(viewSize.width - controlPointXOffset,  controlPointYOffset);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:polyTopLeft];
    [path addLineToPoint:polyTopRight];
    [path addLineToPoint:polyBottomRight];
    [path addCurveToPoint:polyBottomLeft
            controlPoint1:controlPointRight
            controlPoint2:controlPointLeft];
    
    [path closePath];
    return path;
}
@end
