//
//  taycan_external.h
//  Taycan
//
//  Created by Mengyu Li on 2018-12-29.
//  Copyright © 2018 Limengyu. All rights reserved.
//

#ifndef taycan_external_h
#define taycan_external_h

#include <stdio.h>
#include <stdbool.h>

extern
void
swift_log(
        unsigned int flag,
        const char *message,
        const char *file_name,
        const char *function,
        int line
);

/**
 * 初始化 taycan
 */
extern
void
taycan_init(
        void
);

extern
unsigned int
taycan_log_flag_form_return_code(
        int return_code
);

extern
const char *
taycan_message_form_return_code(
        int return_code
);

extern
bool
taycan_unqlite_is_multi_thread_enable(
        void
);

extern
int taycan_database_open_db(
        const char *path,
        void **db_ptr
);

extern
int
taycan_database_store(
        void *db_ptr,
        const void *key,
        unsigned int key_length,
        const void *value,
        unsigned long long value_length
);

extern
int
taycan_database_fetch_sync(
        void *db_ptr,
        const void *key,
        unsigned int key_length,
        void **value_ptr,
        unsigned long long *value_length
);

extern
int
taycan_database_delete(
        void *db_ptr,
        const void *key,
        unsigned int key_length
);

extern
int taycan_database_close(
        void *db_ptr
);

#endif /* taycan_external_h */
