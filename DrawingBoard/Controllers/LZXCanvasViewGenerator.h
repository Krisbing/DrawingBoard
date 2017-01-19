//
//  LZXCanvasViewGenerator.h
//  lexue
//
//  Created by songjie on 13-4-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZXCanvasBar.h"
#import "LZXStudentCanvasBar.h"

@interface LZXCanvasViewGenerator : NSObject

- (LZXCanvasBar *) canvasBarWithFrame:(CGRect) aFrame;

@end


@interface StudentCanvasBarGenerator : LZXCanvasViewGenerator

- (LZXStudentCanvasBar *) canvasBarWithFrame:(CGRect) aFrame;

@end
