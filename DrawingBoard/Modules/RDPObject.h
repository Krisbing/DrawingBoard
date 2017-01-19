//
//  RDPObject.h
//  lexueCanvas
//
//  Created by lezhixing on 13-6-6.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"
#import "ACEDrawingView.h"
@interface RDPObject : NSObject<NSCoding,NSCopying>
{
    @private
    id <Mark> mark;
    CGPoint location;
    CGPoint endPoint;
}
@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) id <Mark> mark;
@property (nonatomic, strong) UIColor *lineColor;
//@property (nonatomic, assign) float lineSize;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, assign) float lineAlpha;
@property (nonatomic, assign)  ACEDrawingToolType drawTool;
@property (nonatomic) BOOL isclear;
@end
