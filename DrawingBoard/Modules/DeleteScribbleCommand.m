//
//  DeleteScribbleCommand.m
//  lexueCanvas
//
//  Created by lezhixing on 13-5-17.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "DeleteScribbleCommand.h"
#import "LZXCoordinatingController.h"
#import "ACEDrawingView.h"

@implementation DeleteScribbleCommand
- (void) execute
{
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    LZXDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
    ACEDrawingView *drawView = [[canvasViewController doodleview] drawView];
    [[canvasViewController doodleview] setImage:nil];
    [drawView clear];
}
@end
