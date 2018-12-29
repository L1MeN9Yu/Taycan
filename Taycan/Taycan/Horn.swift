//
// Created by Mengyu Li on 2018-12-29.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation

public protocol Horn {
    static func whistle(type: HornType, message: String, filename: String, function: String, line: Int)
}

extension Horn {
    public static func whistle(type: HornType, message: String, filename: String, function: String, line: Int) {
        let allMessage = "[\(type.name)] ======>>>[\(URL(fileURLWithPath: filename).lastPathComponent):\(line)] \(function) - \(message)"
        print(allMessage)
    }
}

// MARK: - C Bridge
@_silgen_name("swift_log")
func c_log(_ flag: UInt32,
                   _ message: UnsafePointer<Int8>?,
                   _ file_name: UnsafePointer<Int8>?,
                   _ function: UnsafePointer<Int8>?,
                   _ line: Int32) {
    guard let c_message = message,
          let message = String(cString: c_message, encoding: .utf8),
          let type = HornType(flag: flag),
          let c_file_name = file_name,
          let filename = String(cString: c_file_name, encoding: .utf8),
          let c_function_name = function,
          let functionName = String(cString: c_function_name, encoding: .utf8) else {
        return
    }

    Taycan.horn(message: message, hornType: type, filename: filename, function: functionName, line: Int(line))
}

public enum HornType {
    case trace
    case debug
    case info
    case warning
    case error
    case fatalError

    init?(flag: CUnsignedInt) {
        switch flag {
        case 0:
            self = .trace
        case 1:
            self = .debug
        case 2:
            self = .info
        case 3:
            self = .warning
        case 4:
            self = .error
        case 5:
            self = .fatalError
        default:
            return nil
        }
    }

    public var name: String {
        switch self {
        case .trace:
            return "trace:"
        case .debug:
            return "debug:"
        case .info:
            return "info:"
        case .warning:
            return "warning:"
        case .error:
            return "error:"
        case .fatalError:
            return "fatalError:"
        }
    }
}