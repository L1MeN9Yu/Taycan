//
// Created by Mengyu Li on 2018-12-27.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation

public class TaycanDatabase {

    let db: UnsafeMutablePointer<UnsafeMutableRawPointer?>

    public init(name: String) {
        let size = MemoryLayout<UnsafeRawPointer>.size
        self.db = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: size)
        let path = NSTemporaryDirectory() + "\(name)"

        let rc = taycan_core_open_db(path.cString(using: .utf8), self.db)
        print("return code = \(rc)")
    }
}

// MARK: - Store
extension TaycanDatabase {
    public func store<keyType: Encodable, ValueType: Encodable>(encodableKey: keyType, encodableValue: ValueType) {
        guard let encodeKey = try? TaycanCoder.encoder.encode(encodableKey),
              let encodeValue = try? TaycanCoder.encoder.encode(encodableValue) else {
            //todo 报错
            return
        }

        self.store(key: encodeKey, value: encodeValue)
    }

    public func store<keyType: DataConvertible, ValueType: Encodable>(key: keyType, encodableValue: ValueType) {
        guard let encodeValue = try? TaycanCoder.encoder.encode(encodableValue) else {
            //todo 报错
            return
        }
        let keyData = key.data

        self.store(key: keyData, value: encodeValue)
    }

    public func store<keyType: DataConvertible, ValueType: DataConvertible>(key: keyType, value: ValueType) {

        let keyData = key.data
        let valueData = value.data

        self.store(key: keyData, value: valueData)
    }

    private func store(key: Data, value: Data) {
        let encodeKeyPtr = key.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            return UnsafeRawPointer(pointer)
        }

        let encodeKeyLength = CUnsignedInt(key.count)

        let encodeValuePtr = value.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            return UnsafeRawPointer(pointer)
        }

        let encodeValueLength = UInt64(value.count)

        let rc = taycan_core_store(self.db.pointee, encodeKeyPtr, encodeKeyLength, encodeValuePtr, encodeValueLength)
        print("return code = \(rc)")
    }
}

// MARK: - Fetch
extension TaycanDatabase {
    ///泛型返回,所以返回值必须指定类型,否则会编译失败
    public func fetchValue<KeyType: DataConvertible, ValueType: DataConvertible>(key: KeyType) -> ValueType? {
        let keyData = key.data
        guard let valueDate = self.fetch(key: keyData) else { return nil }
        let value = ValueType(data: valueDate)
        return value
    }

    public func fetchDecodableValue<KeyType: DataConvertible, ValueType: Decodable>(key: KeyType) -> ValueType? {
        let keyData = key.data
        guard let valueDate = self.fetch(key: keyData) else { return nil }

        let value = try? TaycanCoder.decoder.decode(ValueType.self, from: valueDate)
        return value
    }

    public func fetchDecodableValue<KeyType: Encodable, ValueType: Decodable>(encodableKey: KeyType) -> ValueType? {
        guard let keyData = try? TaycanCoder.encoder.encode(encodableKey) else { return nil }
        guard let valueDate = self.fetch(key: keyData) else { return nil }

        let value = try? TaycanCoder.decoder.decode(ValueType.self, from: valueDate)
        return value
    }

    private func fetch(key: Data) -> Data? {
        let encodeKeyPtr = key.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            return UnsafeRawPointer(pointer)
        }

        let encodeKeyLength = CUnsignedInt(key.count)

        let size = MemoryLayout<UnsafeRawPointer>.size
        let valuePointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: size)
        var valueLength: UInt64 = 0

        let rc = taycan_core_fetch_sync(self.db.pointee, encodeKeyPtr, encodeKeyLength, valuePointer, &valueLength)
        print("return code = \(rc)")
        if let rawPointer = valuePointer.pointee {
            let data = Data(bytes: rawPointer, count: Int(valueLength))
            rawPointer.deallocate()
            valuePointer.deallocate()
            return data
        }

        valuePointer.deallocate()
        return nil
    }
}