#import "Tweak.h"

@implementation UIImage (Resize)
- (UIImage *)convert {
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(customImageSize, customImageSize), NO, 0.0f);
	[self drawInRect:CGRectMake(0,0, CGSizeMake(customImageSize, customImageSize).width, CGSizeMake(customImageSize, customImageSize).height)];
	UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return icon;
}
@end

@implementation CAEmitterLayer (Animation)
- (void)pause {

	CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
	self.speed = 0.0;
	self.timeOffset = pausedTime;
}
- (void)resume {
	CFTimeInterval pausedTime = [self timeOffset];
	self.speed = 1.0;
	self.timeOffset = 0;
	self.beginTime = 0.0;
	CFTimeInterval timeSyncPause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
	self.beginTime = timeSyncPause;
}
@end

%group Lockscreen
// falling snow on lockscreen
%hook CSMainPageContentViewController
- (void)viewDidLoad {
	%orig;
	[self letItSnow];
}

// update the size and position of the layer if the device orientation changes
- (void)viewDidLayoutSubviews {
	%orig;
	if (!CGRectEqualToRect(self.view.bounds, currentLockBounds)) {
		currentLockBounds = self.view.bounds;
		lockscreenEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
		lockscreenEmitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, -30);
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	%orig;
	[lockscreenEmitterLayer pause];
	[nowplayingEmitterLayer pause];
}

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	[lockscreenEmitterLayer resume];
	[nowplayingEmitterLayer resume];
}
%new
- (void)letItSnow {
	CGRect screenBounds = [[UIScreen mainScreen] bounds];

	UIImage *icon = [[GcImagePickerUtils imageFromDefaults:@"com.yan.stellarprefs" withKey:@"customImagePhoto"] convert];
	
	CAEmitterCell *snowflakes = [CAEmitterCell emitterCell];
	snowflakes.name = @"snow";
	snowflakes.contents = enableCustomImage ? (id)icon.CGImage : (id)[[UIImage imageWithContentsOfFile:snowflakePath] CGImage];
	snowflakes.color = [[GcColorPickerUtils colorFromDefaults:@"com.yan.stellarprefs" withKey:@"lscustomColor" fallback:customColor] CGColor];
	snowflakes.scale = 0.06;
	snowflakes.scaleRange = M_PI;
	snowflakes.lifetime = 20;
	snowflakes.lifetimeRange = 5;
	snowflakes.birthRate = lsBirthrate;
	snowflakes.velocity = -30;
	snowflakes.velocityRange = -20;
	snowflakes.yAcceleration = lsspeed;
	snowflakes.xAcceleration = lsxAcceleration;
	snowflakes.emissionRange = M_PI / 10;
	snowflakes.spin = -0.5;
	snowflakes.spinRange = 1.0;

	lockscreenEmitterLayer = [CAEmitterLayer layer];
	lockscreenEmitterLayer.emitterShape = kCAEmitterLayerLine;
	lockscreenEmitterLayer.emitterSize = CGSizeMake(screenBounds.size.width, 0);
	lockscreenEmitterLayer.emitterPosition = CGPointMake(screenBounds.size.width /2, -30);
	lockscreenEmitterLayer.emitterCells = @[snowflakes];
	lockscreenEmitterLayer.beginTime = CACurrentMediaTime();
	lockscreenEmitterLayer.name = @"lockscreenEmitterLayer";

	[self.view.layer addSublayer:lockscreenEmitterLayer];
}
%end

