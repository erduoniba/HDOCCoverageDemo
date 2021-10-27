//
//  Tools.swift
//  HDCoverageDemo
//
//  Created by denglibing on 2021/10/27.
//

import Foundation
import InstrProfiling


class Tools: NSObject {
    static var shared = Tools()
 
    func registerCoverage(moduleName: String) {
        let name = "\(moduleName).profraw"
        print("registerCoverage, moduleName: \(moduleName)")
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let filePath: NSString = documentDirectory.appendingPathComponent(name).path as NSString
            __llvm_profile_set_filename(filePath.utf8String)
        } catch {
            print(error)
        }
        
        saveAndUpload()
    }
    
    func saveAndUpload() {
        __llvm_profile_write_file()
    }
}
