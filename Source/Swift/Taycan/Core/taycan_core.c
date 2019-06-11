//
//  taycan_core.c
//  Taycan.Swift
//
//  Created by Mengyu Li on 2019-05-07.
//  Copyright © 2019 L1MeN9Yu. All rights reserved.
//
#include <stdlib.h>

#include <lmdb/lmdb.h>
#include <string.h>

#include "taycan_core.h"

// Taycan Object
// Taycan Object
struct taycan_object {
    size_t size;
    const void *data;
};

taycan_object_ref taycan_object_create(const void *data, size_t size) {
    taycan_object_ref taycan_object = malloc(sizeof(taycan_object_ref));
    taycan_object->size = size;
    taycan_object->data = malloc(size);
    memcpy(taycan_object->data, data, size);
    return taycan_object;
}

void taycan_object_delete_pointer(taycan_object_ref taycan_object) {
    free((void *) taycan_object->data);
    free(taycan_object);
}

size_t taycan_object_pointer_size(taycan_object_ref taycan_object) {
    return taycan_object->size;
}

const void *taycan_object_pointer_data(taycan_object_ref taycan_object) {
    return taycan_object->data;
}

// Environment
int taycan_environment_create(void **environment) {
    MDB_env *env;
    int result = mdb_env_create(&env);
    *environment = env;
    return result;
}

int taycan_environment_open(const void *environment, const char *path, unsigned int flags, mode_t mode_type) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    int result = mdb_env_open(mdb_environment, path, flags, mode_type);
    return result;
}

int taycan_environment_set_map_size(const void *environment, size_t map_size) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    int result = mdb_env_set_mapsize(mdb_environment, map_size);
    return result;
}

int taycan_environment_set_max_readers(const void *environment, unsigned int max_readers) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    int result = mdb_env_set_maxreaders(mdb_environment, max_readers);
    return result;
}

int taycan_environment_set_max_databases(const void *environment, unsigned int max_databases) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    int result = mdb_env_set_maxdbs(mdb_environment, max_databases);
    return result;
}

void taycan_environment_close(const void *environment) {
    MDB_env *mdb_environment = (MDB_env *) environment;
    mdb_env_close(mdb_environment);
}

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

int taycan_database_drop(const void *transaction, taycan_database_id database_id, int is_delete) {
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    int result = mdb_drop(mdb_transaction, database_id, is_delete);
    return result;
}

// Key Value

int taycan_database_delete_value(const void *transaction, taycan_database_id database_id, taycan_object_ref key) {
//    MDB_val *mdb_key = taycan_mdb_val_create_from(key);
    MDB_val mdb_key;
    mdb_key.mv_data = (void *) key->data;
    mdb_key.mv_size = key->size;
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    int result = mdb_del(mdb_transaction, database_id, &mdb_key, NULL);
//    taycan_mdb_val_free(mdb_key);
    return result;
}

int taycan_database_put_value(const void *transaction, taycan_database_id database_id, taycan_object_ref key, taycan_object_ref value, unsigned int flags) {
//    MDB_val *mdb_key = taycan_mdb_val_create_from(key);
//    MDB_val *mdb_value = taycan_mdb_val_create_from(value);
    MDB_val mdb_key, mdb_value;
    mdb_key.mv_data = (void *) key->data;
    mdb_key.mv_size = key->size;
    mdb_value.mv_data = (void *) value->data;
    mdb_value.mv_size = value->size;
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    int result = mdb_put(mdb_transaction, database_id, &mdb_key, &mdb_value, flags);
//    taycan_mdb_val_free(mdb_key);
//    taycan_mdb_val_free(mdb_value);
    return result;
}

int taycan_database_get_value(const void *transaction, taycan_database_id database_id, taycan_object_ref key, taycan_object_ref *value) {
//    MDB_val *mdb_key = taycan_mdb_val_create_from(key);
    MDB_txn *mdb_transaction = (MDB_txn *) transaction;
    MDB_val mdb_key, mdb_value;
    mdb_key.mv_data = (void *) key->data;
    mdb_key.mv_size = key->size;
    int result = mdb_get(mdb_transaction, database_id, &mdb_key, &mdb_value);

    *value = taycan_object_create(mdb_value.mv_data, mdb_value.mv_size);
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
