//
//  taycan_core.h
//  Taycan
//
//  Created by Mengyu Li on 2018-12-27.
//  Copyright © 2018 Limengyu. All rights reserved.
//

#ifndef taycan_core_h
#define taycan_core_h

#include <stdio.h>

/**
 * 打开或创建DB
 * @param path db的路径
 * @param db_ptr db的二级指针,外部自己持有
 * @return 0:成功
 */
int taycan_core_open_db(
        const char *path,
        void **db_ptr
);

int
taycan_core_store(
        void *db_ptr,
        const void *key,
        unsigned int key_length,
        const void *value,
        unsigned long long value_length
);

int
taycan_core_fetch_sync(
        void *db_ptr,
        const void *key,
        unsigned int key_length,
        void **value_ptr,
        unsigned long long *value_length
);

int
taycan_core_delete(
        void *db_ptr,
        const void *key,
        unsigned int key_length
);

int taycan_core_close(
        void *db_ptr
);

#endif /* taycan_core_h */
