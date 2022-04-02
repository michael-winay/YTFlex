#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "./FLEX/FLEX.h"

@interface YTCollectionViewCell : UICollectionViewCell
@end

@interface YTSettingsCell : YTCollectionViewCell
@end

@interface YTSettingsSectionItem : NSObject
@property BOOL hasSwitch;
@property BOOL switchVisible;
@property BOOL on;
@property BOOL (^switchBlock)(YTSettingsCell *, BOOL);
@property int settingItemId;
- (instancetype)initWithTitle:(NSString *)title titleDescription:(NSString *)titleDescription;
@end

%hook YTSettingsViewController
- (void)setSectionItems:(NSMutableArray <YTSettingsSectionItem *>*)sectionItems forCategory:(NSInteger)category title:(NSString *)title titleDescription:(NSString *)titleDescription headerHidden:(BOOL)headerHidden {
	if (category == 1) {
		YTSettingsSectionItem *flexToggle = [[%c(YTSettingsSectionItem) alloc] initWithTitle:@"Enable FLEX" titleDescription:@"Enables FLEX menu for debugging"];
		flexToggle.hasSwitch = YES;
		flexToggle.switchVisible = YES;
		flexToggle.on = ![[FLEXManager sharedManager] isHidden];
		flexToggle.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
			[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"flex_menu_enabled"];
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"flex_menu_enabled"]) {
        		[[FLEXManager sharedManager] showExplorer];
    		} 
    		else {
    			[[FLEXManager sharedManager] hideExplorer];
    		}
    		return YES;
		};
		[sectionItems addObject:flexToggle];
	}
	%orig(sectionItems, category, title, titleDescription, headerHidden);
}
%end

