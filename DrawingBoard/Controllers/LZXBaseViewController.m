//
//  LZXBaseViewController.m
//  lexue-teacher
//
//  Created by lezhixing on 13-6-3.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXBaseViewController.h"

@interface LZXBaseViewController ()

@end

@implementation LZXBaseViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark shouldAutorotate
#if __IPAD_OS_VERSION_MAX_ALLOWED >= __IPAD_6_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(IOS_VERSION < 6.0){
        return (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
    }
    else{
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark -
#pragma mark public
- (void) setViewBackgroundImage:(NSString *)imagename
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
    bgImageView.userInteractionEnabled = YES;
    self.view = bgImageView;
}
@end
