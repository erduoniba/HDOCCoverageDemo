//
//  InstrProfiling.h
//  HDCoverageDemo
//
//  Created by denglibing on 2021/10/20.
//

#ifndef PROFILE_INSTRPROFILING_H_
#define PROFILE_INSTRPROFILING_H_
int __llvm_profile_runtime = 0;
void __llvm_profile_initialize_file(void);
const char *__llvm_profile_get_filename();
void __llvm_profile_set_filename(const char *);
int __llvm_profile_write_file();
int __llvm_profile_register_write_file_atexit(void);
const char *__llvm_profile_get_path_prefix();
#endif /* PROFILE_INSTRPROFILING_H_ */
