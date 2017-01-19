//
//  BrushBoardView.h
//  DrawingBoard
//
//  Created by songjie on 2017/1/6.
//  Copyright © 2017年 songjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrushBoardView : UIImageView



@end


@interface AFBezierPath : NSObject

+ (NSArray *)curveFactorization:(CGPoint)fromPoint toPoint:(CGPoint)toPoint controlPoints:(NSArray *)controlPoints count:(int)count;


@end