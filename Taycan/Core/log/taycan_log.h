//
//  taycan_log.h
//  Taycan
//
//  Created by Mengyu Li on 2018-12-29.
//  Copyright © 2018 Limengyu. All rights reserved.
//

#ifndef taycan_log_h
#define taycan_log_h

#include <stdio.h>

typedef enum {
    taycan_log_flag_trace = 0,
    taycan_log_flag_debug,
    taycan_log_flag_info,
    taycan_log_flag_warning,
    taycan_log_flag_error,
    taycan_log_flag_fatal_error
} taycan_log_flag;

/**
 * 根据上层的return code返回对应的message
 * @param return_code returnCode
 * @return Message
 */
const char *
taycan_core_message_form_return_code(
        int return_code
);

/**
 * 根据上层的return code返回对应的log_flag
 * @param return_code return_code
 * @return taycan_log_flag
 */
unsigned int
taycan_core_log_flag_form_return_code(
        int return_code
);

/**
 * 设置log_callback桥接方法
 * @param log_callback 桥接方法
 */
void
config_log_callback(
        /**
         * log_callback桥接方法
         * @param flag taycan_log_flag
         * @param message log message
         * @param file_name 文件名
         * @param function 方法名
         * @param line 代码行数
         */
        void (*log_callback)(
                taycan_log_flag flag,
                const char *message,
                const char *file_name,
                const char *function,
                int line
        )
);

/**
 * taycan核心log方法
 * @param flag taycan_log_flag
 * @param file_name 文件名
 * @param function 方法名
 * @param line 代码行数
 * @param format format
 * @param ... ...
 */
void
taycan_core_log(
        taycan_log_flag flag,
        const char *file_name,
        const char *function,
        int line,
        const char *format, ...
);

#endif /* taycan_log_h */
