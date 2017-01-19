//
//  UIImage+Rotation.h
//  lexue-teacher
//
//  Created by lezhixing on 13-7-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotation)

- (UIImage *)rotateImage:(UIImage *)aImage;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
