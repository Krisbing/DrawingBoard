//
//  PathCommand.h
//  DrawingBoard
//
//  Created by songjie on 2017/1/4.
//  Copyright © 2017年 songjie. All rights reserved.
//

#import "LZXBarCommand.h"

@interface RedoCommand : LZXBarCommand
- (void) execute;
@end

@interface UndoCommand : LZXBarCommand
- (void) execute;
@end