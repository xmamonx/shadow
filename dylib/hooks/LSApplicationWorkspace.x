#import "hooks.h"

#import <MobileCoreServices/LSApplicationWorkspace.h>
#import <MobileCoreServices/LSApplicationProxy.h>
#import <MobileCoreServices/LSBundleProxy.h>

// use of LSApplicationWorkspace seems to be known for getting App Store rejected, but you never know...

%group shadowhook_LSApplicationWorkspace
%hook LSApplicationWorkspace
- (NSArray<LSApplicationProxy *> *)allApplications {
    NSArray<LSApplicationProxy *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<LSApplicationProxy *>* result_filtered = [NSMutableArray new];

        for(LSApplicationProxy* ap in result) {
            if(![_shadow isURLRestricted:[ap bundleURL]]) {
                [result_filtered addObject:ap];
            }
        }

        result = [result_filtered copy];
    }

    return result;
}

- (NSArray<LSApplicationProxy *> *)allInstalledApplications {
    NSArray<LSApplicationProxy *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<LSApplicationProxy *>* result_filtered = [NSMutableArray new];

        for(LSApplicationProxy* ap in result) {
            if(![_shadow isURLRestricted:[ap bundleURL]]) {
                [result_filtered addObject:ap];
            }
        }

        result = [result_filtered copy];
    }

    return result;
}

- (NSArray<LSApplicationProxy *> *)directionsApplications {
    NSArray<LSApplicationProxy *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<LSApplicationProxy *>* result_filtered = [NSMutableArray new];

        for(LSApplicationProxy* ap in result) {
            if(![_shadow isURLRestricted:[ap bundleURL]]) {
                [result_filtered addObject:ap];
            }
        }

        result = [result_filtered copy];
    }

    return result;
}

- (NSArray<LSApplicationProxy *> *)unrestrictedApplications {
    NSArray<LSApplicationProxy *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<LSApplicationProxy *>* result_filtered = [NSMutableArray new];

        for(LSApplicationProxy* ap in result) {
            if(![_shadow isURLRestricted:[ap bundleURL]]) {
                [result_filtered addObject:ap];
            }
        }

        result = [result_filtered copy];
    }

    return result;
}

- (NSArray<NSString *> *)installedApplications {
    NSArray<NSString *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<NSString *>* result_filtered = [NSMutableArray new];

        for(NSString* app_bundleId in result) {
            LSBundleProxy* app_bundle = [LSBundleProxy bundleProxyForIdentifier:app_bundleId];

            if(app_bundle) {
                if(![_shadow isURLRestricted:[app_bundle bundleURL]]) {
                    [result_filtered addObject:app_bundleId];
                }
            }
        }

        result = [result_filtered copy];
    }

    return result;
}

- (NSArray<LSApplicationProxy *> *)applicationsAvailableForHandlingURLScheme:(NSString *)urlScheme {
    if([[_shadow service] isURLSchemeRestricted:urlScheme] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        return @[];
    }

    return %orig;
}

- (NSArray<LSApplicationProxy *> *)applicationsAvailableForOpeningURL:(NSURL *)url {
    if([_shadow isURLRestricted:url] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        return @[];
    }

    return %orig;
}

- (NSArray<LSApplicationProxy *> *)applicationsAvailableForOpeningURL:(NSURL *)url legacySPI:(BOOL)legacySPI {
    if([_shadow isURLRestricted:url] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        return @[];
    }

    return %orig;
}

- (NSArray<NSString *> *)publicURLSchemes {
    NSArray<NSString *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<NSString *>* result_filtered = [NSMutableArray new];

        for(NSString* scheme in result) {
            if(![[_shadow service] isURLSchemeRestricted:scheme]) {
                [result_filtered addObject:scheme];
            }
        }

        result = [result_filtered copy];
    }

    return result;
}

- (NSArray<NSString *> *)privateURLSchemes {
    NSArray<NSString *>* result = %orig;

    if(result && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        NSMutableArray<NSString *>* result_filtered = [NSMutableArray new];

        for(NSString* scheme in result) {
            if(![[_shadow service] isURLSchemeRestricted:scheme]) {
                [result_filtered addObject:scheme];
            }
        }

        result = [result_filtered copy];
    }

    return result;
}
%end
%end

void shadowhook_LSApplicationWorkspace(HKBatchHook* hooks) {
    %init(shadowhook_LSApplicationWorkspace);
}
