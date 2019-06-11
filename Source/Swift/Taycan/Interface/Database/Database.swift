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

}
