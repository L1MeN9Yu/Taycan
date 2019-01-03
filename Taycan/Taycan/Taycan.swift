//
// Created by Mengyu Li on 2018-12-29.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation
import UIKit

private var horn: Horn.Type?

private let bundle = Bundle(identifier: "top.limengyu.Taycan")

private let targetName = { () -> String in
    let targetName = bundle?.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    return "<" + targetName + ">"
}()

public func setup(horn: Horn.Type?) {
    Taycan.horn = horn
    c_taycan_init()
}

func horn(returnCode: Int32, filename: String = #file, function: String = #function, line: Int = #line) {
    guard let c_message = c_taycan_message_form_return_code(returnCode) else { return }
    guard let message = String(cString: c_message, encoding: .utf8) else { return }
    let c_log_flat = c_taycan_log_flag_form_return_code(returnCode)
    guard let hornType = HornType(flag: c_log_flat) else { return }
    Taycan.horn?.whistle(type: hornType, message: message + " " + targetName, filename: filename, function: function, line: line)
}

func horn(message: String, hornType: HornType, filename: String = #file, function: String = #function, line: Int = #line) {
    Taycan.horn?.whistle(type: hornType, message: message + " " + targetName, filename: filename, function: function, line: line)
}


// MARK: - C Bridge
@_silgen_name("taycan_init")
private func c_taycan_init()

@_silgen_name("taycan_log_flag_form_return_code")
private func c_taycan_log_flag_form_return_code(_ return_code: Int32) -> UInt32

@_silgen_name("taycan_message_form_return_code")
private func c_taycan_message_form_return_code(_ return_code: Int32) -> UnsafePointer<Int8>?