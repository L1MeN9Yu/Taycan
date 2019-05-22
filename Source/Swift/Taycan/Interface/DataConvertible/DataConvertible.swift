//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

/// Any type conforming to the DataConvertible protocol can be used as both key and value in LMDB.
/// The protocol provides a default implementation, which will work for most Swift value types.
/// For other types, including reference counted ones, you may want to implement the conversion yourself.
public protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

extension DataConvertible where Self: ExpressibleByIntegerLiteral {

    public init?(data: Data) {
        var value: Self = 0
        guard data.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0) })
        self = value
    }

    public var data: Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}

extension Data: DataConvertible {
    public init?(data: Data) {
        self = data
    }

    public var data: Data {
        return self
    }
}

extension String: DataConvertible {
    public init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }

    public var data: Data {
        return self.data(using: .utf8)!
    }
}

extension Bool: DataConvertible {
    public init?(data: Data) {
        guard data.count == MemoryLayout<UInt8>.size else { return nil }
        self = data.withUnsafeBytes { $0.load(as: UInt8.self) } != 0
    }

    public var data: Data {
        var value: UInt8 = self ? 1 : 0
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

extension Date: DataConvertible {
    public init?(data: Data) {
        guard let timeInterval = TimeInterval(data: data) else {
            return nil
        }
        self = Date(timeIntervalSinceReferenceDate: timeInterval)
    }

    public var data: Data {
        return self.timeIntervalSinceReferenceDate.data
    }
}

extension Int: DataConvertible {
}

extension Float: DataConvertible {
}

extension Double: DataConvertible {
}

extension UInt: DataConvertible {
}

extension Int8: DataConvertible {
}

extension UInt8: DataConvertible {
}

extension Int16: DataConvertible {
}

extension UInt16: DataConvertible {
}

extension Int32: DataConvertible {
}

extension UInt32: DataConvertible {
}

extension Int64: DataConvertible {
}

extension UInt64: DataConvertible {
}
