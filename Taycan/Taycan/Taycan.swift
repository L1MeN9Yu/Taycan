//
// Created by Mengyu Li on 2018-12-29.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation

private var horn: Horn.Type?

public func setup(horn: Horn.Type?) {
    Taycan.horn = horn
}

func horn(returnCode: Int32, filename: String = #file, function: String = #function, line: Int = #line) {
    guard let c_message = taycan_core_message_form_return_code(returnCode) else { return }
    guard let message = String(cString: c_message, encoding: .utf8) else { return }
    let c_log_flat = taycan_core_log_flag_form_return_code(returnCode)
    guard let hornType = HornType(flag: c_log_flat) else { return }
    Taycan.horn?.whistle(type: hornType, message: message, filename: filename, function: function, line: line)
}
