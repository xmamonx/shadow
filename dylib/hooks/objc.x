#import "hooks.h"

// %group shadowhook_objc
// // %hookf(IMP, method_getImplementation, Method m) {
// //     IMP result = %orig;

// //     if(result) {
// //         const char* image_name = dyld_image_path_containing_address(result);

// //         if([_shadow isCPathRestricted:image_name] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
// //             return nil;
// //         }
// //     }

// //     return result;
// // }

// // %hookf(Method, class_getInstanceMethod, Class cls, SEL name) {
// //     Method result = %orig;

// //     if(result) {
// //         IMP impl = method_getImplementation(result);

// //         if(impl) {
// //             const char* image_name = dyld_image_path_containing_address(impl);

// //             if([_shadow isCPathRestricted:image_name] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
// //                 return nil;
// //             }
// //         }
// //     }

// //     return result;
// // }
// %end

static const char* (*original_class_getImageName)(Class cls);
static const char* replaced_class_getImageName(Class cls) {
    const char* result = original_class_getImageName(cls);

    if(result) {
        if([_shadow isCPathRestricted:result] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
            return NULL;
        }
    }

    return result;
}

// static Class (*original_objc_lookUpClass)(const char* name);
// static Class replaced_objc_lookUpClass(const char* name) {
//     Class result = original_objc_lookUpClass(name);

//     if(result) {
//         const char* image_name = original_class_getImageName(result);

//         if([_shadow isCPathRestricted:image_name] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
//             return nil;
//         }
//     }

//     return result;
// }

// static id (*original_objc_getClass)(const char* name);
// static id replaced_objc_getClass(const char* name) {
//     id result = original_objc_getClass(name);

//     if(result) {
//         const char* image_name = original_class_getImageName(result);

//         if([_shadow isCPathRestricted:image_name] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
//             return nil;
//         }
//     }

//     return result;
// }

// static Class (*original_objc_getMetaClass)(const char* name);
// static Class replaced_objc_getMetaClass(const char* name) {
//     Class result = original_objc_getMetaClass(name);

//     if(result) {
//         const char* image_name = original_class_getImageName(result);

//         if([_shadow isCPathRestricted:image_name] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
//             return nil;
//         }
//     }

//     return result;
// }

static const char * _Nonnull * (*original_objc_copyImageNames)(unsigned int *outCount);
static const char * _Nonnull * replaced_objc_copyImageNames(unsigned int *outCount) {
    const char * _Nonnull * result = original_objc_copyImageNames(outCount);

    if(result && *outCount && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
        const char* exec_name = _dyld_get_image_name(0);
        unsigned int i;

        for(i = 0; i < *outCount; i++) {
            if(strcmp(result[i], exec_name) == 0) {
                // Stop after app executable.
                *outCount = (i + 1);
                break;
            }
        }
    }

    return result;
}

static const char * _Nonnull * (*original_objc_copyClassNamesForImage)(const char* image, unsigned int *outCount);
static const char * _Nonnull * replaced_objc_copyClassNamesForImage(const char* image, unsigned int *outCount) {
    const char * _Nonnull * result = original_objc_copyClassNamesForImage(image, outCount);

    if(result) {
        if([_shadow isCPathRestricted:image] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
            if(outCount) {
                *outCount = 0;
            }

            return NULL;
        }
    }

    return result;
}

static Class (*original_NSClassFromString)(NSString* aClassName);
static Class replaced_NSClassFromString(NSString* aClassName) {
    Class result = original_NSClassFromString(aClassName);

    if(result && ![aClassName hasPrefix:@"NS"] && ![aClassName hasPrefix:@"UI"]) {
        const char* image_name = original_class_getImageName(result);

        if([_shadow isCPathRestricted:image_name] && ![_shadow isCallerTweak:[NSThread callStackReturnAddresses]]) {
            return nil;
        }
    }

    return result;
}

void shadowhook_objc(HKBatchHook* hooks) {
    // %init(shadowhook_objc);
    [hooks addFunctionHook:class_getImageName withReplacement:replaced_class_getImageName outOldPtr:(void **) &original_class_getImageName];
    [hooks addFunctionHook:objc_copyClassNamesForImage withReplacement:replaced_objc_copyClassNamesForImage outOldPtr:(void **) &original_objc_copyClassNamesForImage];
    [hooks addFunctionHook:objc_copyImageNames withReplacement:replaced_objc_copyImageNames outOldPtr:(void **) &original_objc_copyImageNames];
    // [hooks addFunctionHook:objc_getMetaClass withReplacement:replaced_objc_getMetaClass outOldPtr:(void **) &original_objc_getMetaClass];
    // [hooks addFunctionHook:objc_getClass withReplacement:replaced_objc_getClass outOldPtr:(void **) &original_objc_getClass];
    // [hooks addFunctionHook:objc_lookUpClass withReplacement:replaced_objc_lookUpClass outOldPtr:(void **) &original_objc_lookUpClass];
}

void shadowhook_objc_hidetweakclasses(HKBatchHook* hooks) {
    [hooks addFunctionHook:NSClassFromString withReplacement:replaced_NSClassFromString outOldPtr:(void **) &original_NSClassFromString];
}