%hook NCNotificationShortLookViewController
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	for (CAEmitterLayer *layer in self.view.layer.sublayers) {
		if (layer.class == [CAEmitterLayer class]) {
			[layer resume];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	%orig;
	for (CAEmitterLayer *layer in self.view.layer.sublayers) {
		if (layer.class == [CAEmitterLayer class]) {
			[layer pause];
		}
	}
}

- (void)viewDidLayoutSubviews {
	%orig;
	if (!CGRectEqualToRect(self.view.bounds, currentNotificationBounds)) {
		currentNotificationBounds = self.view.bounds;
		notificationEmitterLayer.emitterSize = CGSizeMake(currentNotificationBounds.size.width * 0.9, 0);
		notificationEmitterLayer.emitterPosition = CGPointMake(currentNotificationBounds.size.width / 2, 0);
	}
}
// make it snow on top of notifications
- (void)viewDidLoad {
	%orig;

	UIImage *icon = [[GcImagePickerUtils imageFromDefaults:@"com.yan.stellarprefs" withKey:@"customImagePhoto"] convert];
	
	CGRect bounds = self.view.bounds;

	CAEmitterCell *snowflakes = [CAEmitterCell emitterCell];
	snowflakes.name = @"snow";
	snowflakes.contents = enableCustomImage ? (id)icon.CGImage : (id)[[UIImage imageWithContentsOfFile:snowflakePath] CGImage];
	snowflakes.color = [[GcColorPickerUtils colorFromDefaults:@"com.yan.stellarprefs" withKey:@"lscustomColor" fallback:customColor] CGColor];
	snowflakes.scale = 0.06;
	snowflakes.scaleRange = M_PI;
	snowflakes.lifetime = 5;
	snowflakes.birthRate = lsBirthrate / 7;
	snowflakes.velocity = 0;
	snowflakes.velocityRange = 0;
	snowflakes.yAcceleration = 0;
	snowflakes.spin = -0.5;
	snowflakes.spinRange = 1.0;
	snowflakes.alphaSpeed = -0.8 / snowflakes.lifetime;

	notificationEmitterLayer = [CAEmitterLayer layer];
	notificationEmitterLayer.emitterShape = kCAEmitterLayerLine;
	notificationEmitterLayer.emitterSize = CGSizeMake(bounds.size.width * 0.9, 0);
	notificationEmitterLayer.emitterPosition = CGPointMake(bounds.size.width / 2, 0);
	notificationEmitterLayer.emitterCells = @[snowflakes];
	notificationEmitterLayer.beginTime = CACurrentMediaTime();
	notificationEmitterLayer.name = @"notificationEmitterLayer";

	[self.view.layer addSublayer:notificationEmitterLayer];
}
%end

%hook CSAdjunctItemView
- (void)didMoveToWindow {
	%orig;
	self.clipsToBounds = NO;
}
%end

%hook MRUCoverSheetViewController
- (void)viewDidLayoutSubviews {
	%orig;
	if (!CGRectEqualToRect(self.view.bounds, currentMusicViewBounds)) {
		currentMusicViewBounds = self.view.bounds;
		nowplayingEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 0.9, 0);
		nowplayingEmitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, 0);
	}
}
- (void)viewDidLoad {
	%orig;

	UIImage *icon = [[GcImagePickerUtils imageFromDefaults:@"com.yan.stellarprefs" withKey:@"customImagePhoto"] convert];

	CAEmitterCell *snowflakes = [CAEmitterCell emitterCell];
	snowflakes.name = @"snow";
	snowflakes.contents = enableCustomImage ? (id)icon.CGImage : (id)[[UIImage imageWithContentsOfFile:snowflakePath] CGImage];
	snowflakes.color = [[GcColorPickerUtils colorFromDefaults:@"com.yan.stellarprefs" withKey:@"lscustomColor" fallback:customColor] CGColor];
	snowflakes.scale = 0.06;
	snowflakes.scaleRange = M_PI;
	snowflakes.lifetime = 5;
	snowflakes.birthRate = lsBirthrate / 7;
	snowflakes.velocity = 0;
	snowflakes.velocityRange = 0;
	snowflakes.yAcceleration = 0;
	snowflakes.xAcceleration = 0;
	snowflakes.spin = -0.5;
	snowflakes.spinRange = 1.0;
	snowflakes.alphaSpeed = -0.8 / snowflakes.lifetime;

	nowplayingEmitterLayer = [CAEmitterLayer layer];
	nowplayingEmitterLayer.emitterShape = kCAEmitterLayerLine;
	nowplayingEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 0.9, -2);
	nowplayingEmitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, 0);
	nowplayingEmitterLayer.emitterCells = @[snowflakes];
	nowplayingEmitterLayer.beginTime = CACurrentMediaTime();
	nowplayingEmitterLayer.name = @"nowplayingEmitterLayer";
	
	self.view.layer.masksToBounds = NO;

	[[[self view] layer] addSublayer:nowplayingEmitterLayer];
}

