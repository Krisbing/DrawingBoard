//
//  BrushBoardView.m
//  DrawingBoard
//
//  Created by songjie on 2017/1/6.
//  Copyright © 2017年 songjie. All rights reserved.
//

#import "BrushBoardView.h"

@interface BrushBoardView (){
    NSMutableArray *points;
    CGFloat currentWidth;
    UIImage *defaultImage;
    UIImage *lastImage;
    CGFloat minWidth;
    CGFloat maxWidth;
}

@end

@implementation BrushBoardView
- (void)clearChecked {
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame: CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitle:@"Clear" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [btn addTarget:self action:@selector(clearChecked) forControlEvents:UIControlEventTouchUpInside];
        
        self.image = [UIImage imageNamed:@"apple"];
        id v1 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
        id v2 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
        id v3 = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
        points = [NSMutableArray arrayWithObjects:v1,v2,v3, nil];
        
        currentWidth = 10;
        minWidth = 5;
        maxWidth = 13;
        
        [self changeImage];
        
    }
    return self;
}

- (void)changeImage {
    UIGraphicsBeginImageContext(self.frame.size);
    // 贝赛尔曲线的起始点和末尾点
    CGPoint tempPoint1 = CGPointMake(([points[0] CGPointValue].x+[points[1] CGPointValue].x)/2, ([points[0] CGPointValue].y+[points[1] CGPointValue].y)/2);
    CGPoint tempPoint2 = CGPointMake(([points[1] CGPointValue].x+[points[2] CGPointValue].x)/2, ([points[1] CGPointValue].y+[points[2] CGPointValue].y)/2);
    
    UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:[points[2] CGPointValue] radius:3 startAngle:0 endAngle:(CGFloat)(M_PI)*2.0 clockwise:YES];
    [[UIColor redColor]set];
    [pointPath stroke];
    
    pointPath = [UIBezierPath bezierPathWithArcCenter:[points[1] CGPointValue] radius:3 startAngle:0 endAngle:(CGFloat)(M_PI)*2.0 clockwise:YES];
    [pointPath stroke];
    
    pointPath = [UIBezierPath bezierPathWithArcCenter:[points[0] CGPointValue] radius:3 startAngle:0 endAngle:(CGFloat)(M_PI)*2.0 clockwise:YES];
    [pointPath stroke];
    
    pointPath = [UIBezierPath bezierPathWithArcCenter:tempPoint1 radius:3 startAngle:0 endAngle:(CGFloat)(M_PI)*2.0 clockwise:YES];
    [pointPath stroke];
    
    pointPath = [UIBezierPath bezierPathWithArcCenter:tempPoint2 radius:3 startAngle:0 endAngle:(CGFloat)(M_PI)*2.0 clockwise:YES];
    [pointPath stroke];
    
    //贝赛尔曲线的估算长度
    CGFloat x1 = (CGFloat)abs(tempPoint1.x-tempPoint2.x);
    CGFloat x2 = (CGFloat)abs(tempPoint1.y-tempPoint2.y);
    int len = (int)(sqrt(pow(x1, 2) + pow(x2,2))*10);
    
    // 如果仅仅点击一下
    if (len == 0) {
        UIBezierPath *zeroPath = [UIBezierPath bezierPathWithArcCenter:[points[1] CGPointValue] radius:maxWidth/2-2 startAngle:0 endAngle:(CGFloat)(M_PI)*2.0 clockwise:YES];
        [[UIColor blackColor] setFill];
        [zeroPath fill];
        
        // 绘图
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        lastImage = self.image;
        UIGraphicsEndImageContext();
        return;
    }

    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

@end

@implementation AFBezierPath

+ (CGFloat)comp:(int)n k:(int)k {
    int s1 = 1;
    int s2 = 1;
    if(k == 0) return 1;
    for (int i = n; i >= n-k+1; i--) {
        s1 = s1*i;
    }
    for (int i = k; i >=2 ; i--) {
        s2 = s2 * i;
    }
    return (CGFloat)s1/s2;
}

+ (CGFloat)realPow:(CGFloat)n k:(int)k {
    if (k == 0) {
        return 1.0;
    }
    return powf(n, (CGFloat)k);
}

+ (CGFloat)bezMaker:(int)n k:(int)k t:(int)t {
    return [AFBezierPath comp:n k:k] * [AFBezierPath realPow:t k:k];
}

+ (NSArray *)curveFactorization:(CGPoint)fromPoint toPoint:(CGPoint)toPoint controlPoints:(NSArray *)controlPoints count:(int)count {
    //如果分解数量为0，生成默认分解数量
    if (count == 0) {
        int x1 = abs(fromPoint.x - toPoint.x);
        int x2 = abs(fromPoint.y - toPoint.y);
        count = (int)sqrt(pow(x1, 2) + pow(x2, 2));
    }
    // 贝赛尔曲线的计算
    CGFloat s = 0.0;
    NSMutableArray *t = [NSMutableArray array];
    CGFloat pc = 1/(CGFloat)count;
    int power = controlPoints.count + 1;
    for (int i = 0; i <= count +1; i++) {
        [t addObject:[NSNumber numberWithFloat:s]];
        s = s + pc;
    }
    NSMutableArray * newPoint = [NSMutableArray array];
//    for (int i = 0; i<= count+1; i++) {
//        CGFloat resultX = fromPoint.x * [AFBezierPath bezMaker:power k:0 t:t[i]];
//        for (int j = 1; j <= power-1; j++) {
//            resultX += controlPoints[1].x * [AFBezierPath bezMaker:power k:j t:0];
//        }
//    }

    
    
    return nil;
}

@end