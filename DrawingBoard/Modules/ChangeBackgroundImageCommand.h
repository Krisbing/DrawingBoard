//
//  ChangeBackgroundImageCommand.h
//  lexueCanvas
//
//  Created by lezhixing on 13-5-17.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZXBarCommand.h"
#import "LZXCoordinatingController.h"
@interface ChangeBackgroundImageCommand : LZXBarCommand<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    LZXDoodleViewController *canvasViewController;
    BOOL isGraffiti;//是否涂鸦
}
- (void) execute;
@end
