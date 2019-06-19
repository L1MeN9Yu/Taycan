//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

public class Environment {
    private(set) var handle: UnsafeRawPointer?

    /// Initializes a new environment instance. An environment may contain 0 or more databases.
    /// - parameter path: The path to the folder in which the environment should be created. The folder must exist and be writeable.
    /// - parameter flags: A set containing flags for the environment. See `Environment.Flags`
    /// - parameter maxDBs: The maximum number of named databases that can be opened in the environment. It is recommended to keep a "moderate amount" and not a "huge number" of databases in a given environment. Default is 0, preventing any named database from being opened.
    /// - parameter maxReaders: The maximum number of threads/reader slots. Default is 126.
    /// - parameter mapSize: The size of the memory map. The value should be a multiple of the OS page size. Default is 10485760 bytes. See http://104.237.133.194/doc/group__mdb.html#gaa2506ec8dab3d969b0e609cd82e619e5 for more.
    /// - throws: an error if operation fails. See `TaycanError`.
    public init(path: String, flags: Flags = [], maxDBs: UInt32? = 1, maxReaders: UInt32? = nil, mapSize: size_t? = nil) throws {

        // Prepare the environment.
        var internalPointer: UnsafeMutableRawPointer?
        let envCreateStatus = taycan_environment_create(&internalPointer)
        handle = UnsafeRawPointer(internalPointer)

        guard envCreateStatus == 0 else { throw TaycanError(returnCode: envCreateStatus) }

        // Set the maximum number of named databases that can be opened in the environment.
        if let maxDBs = maxDBs {
            let envSetMaxDBsStatus = taycan_environment_set_max_databases(handle, maxDBs)
            guard envSetMaxDBsStatus == 0 else { throw TaycanError(returnCode: envSetMaxDBsStatus) }
        }

        // Set the maximum number of threads/reader slots for the environment.
        if let maxReaders = maxReaders {
            let envSetMaxReadersStatus = taycan_environment_set_max_readers(handle, maxReaders)
            guard envSetMaxReadersStatus == 0 else { throw TaycanError(returnCode: envSetMaxReadersStatus) }
        }

        // Set the size of the memory map.
        if let mapSize = mapSize {
            let envSetMapSizeStatus = taycan_environment_set_map_size(handle, mapSize)
            guard envSetMapSizeStatus == 0 else { throw TaycanError(returnCode: envSetMapSizeStatus) }
        }

        // Open the environment.
        let DEFAULT_FILE_MODE: mode_t = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH // 755

        // TODO: Let user specify file mode
        let envOpenStatus = taycan_environment_open(handle, path.cString(using: .utf8), UInt32(flags.rawValue), DEFAULT_FILE_MODE)

        guard envOpenStatus == 0 else {
            // Close the environment handle.
            taycan_environment_close(handle)
            throw TaycanError(returnCode: envOpenStatus)
        }
    }

    deinit {
        // Close the handle when environment is deallocated.
        taycan_environment_close(handle)
    }
}

extension Environment {
    /// Opens a database in the environment.
    /// - parameter name: The name of the database or `nil` if the unnamed/anonymous database in the environment should be used.
    /// - note: The parameter `maxDBs` supplied when instantiating the environment determines how many named databases can be opened inside the environment.
    /// - throws: an error if operation fails. See `LMDBError`.
    public func openDatabase(named name: String? = nil, flags: Database.Flags = []) throws -> Database {
        return try Database(environment: self, name: name, flags: flags)
    }
}
