//
//  taycan_core.c
//  Taycan.Swift
//
//  Created by Mengyu Li on 2019-05-07.
//  Copyright © 2019 L1MeN9Yu. All rights reserved.
//

#include "taycan_core.h"
#include <lmdb/lmdb.h>

// environment

// database
void taycan_database_close(const void *environment, taycan_database_id database_id) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    mdb_dbi_close(mdb_environment, database_id);
}

int taycan_database_open(const void *transaction, const char *name, unsigned int flags, taycan_database_id *database_id) {
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    int result = mdb_dbi_open(mdb_transaction, name, flags, database_id);
    return result;
}

// transaction
int taycan_transaction_begin(const void *environment, const void *parent_transaction, unsigned int flags, void **transaction) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    MDB_txn *mdb_parent_transaction = (MDB_txn *) parent_transaction;
    MDB_txn *mdb_transaction;
    int result = mdb_txn_begin(mdb_environment, mdb_parent_transaction, flags, &mdb_transaction);
    *transaction = mdb_transaction;
    return result;
}

int taycan_transaction_commit(const void *transaction) {
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    int result = mdb_txn_commit(mdb_transaction);
    return result;
}

void taycan_transaction_abort(const void *transaction) {
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    mdb_txn_abort(mdb_transaction);
}
