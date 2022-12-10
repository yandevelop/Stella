#import "SRPRootListController.h"

@implementation SRPAppearanceSettings

- (UIColor *)tintColor {
    return [UIColor colorWithRed: 0.67 green: 0.85 blue: 0.72 alpha: 1.00];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed: 0.69 green: 0.84 blue: 0.82 alpha: 1.00];
}
- (UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

- (UIColor *)tableViewCellSeparatorColor {
    return [UIColor colorWithWhite:0 alpha:0];
}

- (BOOL)translucentNavigationBar {
    return YES;
}

@end