//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

// MARK: - Database
public class Database {
    private let environment: Environment
    private var id: UInt32 = 0

    init(environment: Environment, name: String?, flags: Flags = []) throws {
        self.environment = environment

        try Transaction(environment: self.environment) { transaction -> Transaction.Action in
            let openStatus = taycan_database_open(transaction.handle, name?.cString(using: .utf8), UInt32(flags.rawValue), &id)
            guard openStatus == 0 else { throw TaycanError(returnCode: openStatus) }

            // Commit the open transaction.
            return .commit
        }
    }

    deinit {
        // Close the database.
        // http://lmdb.tech/doc/group__mdb.html#ga52dd98d0c542378370cd6b712ff961b5
        taycan_database_close(self.environment.handle, self.id)
    }
}

// MARK: - Public
extension Database {
    /// Returns a value from the database instantiated as type `V` for a key of type `K`.
    /// - parameter type: A type conforming to `DataConvertible` that you want to be instantiated with the value from the database.
    /// - parameter key: A key conforming to `DataConvertible` for which the value will be looked up.
    /// - returns: Returns the value as an instance of type `V` or `nil` if no value exists for the key or the type could not be instatiated with the data.
    /// - note: You can always use `Foundation.Data` as the type. In such case, `nil` will only be returned if there is no value for the key.
    /// - throws: an error if operation fails. See `TaycanError`.
    public func get<V: DataConvertible, K: DataConvertible>(type: V.Type, forKey key: K) throws -> V? {

//        let keyPointer = key.data.withUnsafeBytes { UnsafeMutableRawPointer(mutating: $0) }
//        var keyObject = taycan_object(size: key.data.count, data: keyPointer)

        let keyObject = Object(dataConvertible: key)

        // The database will manage the memory for the returned value.
        // http://104.237.133.194/doc/group__mdb.html#ga8bf10cd91d3f3a83a34d04ce6b07992d
        var dataVal: OpaquePointer?

        var getStatus: Int32 = 0

        try Transaction(environment: environment, flags: .readOnly) { transaction -> Transaction.Action in
            getStatus = taycan_database_get_value(transaction.handle, id, keyObject.pointer, &dataVal)
            return .commit
        }

        guard getStatus != TAYCAN_NOTFOUND else { return nil }

        let taycanObject = Object(pointer: dataVal)

        guard getStatus == 0, let data = taycanObject.data else { throw TaycanError(returnCode: getStatus) }

        let resultData = Data(bytes: data, count: taycanObject.size)
        return V(data: resultData)
    }

    /// Check if a value exists for the given key.
    /// - parameter key: The key to check for.
    /// - returns: `true` if the database contains a value for the key. `false` otherwise.
    /// - throws: an error if operation fails. See `TaycanError`.
    public func hasValue<K: DataConvertible>(forKey key: K) throws -> Bool {
        return try get(type: Data.self, forKey: key) != nil
    }

    /// Inserts a value into the database.
    /// - parameter value: The value to be put into the database. The value must conform to `DataConvertible`.
    /// - parameter key: The key which the data will be associated with. The key must conform to `DataConvertible`. Passing an empty key will cause an error to be thrown.
    /// - parameter flags: An optional set of flags that modify the behavior if the put operation. Default is [] (empty set).
    /// - throws: an error if operation fails. See `TaycanError`.
    public func put<V: DataConvertible, K: DataConvertible>(value: V, forKey key: K, flags: PutFlags = []) throws {

//        let keyPointer = key.data.withUnsafeBytes { UnsafeMutableRawPointer(mutating: $0) }
//        var keyObject = taycan_object(size: key.data.count, data: keyPointer)

        let keyObject = Object(dataConvertible: key)

//        let valuePointer = value.data.withUnsafeBytes { UnsafeMutableRawPointer(mutating: $0) }
//        var valueObject = taycan_object(size: value.data.count, data: valuePointer)
        let valueObject = Object(dataConvertible: value)

        var putStatus: Int32 = 0

        try Transaction(environment: environment) { transaction -> Transaction.Action in
            putStatus = taycan_database_put_value(transaction.handle, id, keyObject.pointer, valueObject.pointer, UInt32(flags.rawValue))
            return .commit
        }

        guard putStatus == 0 else { throw TaycanError(returnCode: putStatus) }
    }

    /// Deletes a value from the database.
    /// - parameter key: The key identifying the database entry to be deleted. The key must conform to `DataConvertible`. Passing an empty key will cause an error to be thrown.
    /// - throws: an error if operation fails. See `TaycanError`.
    public func deleteValue<K: DataConvertible>(forKey key: K) throws {

//        let keyPointer = key.data.withUnsafeBytes { UnsafeMutableRawPointer(mutating: $0) }
//        var keyObject = taycan_object(size: key.data.count, data: keyPointer)

        let keyObject = Object(dataConvertible: key)

        try Transaction(environment: environment) { transaction -> Transaction.Action in

            taycan_database_delete_value(transaction.handle, id, keyObject.pointer)
            return .commit
        }
    }

    /// Empties the database, removing all key/value pairs.
    /// The database remains open after being emptied and can still be used.
    /// - throws: an error if operation fails. See `TaycanError`.
    public func empty() throws {

        var dropStatus: Int32 = 0

        try Transaction(environment: environment, closure: { transaction -> Transaction.Action in
            dropStatus = taycan_database_drop(transaction.handle, id, 0)
            return .commit
        })

        guard dropStatus == 0 else { throw TaycanError(returnCode: dropStatus) }
    }

    /// Drops the database, deleting it (along with all it's contents) from the environment.
    /// - warning: Dropping a database also closes it. You may no longer use the database after dropping it.
    /// - seealso: `empty()`
    /// - throws: an error if operation fails. See `TaycanError`.
    public func drop() throws {

        var dropStatus: Int32 = 0

        try Transaction(environment: environment, closure: { transaction -> Transaction.Action in
            dropStatus = taycan_database_drop(transaction.handle, id, 1)
            return .commit
        })

        guard dropStatus == 0 else { throw TaycanError(returnCode: dropStatus) }
    }
}
