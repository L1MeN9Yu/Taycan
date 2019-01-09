//
//  taycan_external.c
//  Taycan
//
//  Created by Mengyu Li on 2018-12-29.
//  Copyright © 2018 Limengyu. All rights reserved.
//

#include "taycan_external.h"
#include "taycan_log.h"
#include "taycan_core.h"

static
void
taycan_log(
        taycan_log_flag flag,
        const char *message,
        const char *file_name,
        const char *function,
        int line
);

void
taycan_init(
        void
) {
    config_log_callback(&taycan_log);
    taycan_core_init();
}

unsigned int
taycan_log_flag_form_return_code(
        int return_code
) {
    return taycan_core_log_flag_form_return_code(return_code);
}

const char *
taycan_message_form_return_code(
        int return_code
) {
    return taycan_core_message_form_return_code(return_code);
}

bool
taycan_unqlite_is_multi_thread_enable(
        void
) {
    return taycan_core_multi_thread_enable();
}

static
void
taycan_log(
        taycan_log_flag flag,
        const char *message,
        const char *file_name,
        const char *function,
        int line
) {
    swift_log(flag, message, file_name, function, line);
}


int taycan_database_open_db(
        const char *path,
        void **db_ptr
) {
    return taycan_core_open_db(path, db_ptr);
}

int
taycan_database_store(
        void *db_ptr,
        const void *key,
        unsigned int key_length,
        const void *value,
        unsigned long long value_length
) {
    return taycan_core_store(db_ptr, key, key_length, value, value_length);
}

int
taycan_database_fetch_sync(
        void *db_ptr,
        const void *key,
        unsigned int key_length,
        void **value_ptr,
        unsigned long long *value_length
) {
    return taycan_core_fetch_sync(db_ptr, key, key_length, value_ptr, value_length);
}

int
taycan_database_delete(
        void *db_ptr,
        const void *key,
        unsigned int key_length
) {
    return taycan_core_delete(db_ptr, key, key_length);
}

int taycan_database_close(
        void *db_ptr
) {
    return taycan_core_close(db_ptr);
}