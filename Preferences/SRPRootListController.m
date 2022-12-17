#import <Foundation/Foundation.h>
#import "SRPRootListController.h"

OBWelcomeController *welcomeController;

@implementation SRPRootListController

- (instancetype)init {
	self = [super init];

	if (self) {
		self.preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yan.stellarprefs"];

		self.navigationItem.titleView = [UIView new];

		self.enableSwitch = [UISwitch new];
		[self.enableSwitch addTarget:self action:@selector(enableSwitchChanged) forControlEvents:UIControlEventValueChanged];
		self.enableSwitch.onTintColor = [UIColor colorWithRed: 0.80 green: 0.87 blue: 0.86 alpha: 1.00];

		self.item = [[UIBarButtonItem alloc] initWithCustomView:self.enableSwitch];
		self.navigationItem.rightBarButtonItem = self.item;
		[self.navigationItem setRightBarButtonItem:self.item];

		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		self.titleLabel.text = @"Stella";
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		[self.navigationItem.titleView addSubview:self.titleLabel];

		self.appearanceSettings = [SRPAppearanceSettings new];
		self.hb_appearanceSettings = [self appearanceSettings];
		
		self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
		self.iconView.contentMode = UIViewContentModeScaleAspectFit;
		self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stellarprefs.bundle/icon.png"];
		self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
		self.iconView.alpha = 0.0;
		[self.navigationItem.titleView addSubview:self.iconView];

		self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stellarprefs.bundle/Banner.png"];
		self.headerImageView.clipsToBounds = YES;
		self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.headerView addSubview:self.headerImageView];
		
		[NSLayoutConstraint activateConstraints:@[
			[self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        	[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        	[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        	[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
			[self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
			[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
			[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
			[self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
			[self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
		]];
	}

	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat offsetY = scrollView.contentOffset.y;

	if (offsetY > 100) {
		[UIView animateWithDuration: 0.2 animations:^{
			self.iconView.alpha = 1.0;
			self.titleLabel.alpha = 0.0;
		}];
	} else if (offsetY > -100 && offsetY < 110) {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 0.0;
			self.titleLabel.alpha = 1.0;
		}];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 0.0;
			self.titleLabel.alpha = 0.0;
		}];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setEnabledState];
	if (![self.preferences objectForKey:@"didShowSWC"]) [self stellaWelcomeController];
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Stella"]];
	});
}

-(void)stellaWelcomeController {

    welcomeController = [[OBWelcomeController alloc] initWithTitle:@"Stella" detailText:@"let it snow" icon:[UIImage systemImageNamed:@"snowflake"]];

    [welcomeController addBulletedListItemWithTitle:@"Wintry feeling" description:@"Create your own winter wonderland." image:[UIImage systemImageNamed:@"wind.snow"]];
    [welcomeController addBulletedListItemWithTitle:@"Customizable" description:@"Change the properties of the snowflakes." image:[UIImage systemImageNamed:@"cloud.snow"]];
    [welcomeController addBulletedListItemWithTitle:@"Variety" description:@"Choose your own snowflakes." image:[UIImage systemImageNamed:@"photo"]];
	[welcomeController.buttonTray addCaptionText:@"developed with ❤️ by yan"];

    OBBoldTrayButton* continueButton = [OBBoldTrayButton buttonWithType:1];
    [continueButton addTarget:self action:@selector(dismissWelcomeController) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [continueButton setClipsToBounds:YES];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueButton.layer setCornerRadius:15];
	continueButton.backgroundColor = [UIColor colorWithRed: 0.67 green: 0.85 blue: 0.72 alpha: 1.00]; // somehow the title color is broken on iOS 15 so this is temporary (hopefully)
	continueButton.tintColor = [UIColor colorWithRed: 0.67 green: 0.85 blue: 0.72 alpha: 1.00];
	[welcomeController.buttonTray addButton:continueButton];
   

    welcomeController.modalPresentationStyle = UIModalPresentationPageSheet;
    welcomeController.modalInPresentation = NO;
    welcomeController.view.tintColor = [UIColor labelColor];
    [self presentViewController:welcomeController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)dismissWelcomeController {
    [welcomeController dismissViewControllerAnimated:YES completion:nil];
	[self.preferences setBool:YES forKey:@"didShowSWC"];
}

- (void)enableSwitchChanged {
	if ([[self.preferences objectForKey:@"enabled"] isEqual:@(YES)]) {
		[self.preferences setBool:NO forKey:@"enabled"];
	} else {
		[self.preferences setBool:YES forKey:@"enabled"];
	}
	[self respring];
}

- (void)setEnabledState {
	if ([[self.preferences objectForKey:@"enabled"] isEqual:@(YES)]) {
		[self.enableSwitch setOn:YES animated:YES];
	} else {
		[self.enableSwitch setOn:NO animated:YES];
	}
}
@end
