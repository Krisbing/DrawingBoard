//
//  LZXCoordinatingController.h
//  lexue
//
//  Created by songjie on 13-4-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZXDoodleViewController.h"

@interface LZXCoordinatingController : NSObject

@property (nonatomic,strong) LZXDoodleViewController *canvasViewController;

+ (LZXCoordinatingController *) sharedInstance;

@end
