//
//  LZXCanvasViewGenerator.m
//  lexue
//
//  Created by songjie on 13-4-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXCanvasViewGenerator.h"

@implementation LZXCanvasViewGenerator

- (LZXCanvasBar *) canvasBarWithFrame:(CGRect) aFrame;
{
	return [[LZXCanvasBar alloc] initWithFrame:aFrame];
}

@end


@implementation StudentCanvasBarGenerator

- (LZXStudentCanvasBar *) canvasBarWithFrame:(CGRect)aFrame
{
    return [[LZXStudentCanvasBar alloc] initWithFrame:aFrame];
}
@end
