//
//  taycan_core.c
//  Taycan
//
//  Created by Mengyu Li on 2018-12-27.
//  Copyright © 2018 Limengyu. All rights reserved.
//

#include "taycan_core.h"
#include "unqlite.h"
#include <stdlib.h>

typedef unsigned int i;

static int taycan_core_fetch_callback(const void *value, unsigned int length, void *p_user_data);

int taycan_core_open_db(const char *path, void **db_ptr) {
    unqlite *db;
    int rc;
    rc = unqlite_open(&db, path, UNQLITE_OPEN_CREATE);
    *db_ptr = db;
    return rc;
}

int taycan_core_store(void *db_ptr, const void *key, unsigned int key_length, const void *value, unsigned long long value_length) {
    unqlite *db = db_ptr;
    int rc;
    rc = unqlite_kv_store(db, key, key_length, value, value_length);
    if (rc != UNQLITE_OK) {
        return rc;
    }
    rc = unqlite_commit(db);
    return rc;
}

int
taycan_core_fetch_sync(void *db_ptr,
        const void *key,
        unsigned int key_length,
        void **value_ptr,
        unsigned long long *value_length) {
    unqlite *db = db_ptr;
    int rc;
    unqlite_int64 len;

    rc = unqlite_kv_fetch(db, key, key_length, NULL, &len);
    if (rc != UNQLITE_OK) {
        return rc;
    }

    void *value_buff = malloc((size_t) len);
    rc = unqlite_kv_fetch(db, key, key_length, value_buff, &len);

    if (rc != UNQLITE_OK) {
        return rc;
    }

    *value_ptr = value_buff;
    *value_length = (unsigned long long int) len;
    return rc;
}

static int taycan_core_fetch_callback(const void *value, unsigned int length, void *p_user_data) {

    return UNQLITE_OK;
}