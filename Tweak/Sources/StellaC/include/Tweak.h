#import <UIKit/UIKit.h>

@interface Tweak : NSObject
+ (void)setup;
@end

@interface SBIconListView : UIView
@end

@interface SBRootFolderController : UIViewController
@property (nonatomic, strong) SBIconListView *dockIconListView;
@end

@interface SBFloatingDockPlatterView : UIView
@end

@interface SBFloatingDockView : UIView
@property (nonatomic, strong) SBFloatingDockPlatterView *mainPlatterView;
@end

@interface SBFloatingDockViewController : UIViewController
@property (nonatomic, strong) SBFloatingDockView *dockView;
@end

@interface CSMainPageContentViewController : UIViewController
@end

@interface NCNotificationShortLookViewController : UIViewController
@end

@interface MRUCoverSheetViewController : UIViewController
@end

@interface CSAdjunctItemView : UIView
@end

@interface SBLockScreenManager
-(void)_setUILocked:(BOOL)arg1;
@end

@interface SBBacklightController : NSObject
@end

@interface CSActivityItemViewController : UIViewController
@end

@interface NCNotificationListSupplementaryHostingViewController : UIViewController
@end