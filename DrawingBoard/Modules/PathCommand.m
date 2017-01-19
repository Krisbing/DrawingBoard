//
//  PathCommand.m
//  DrawingBoard
//
//  Created by songjie on 2017/1/4.
//  Copyright © 2017年 songjie. All rights reserved.
//

#import "PathCommand.h"
#import "LZXCoordinatingController.h"

@implementation RedoCommand

- (void)execute
{
    //恢复
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    LZXDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
    [[[canvasViewController doodleview] drawView] rodoLatestStep];
}

@end

@implementation UndoCommand
- (void)execute
{
    //撤销
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    LZXDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
    [[[canvasViewController doodleview] drawView] undoLatestStep];
}

@end