%end

%hook CSMainPageView
- (void)layoutSubviews {
	%orig;
	if (!enableSnowGroundLayer) return;


		if (!CGRectEqualToRect(self.bounds, currentSnowLayerBounds)) {
			// add path for ground layer
			UIBezierPath* bezierPath = [UIBezierPath bezierPath];
			[bezierPath moveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93957 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.06154 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.94431 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93957 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.02821 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.94550 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.19231 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.09487 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.94313 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.12821 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.32051 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93720 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.25641 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.28846 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93632 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.39487 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.35256 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93809 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.37179 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93454 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.46667 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93720 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.41795 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93276 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.45128 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93720 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.58205 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.92417 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.48205 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93720 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.55897 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93246 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.68462 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.92417 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.60513 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.91588 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.67179 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.91943 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.73077 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.69744 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.92891 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.71538 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.83077 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.94668 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.74615 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93365 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 0.79231 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93128 * self.bounds.size.height)];
			[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 1.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93720 * self.bounds.size.height) controlPoint1: CGPointMake(CGRectGetMinX(self.bounds) + 0.86923 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.96209 * self.bounds.size.height) controlPoint2: CGPointMake(CGRectGetMinX(self.bounds) + 1.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93720 * self.bounds.size.height)];
			[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 1.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 1.00000 * self.bounds.size.height)];
			[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 1.00000 * self.bounds.size.height)];
			[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(self.bounds) + 0.00000 * self.bounds.size.width, CGRectGetMinY(self.bounds) + 0.93957 * self.bounds.size.height)];
			[bezierPath closePath];

			// add layer to the ground
			CAShapeLayer *snowLayer = [CAShapeLayer layer];
			snowLayer.path = bezierPath.CGPath;
			snowLayer.strokeColor = [[UIColor colorWithRed: 0.95 green: 0.96 blue: 0.98 alpha: 1.00] CGColor];
			snowLayer.fillColor = [[UIColor colorWithRed: 0.95 green: 0.96 blue: 0.98 alpha: 1.00] CGColor];
			snowLayer.lineWidth = 1.0;
			snowLayer.position = CGPointMake(0.0f, 0.0f);
			snowLayer.name = @"groundPath";
			snowLayer.shadowRadius = 4.0f;
			snowLayer.shadowOpacity = 0.5f;
			snowLayer.opacity = 0.9f;
			snowLayer.shadowPath = bezierPath.CGPath;
			snowLayer.shadowColor = [[UIColor colorWithRed: 0.95 green: 0.96 blue: 0.98 alpha: 1.00] CGColor];
			snowLayer.shadowOffset = CGSizeMake(0.0f, 0.6f);
			snowLayer.shadowOpacity = 0.6;

			// removing any layers that are currently in view so that we dont duplicate them
			// this is a bit hacky and maybe even inefficient, i'll do this properly as soon as i can
			NSArray *copy = [self.layer.sublayers copy];
			for (CALayer *layer in copy) {
				if (layer.class == CAShapeLayer.class) {
					[layer removeFromSuperlayer];
				}
			}
			
			currentSnowLayerBounds = self.bounds;

			[[self layer] addSublayer:snowLayer];
		}
}
%end
%end

