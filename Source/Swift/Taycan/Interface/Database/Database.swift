//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

// MARK: - Database
public class Database {
    ///Database关联的environment
    private let environment: Environment
    ///Database的ID
    private var id: UInt32 = 0

    init(environment: Environment, name: String?, flags: Flags = []) throws {
        self.environment = environment

        try Transaction(environment: self.environment) { transaction -> Transaction.Action in
            let openStatus = taycan_database_open(transaction.handle, name?.cString(using: .utf8), UInt32(flags.rawValue), &id)
            guard openStatus == 0 else { throw TaycanError(returnCode: openStatus) }
            return .commit
        }
    }

    deinit {
        //关闭Database
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

        var getStatus: Int32 = 0
        var resultData: Data?

        try key.data.withUnsafePointer { pointer -> UnsafeRawPointer in
            let keyPointer = UnsafeRawPointer(pointer)

            var valuePointer: UnsafeMutableRawPointer?
            var valueSize: Int = 0

            try Transaction(environment: environment, flags: .readOnly) { transaction -> Transaction.Action in
                getStatus = taycan_database_get_value(transaction.handle, id, keyPointer, key.data.count, &valuePointer, &valueSize)
                return .commit
            }

            guard getStatus == 0, let data = valuePointer else { throw TaycanError(returnCode: getStatus) }

            resultData = Data(bytes: data, count: valueSize)

            return keyPointer
        }

        guard getStatus != TAYCAN_NOTFOUND else { return nil }

        guard let data = resultData else { return nil }

        return V(data: data)
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

        var putStatus: Int32 = 0

        try key.data.withUnsafePointer { pointer -> UnsafeRawPointer? in
            let keyPointer = UnsafeRawPointer(pointer)
            try value.data.withUnsafePointer { pointer -> UnsafeRawPointer in
                let valuePointer = UnsafeRawPointer(pointer)

                try Transaction(environment: environment) { transaction -> Transaction.Action in
                    putStatus = taycan_database_put_value(transaction.handle, id, keyPointer, key.data.count, valuePointer, value.data.count, UInt32(flags.rawValue))
                    return .commit
                }

                return valuePointer
            }
            return keyPointer
        }

        guard putStatus == 0 else { throw TaycanError(returnCode: putStatus) }
    }

    /// Deletes a value from the database.
    /// - parameter key: The key identifying the database entry to be deleted. The key must conform to `DataConvertible`. Passing an empty key will cause an error to be thrown.
    /// - throws: an error if operation fails. See `TaycanError`.
    public func deleteValue<K: DataConvertible>(forKey key: K) throws {

        try key.data.withUnsafePointer { pointer -> UnsafeRawPointer in
            let keyPointer = UnsafeRawPointer(pointer)

            try Transaction(environment: environment) { transaction -> Transaction.Action in
                taycan_database_delete_value(transaction.handle, id, keyPointer, key.data.count)
                return .commit
            }

            return keyPointer
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
