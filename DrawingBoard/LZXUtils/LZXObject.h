//
//  LZXObject.h
//  lexue
//
//  Created by songjie on 13-3-29.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface NSObject(LZXObject)

//send object
-(void)receiveObject:(void(^)(id object))sendObject;
-(void)sendObject:(id)object;

@end