%group Homescreen
// falling snow on homescreen
%hook SBIconController
- (void)viewDidLayoutSubviews {
	%orig;
	if (!CGRectEqualToRect(self.view.bounds, currentHomeBounds)) {
		currentHomeBounds = self.view.bounds;
		homeEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
		homeEmitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, -30);
	}
}
- (void)viewDidLoad {
	%orig;

	UIImage *icon = [[GcImagePickerUtils imageFromDefaults:@"com.yan.stellarprefs" withKey:@"customImagePhoto"] convert];
	
	CAEmitterCell *snowflakes = [CAEmitterCell emitterCell];
	snowflakes.name = @"snow";
	snowflakes.contents = enableCustomImage ? (id)icon.CGImage : (id)[[UIImage imageWithContentsOfFile:snowflakePath] CGImage];
	snowflakes.color = [[GcColorPickerUtils colorFromDefaults:@"com.yan.stellarprefs" withKey:@"hscustomColor" fallback:customColor] CGColor];
	snowflakes.scale = 0.06;
	snowflakes.scaleRange = M_PI;
	snowflakes.lifetime = 20;
	snowflakes.birthRate = hsBirthrate;
	snowflakes.velocity = -30;
	snowflakes.velocityRange = -20;
	snowflakes.yAcceleration = hsspeed;
	snowflakes.xAcceleration = hsxAcceleration;
	snowflakes.emissionRange = M_PI / 10;
	snowflakes.spin = -0.5;
	snowflakes.spinRange = 1.0;

	homeEmitterLayer = [CAEmitterLayer layer];
	homeEmitterLayer.emitterShape = kCAEmitterLayerLine;
	homeEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
	homeEmitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width /2, -30);
	homeEmitterLayer.emitterCells = @[snowflakes];
	homeEmitterLayer.beginTime = CACurrentMediaTime();
	homeEmitterLayer.name = @"homeEmitterLayer";

	[self.view.layer addSublayer:homeEmitterLayer];
}

// pause the homescreen animation when the view disappears
- (void)viewWillDisappear:(BOOL)animated {
	%orig;
	[homeEmitterLayer pause];
}

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	[homeEmitterLayer resume];
}
%end
%end

%hook SBLockScreenManager
// pause the lockscreen animations when the device locks
- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 {
	%orig;
	[lockscreenEmitterLayer pause];
	[notificationEmitterLayer pause];
	[nowplayingEmitterLayer pause];
}
%end

%hook SBBacklightController
// resume the lockscreen animations when the device wakes up
- (void)turnOnScreenFullyWithBacklightSource:(long long)arg1 {
	%orig;
	[lockscreenEmitterLayer resume];
	[notificationEmitterLayer resume];
	[nowplayingEmitterLayer resume];
}
%end

%ctor {
	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.yan.stellarprefs"];

	[prefs registerBool:&enabled default:YES forKey:@"enabled"];
	if (!enabled) return;

	%init();

	[prefs registerInteger:&lsspeed default:30 forKey:@"lsspeed"];
	[prefs registerInteger:&hsspeed default:30 forKey:@"hsspeed"];
	[prefs registerInteger:&lsxAcceleration default:0 forKey:@"lsxAcceleration"];
	[prefs registerInteger:&hsxAcceleration default:0 forKey:@"hsxAcceleration"];
	[prefs registerInteger:&customImageSize default:14 forKey:@"customImageSize"];
	[prefs registerInteger:&lsBirthrate default:30 forKey:@"lsBirthrate"];
	[prefs registerInteger:&hsBirthrate default:30 forKey:@"hsBirthrate"];
	[prefs registerBool:&enableCustomImage default:NO forKey:@"enableCustomImage"];
	[prefs registerBool:&enableLSAnimation default:YES forKey:@"enableLSAnimation"];
	[prefs registerBool:&enableHSAnimation default:YES forKey:@"enableHSAnimation"];
	[prefs registerBool:&enableSnowGroundLayer default:NO forKey:@"enableSnowGroundLayer"];

	if (enableLSAnimation) %init(Lockscreen);
	if (enableHSAnimation) %init(Homescreen);
}