#import "LZXCoordinatingController.h"

@implementation LZXCoordinatingController

static LZXCoordinatingController *sharedCoordinator = nil;

- (id)init
{
    self = [super init];
    if (self) {
       self.canvasViewController = [[LZXDoodleViewController alloc] init];
    }
    return self;
}
+ (LZXCoordinatingController *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         sharedCoordinator = [[LZXCoordinatingController alloc] init];
    });
    return sharedCoordinator;
}

@end