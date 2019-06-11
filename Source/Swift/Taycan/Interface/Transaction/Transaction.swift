//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

public class Transaction {

    private(set) var handle: UnsafeRawPointer?

    /// Creates a new instance of Transaction and runs the closure provided.
    /// Depending on the result returned from the closure, the transaction will either be comitted or aborted.
    /// If an error is thrown from the transaction closure, the transaction is aborted.
    /// - parameter environment: The environment with which the transaction will be associated.
    /// - parameter parent: Transactions can be nested to unlimited depth. (WARNING: Not yet tested)
    /// - parameter flags: A set containing flags modifying the behavior of the transaction.
    /// - parameter closure: The closure in which database interaction should occur. When the closure returns, the transaction is ended.
    /// - throws: an error if operation fails. See `LMDBError`.
    @discardableResult
    init(environment: Environment, parent: Transaction? = nil, flags: Flags = [], closure: ((Transaction) throws -> Transaction.Action)) throws {

        // http://lmdb.tech/doc/group__mdb.html#gad7ea55da06b77513609efebd44b26920
        var internalHandler: UnsafeMutableRawPointer?
        let txnStatus = taycan_transaction_begin(environment.handle, parent?.handle, UInt32(flags.rawValue), &internalHandler)
        handle = UnsafeRawPointer(internalHandler)

        guard txnStatus == 0 else { throw TaycanError(returnCode: txnStatus) }

        // Run the closure inside a do/catch block, so we can abort the transaction if an error is thrown from the closure.
        do {
            let transactionResult = try closure(self)

            switch transactionResult {
            case .abort:
                taycan_transaction_abort(handle)
            case .commit:
                let commitStatus = taycan_transaction_commit(handle)
                guard commitStatus == 0 else {
                    throw TaycanError(returnCode: commitStatus)
                }
            }
        } catch {
            taycan_transaction_abort(handle)
            throw error
        }
    }
}
