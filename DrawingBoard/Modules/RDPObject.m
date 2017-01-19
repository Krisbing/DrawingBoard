//
//  RDPObject.m
//  lexueCanvas
//
//  Created by lezhixing on 13-6-6.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "RDPObject.h"

@implementation RDPObject
@synthesize location;
@synthesize endPoint;
@synthesize lineColor;
@synthesize lineAlpha;
//@synthesize lineSize;
@synthesize lineWidth;
@synthesize mark;
@synthesize drawTool;
@synthesize isclear;

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.lineColor forKey:@"LineColor"];
    [coder encodeFloat:lineAlpha forKey:@"LineAlpha"];
    //[coder encodeFloat:lineSize forKey:@"LineSize"];
    [coder encodeFloat:lineWidth forKey:@"LineWidth"];
    [coder encodeFloat:location.x forKey:@"StrokeStartPoint.x"];
    [coder encodeFloat:location.y forKey:@"StrokeStartPoint.y"];
    [coder encodeFloat:endPoint.x forKey:@"StrokeEndPoint.x"];
    [coder encodeFloat:endPoint.y forKey:@"StrokeEndPoint.y"];
    [coder encodeInt:drawTool forKey:@"drawTool"];
    [coder encodeBool:isclear forKey:@"isclear"];
    NSLog(@"%@",[mark description]);
    [coder encodeObject:mark forKey:@"Mark"];
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
	if (self != nil) {
        float locationx = [coder decodeFloatForKey:@"StrokeStartPoint.x"];
		float locationy = [coder decodeFloatForKey:@"StrokeStartPoint.y"];
        self.location = CGPointMake(locationx, locationy);
        float endPointx = [coder decodeFloatForKey:@"StrokeEndPoint.x"];
		float endPointy = [coder decodeFloatForKey:@"StrokeEndPoint.y"];
        self.endPoint = CGPointMake(endPointx, endPointy);
        self.mark = [coder decodeObjectForKey:@"Mark"];
        self.lineColor = [coder decodeObjectForKey:@"LineColor"];
        self.lineAlpha = [coder decodeFloatForKey:@"LineAlpha"];
        self.lineWidth = [coder decodeFloatForKey:@"LineWidth"];
        drawTool = [coder decodeIntForKey:@"drawTool"];
        isclear = [coder decodeBoolForKey:@"isclear"];
//        self.lineSize = [coder decodeFloatForKey:@"LineSize"];
    }
    return self;
}
#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
     return [[self class] allocWithZone: zone];
}
@end
