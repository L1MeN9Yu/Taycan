//
// Created by Mengyu Li on 2018-12-27.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation

public class Database {

    let db: UnsafeMutablePointer<UnsafeMutableRawPointer?>

    public init(path: String) {
        assert(path.count > 0, "文件路径不能为空")
        let size = MemoryLayout<UnsafeRawPointer>.size
        self.db = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: size)
        let rc = c_taycan_database_open_db(path.cString(using: .utf8), self.db)
        horn(returnCode: rc)
    }

    deinit {
        let rc = c_taycan_database_close(self.db.pointee)
        horn(returnCode: rc)
        self.db.pointee?.deallocate()
        self.db.deallocate()
    }
}

// MARK: - Store
extension Database {
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

        let rc = c_taycan_database_store(self.db.pointee, encodeKeyPtr, encodeKeyLength, encodeValuePtr, encodeValueLength)
        horn(returnCode: rc)
    }
}

// MARK: - Fetch
extension Database {
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

        let rc = c_taycan_database_fetch_sync(self.db.pointee, encodeKeyPtr, encodeKeyLength, valuePointer, &valueLength)
        horn(returnCode: rc)
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

// MARK: - Delete
extension Database {
    private func delete(key: Data) {
        let encodeKeyPtr = key.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
            return UnsafeRawPointer(pointer)
        }

        let encodeKeyLength = CUnsignedInt(key.count)

        let rc = c_taycan_database_delete(self.db.pointee, encodeKeyPtr, encodeKeyLength)
        horn(returnCode: rc)
    }
}

// MARK: - C Bridge
@_silgen_name("taycan_database_open_db")
public func c_taycan_database_open_db(_ path: UnsafePointer<Int8>?, _ db_ptr: UnsafeMutablePointer<UnsafeMutableRawPointer?>?) -> Int32

@_silgen_name("taycan_database_store")
public func c_taycan_database_store(_ db_ptr: UnsafeMutableRawPointer?, _ key: UnsafeRawPointer?, _ key_length: UInt32, _ value: UnsafeRawPointer?, _ value_length: UInt64) -> Int32

@_silgen_name("taycan_database_fetch_sync")
public func c_taycan_database_fetch_sync(_ db_ptr: UnsafeMutableRawPointer?, _ key: UnsafeRawPointer?, _ key_length: UInt32, _ value_ptr: UnsafeMutablePointer<UnsafeMutableRawPointer?>?, _ value_length: UnsafeMutablePointer<UInt64>?) -> Int32

@_silgen_name("taycan_database_delete")
public func c_taycan_database_delete(_ db_ptr: UnsafeMutableRawPointer?, _ key: UnsafeRawPointer?, _ key_length: UInt32) -> Int32

@_silgen_name("taycan_database_close")
public func c_taycan_database_close(_ db_ptr: UnsafeMutableRawPointer?) -> Int32