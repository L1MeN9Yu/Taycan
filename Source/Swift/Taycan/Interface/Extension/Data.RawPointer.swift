//
// Created by Mengyu Li on 2019-06-12.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

extension Data {
    @discardableResult
    func withUnsafePointer<ResultType>(_ body: (UnsafePointer<UInt8>) throws -> ResultType) rethrows -> ResultType {
        return try withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) -> ResultType in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {
                var int: UInt8 = 0
                return try body(&int)
            }
            return try body(unsafePointer)
        }
    }

    @discardableResult
    mutating func withUnsafeMutablePointer<ResultType>(_ body: (UnsafeMutablePointer<UInt8>) throws -> ResultType) rethrows -> ResultType {
        return try withUnsafeMutableBytes { (rawBufferPointer: UnsafeMutableRawBufferPointer) -> ResultType in
            let unsafeMutableBufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let unsafeMutablePointer = unsafeMutableBufferPointer.baseAddress else {
                var int: UInt8 = 0
                return try body(&int)
            }
            return try body(unsafeMutablePointer)
        }
    }
}