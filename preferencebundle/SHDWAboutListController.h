#import <Foundation/Foundation.h>
#import <Preferences/PSListController.h>

@interface SHDWAboutListController : PSListController
- (NSString *)aboutBypassVersion:(id)sender;
- (NSString *)aboutAPIVersion:(id)sender;
- (NSString *)aboutBuildDate:(id)sender;
- (NSString *)aboutSoftwareLicense:(id)sender;
- (NSString *)aboutDeveloper:(id)sender;
- (NSString *)aboutPackageVersion:(id)sender;
- (NSString *)aboutLatestVersion:(id)sender;

- (void)openGitHub:(id)sender;
- (void)openKofi:(id)sender;
@end
