#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "GcUniversal/GcColorPickerUtils.h"
#import "GcUniversal/GcImagePickerUtils.h"

#define snowflakePath @"/Library/PreferenceBundles/stellarprefs.bundle/snowflake.png"
HBPreferences *prefs;

BOOL enabled;
NSString *customColor = @"FFFFFF";

NSInteger lsspeed;
NSInteger lsxAcceleration;
NSInteger lsBirthrate;
BOOL enableLSAnimation;

NSInteger hsspeed;
NSInteger hsxAcceleration;
NSInteger hsBirthrate;
BOOL enableHSAnimation;

NSInteger customImageSize;
BOOL enableCustomImage;
BOOL enableSnowGroundLayer;

CAEmitterLayer *homeEmitterLayer;
CAEmitterLayer *lockscreenEmitterLayer;
CAEmitterLayer *notificationEmitterLayer;
CAEmitterLayer *nowplayingEmitterLayer;

CGRect currentLockBounds;
CGRect currentHomeBounds;
CGRect currentSnowLayerBounds;
CGRect currentNotificationBounds;
CGRect currentMusicViewBounds;
CGRect currentSnowLayerBounds;

UIBezierPath* bezierPath;

@interface CSMainPageContentViewController : UIViewController
- (void)letItSnow;
@end

@interface NCNotificationShortLookViewController : UIViewController
@end

@interface CSAdjunctItemView : UIView
@end

@interface MRUCoverSheetViewController : UIViewController
@end

@interface CSMainPageView : UIView
@end

@interface SBIconController : UIViewController
@end

@interface UIImage (Resize)
- (UIImage *)convert;
@end

@interface CAEmitterLayer (Animation)
- (void)resume;
- (void)pause;
@end