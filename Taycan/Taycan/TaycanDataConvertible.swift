//
// Created by Mengyu Li on 2018-12-28.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation

public protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

public extension DataConvertible {
    public init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }

    public var data: Data {
        return Swift.withUnsafeBytes(of: self) { Data($0) }
    }
}

extension String: DataConvertible {
}

extension Bool: DataConvertible {
}

extension Int8: DataConvertible {
}

extension Int16: DataConvertible {
}

extension Int: DataConvertible {
}

extension Int32: DataConvertible {
}

extension Int64: DataConvertible {
}

extension UInt8: DataConvertible {
}

extension UInt16: DataConvertible {
}

extension UInt: DataConvertible {
}

extension UInt32: DataConvertible {
}

extension UInt64: DataConvertible {
}

extension Double: DataConvertible {
}

extension Float: DataConvertible {
}
