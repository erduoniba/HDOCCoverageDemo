//
//  HDCoverFramework.h
//  HDCoverFramework
//
//  Created by denglibing on 2021/10/15.
//

#import <Foundation/Foundation.h>

//! Project version number for HDCoverFramework.
FOUNDATION_EXPORT double HDCoverFrameworkVersionNumber;

//! Project version string for HDCoverFramework.
FOUNDATION_EXPORT const unsigned char HDCoverFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HDCoverFramework/PublicHeader.h>

#import "HDOCFramework.h"

int __llvm_profile_runtime = 0;
void __llvm_profile_initialize_file(void);
const char *__llvm_profile_get_filename();
void __llvm_profile_set_filename(const char *);
int __llvm_profile_write_file();
int __llvm_profile_register_write_file_atexit(void);
const char *__llvm_profile_get_path_prefix();
