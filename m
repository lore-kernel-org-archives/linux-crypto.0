From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 4/6] crypto: sha512-mb - Algorithm data structures
Date: Mon, 27 Jun 2016 10:20:07 -0700
Message-ID: <1467048009-2826-5-git-send-email-megha.dey@intel.com>
References: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

This patch introduces the data structures and prototypes of functions
needed for computing SHA512 hash using multi-buffer. Included are the
structures of the multi-buffer SHA512 job, job scheduler in C and x86
assembly.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h          | 130 ++++++++++
 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h          | 104 ++++++++
 .../crypto/sha512-mb/sha512_mb_mgr_datastruct.S    | 281 +++++++++++++++++++++
 3 files changed, 515 insertions(+)
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_datastruct.S

diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h b/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
new file mode 100644
index 0000000..9d4b2c8
--- /dev/null
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
@@ -0,0 +1,130 @@
+/*
+ * Header file for multi buffer SHA512 context
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2016 Intel Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  Contact Information:
+ *      Megha Dey <megha.dey@linux.intel.com>
+ *
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2016 Intel Corporation.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Intel Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SHA_MB_CTX_INTERNAL_H
+#define _SHA_MB_CTX_INTERNAL_H
+
+#include "sha512_mb_mgr.h"
+
+#define HASH_UPDATE          0x00
+#define HASH_FIRST           0x01
+#define HASH_LAST            0x02
+#define HASH_ENTIRE          0x03
+#define HASH_DONE            0x04
+#define HASH_FINAL           0x08
+
+#define HASH_CTX_STS_IDLE       0x00
+#define HASH_CTX_STS_PROCESSING 0x01
+#define HASH_CTX_STS_LAST       0x02
+#define HASH_CTX_STS_COMPLETE   0x04
+
+enum hash_ctx_error {
+	HASH_CTX_ERROR_NONE               =  0,
+	HASH_CTX_ERROR_INVALID_FLAGS      = -1,
+	HASH_CTX_ERROR_ALREADY_PROCESSING = -2,
+	HASH_CTX_ERROR_ALREADY_COMPLETED  = -3,
+};
+
+#define hash_ctx_user_data(ctx)  ((ctx)->user_data)
+#define hash_ctx_digest(ctx)     ((ctx)->job.result_digest)
+#define hash_ctx_processing(ctx) ((ctx)->status & HASH_CTX_STS_PROCESSING)
+#define hash_ctx_complete(ctx)   ((ctx)->status == HASH_CTX_STS_COMPLETE)
+#define hash_ctx_status(ctx)     ((ctx)->status)
+#define hash_ctx_error(ctx)      ((ctx)->error)
+#define hash_ctx_init(ctx) \
+	do { \
+		(ctx)->error = HASH_CTX_ERROR_NONE; \
+		(ctx)->status = HASH_CTX_STS_COMPLETE; \
+	} while (0)
+
+/* Hash Constants and Typedefs */
+#define SHA512_DIGEST_LENGTH          8
+#define SHA512_LOG2_BLOCK_SIZE        7
+
+#define SHA512_PADLENGTHFIELD_SIZE    16
+
+#ifdef SHA_MB_DEBUG
+#define assert(expr) \
+do { \
+	if (unlikely(!(expr))) { \
+		printk(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n", \
+		#expr, __FILE__, __func__, __LINE__); \
+	} \
+} while (0)
+#else
+#define assert(expr) do {} while (0)
+#endif
+
+struct sha512_ctx_mgr {
+	struct sha512_mb_mgr mgr;
+};
+
+/* typedef struct sha512_ctx_mgr sha512_ctx_mgr; */
+
+struct sha512_hash_ctx {
+	/* Must be at struct offset 0 */
+	struct job_sha512       job;
+	/* status flag */
+	int status;
+	/* error flag */
+	int error;
+
+	uint32_t        total_length;
+	const void      *incoming_buffer;
+	uint32_t        incoming_buffer_length;
+	uint8_t         partial_block_buffer[SHA512_BLOCK_SIZE * 2];
+	uint32_t        partial_block_buffer_length;
+	void            *user_data;
+};
+
+#endif
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr.h b/arch/x86/crypto/sha512-mb/sha512_mb_mgr.h
new file mode 100644
index 0000000..178f17e
--- /dev/null
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr.h
@@ -0,0 +1,104 @@
+/*
+ * Header file for multi buffer SHA512 algorithm manager
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2016 Intel Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  Contact Information:
+ *      Megha Dey <megha.dey@linux.intel.com>
+ *
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2016 Intel Corporation.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Intel Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __SHA_MB_MGR_H
+#define __SHA_MB_MGR_H
+
+#include <linux/types.h>
+
+#define NUM_SHA512_DIGEST_WORDS 8
+
+enum job_sts {STS_UNKNOWN = 0,
+	STS_BEING_PROCESSED = 1,
+	STS_COMPLETED =       2,
+	STS_INTERNAL_ERROR = 3,
+	STS_ERROR = 4
+};
+
+struct job_sha512 {
+	u8  *buffer;
+	u64  len;
+	u64  result_digest[NUM_SHA512_DIGEST_WORDS] __aligned(32);
+	enum job_sts status;
+	void   *user_data;
+};
+
+struct sha512_args_x4 {
+	uint64_t        digest[8][4];
+	uint8_t         *data_ptr[4];
+};
+
+struct sha512_lane_data {
+	struct job_sha512 *job_in_lane;
+};
+
+struct sha512_mb_mgr {
+	struct sha512_args_x4 args;
+
+	uint64_t lens[4];
+
+	/* each byte is index (0...7) of unused lanes */
+	uint64_t unused_lanes;
+	/* byte 4 is set to FF as a flag */
+	struct sha512_lane_data ldata[4];
+};
+
+#define SHA512_MB_MGR_NUM_LANES_AVX2 4
+
+void sha512_mb_mgr_init_avx2(struct sha512_mb_mgr *state);
+struct job_sha512 *sha512_mb_mgr_submit_avx2(struct sha512_mb_mgr *state,
+						struct job_sha512 *job);
+struct job_sha512 *sha512_mb_mgr_flush_avx2(struct sha512_mb_mgr *state);
+struct job_sha512 *sha512_mb_mgr_get_comp_job_avx2(struct sha512_mb_mgr *state);
+
+#endif
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_datastruct.S b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_datastruct.S
new file mode 100644
index 0000000..cf2636d
--- /dev/null
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_datastruct.S
@@ -0,0 +1,281 @@
+/*
+ * Header file for multi buffer SHA256 algorithm data structure
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2016 Intel Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  Contact Information:
+ *      Megha Dey <megha.dey@linux.intel.com>
+ *
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2016 Intel Corporation.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Intel Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+# Macros for defining data structures
+
+# Usage example
+
+#START_FIELDS   # JOB_AES
+###     name            size    align
+#FIELD  _plaintext,     8,      8       # pointer to plaintext
+#FIELD  _ciphertext,    8,      8       # pointer to ciphertext
+#FIELD  _IV,            16,     8       # IV
+#FIELD  _keys,          8,      8       # pointer to keys
+#FIELD  _len,           4,      4       # length in bytes
+#FIELD  _status,        4,      4       # status enumeration
+#FIELD  _user_data,     8,      8       # pointer to user data
+#UNION  _union,         size1,  align1, \
+#                       size2,  align2, \
+#                       size3,  align3, \
+#                       ...
+#END_FIELDS
+#%assign _JOB_AES_size  _FIELD_OFFSET
+#%assign _JOB_AES_align _STRUCT_ALIGN
+
+#########################################################################
+
+# Alternate "struc-like" syntax:
+#       STRUCT job_aes2
+#       RES_Q   .plaintext,     1
+#       RES_Q   .ciphertext,    1
+#       RES_DQ  .IV,            1
+#       RES_B   .nested,        _JOB_AES_SIZE, _JOB_AES_ALIGN
+#       RES_U   .union,         size1, align1, \
+#                               size2, align2, \
+#                               ...
+#       ENDSTRUCT
+#       # Following only needed if nesting
+#       %assign job_aes2_size   _FIELD_OFFSET
+#       %assign job_aes2_align  _STRUCT_ALIGN
+#
+# RES_* macros take a name, a count and an optional alignment.
+# The count in in terms of the base size of the macro, and the
+# default alignment is the base size.
+# The macros are:
+# Macro    Base size
+# RES_B     1
+# RES_W     2
+# RES_D     4
+# RES_Q     8
+# RES_DQ   16
+# RES_Y    32
+# RES_Z    64
+#
+# RES_U defines a union. It's arguments are a name and two or more
+# pairs of "size, alignment"
+#
+# The two assigns are only needed if this structure is being nested
+# within another. Even if the assigns are not done, one can still use
+# STRUCT_NAME_size as the size of the structure.
+#
+# Note that for nesting, you still need to assign to STRUCT_NAME_size.
+#
+# The differences between this and using "struc" directly are that each
+# type is implicitly aligned to its natural length (although this can be
+# over-ridden with an explicit third parameter), and that the structure
+# is padded at the end to its overall alignment.
+#
+
+#########################################################################
+
+#ifndef _DATASTRUCT_ASM_
+#define _DATASTRUCT_ASM_
+
+#define PTR_SZ                  8
+#define SHA512_DIGEST_WORD_SIZE 8
+#define SHA512_MB_MGR_NUM_LANES_AVX2 4
+#define NUM_SHA512_DIGEST_WORDS 8
+#define SZ4                     4*SHA512_DIGEST_WORD_SIZE
+#define ROUNDS                  80*SZ4
+#define SHA512_DIGEST_ROW_SIZE  (SHA512_MB_MGR_NUM_LANES_AVX2 * 8)
+
+# START_FIELDS
+.macro START_FIELDS
+ _FIELD_OFFSET = 0
+ _STRUCT_ALIGN = 0
+.endm
+
+# FIELD name size align
+.macro FIELD name size align
+ _FIELD_OFFSET = (_FIELD_OFFSET + (\align) - 1) & (~ ((\align)-1))
+ \name  = _FIELD_OFFSET
+ _FIELD_OFFSET = _FIELD_OFFSET + (\size)
+.if (\align > _STRUCT_ALIGN)
+ _STRUCT_ALIGN = \align
+.endif
+.endm
+
+# END_FIELDS
+.macro END_FIELDS
+ _FIELD_OFFSET = (_FIELD_OFFSET + _STRUCT_ALIGN-1) & (~ (_STRUCT_ALIGN-1))
+.endm
+
+.macro STRUCT p1
+START_FIELDS
+.struc \p1
+.endm
+
+.macro ENDSTRUCT
+ tmp = _FIELD_OFFSET
+ END_FIELDS
+ tmp = (_FIELD_OFFSET - ##tmp)
+.if (tmp > 0)
+        .lcomm  tmp
+.endm
+
+## RES_int name size align
+.macro RES_int p1 p2 p3
+ name = \p1
+ size = \p2
+ align = .\p3
+
+ _FIELD_OFFSET = (_FIELD_OFFSET + (align) - 1) & (~ ((align)-1))
+.align align
+.lcomm name size
+ _FIELD_OFFSET = _FIELD_OFFSET + (size)
+.if (align > _STRUCT_ALIGN)
+ _STRUCT_ALIGN = align
+.endif
+.endm
+
+# macro RES_B name, size [, align]
+.macro RES_B _name, _size, _align=1
+RES_int _name _size _align
+.endm
+
+# macro RES_W name, size [, align]
+.macro RES_W _name, _size, _align=2
+RES_int _name 2*(_size) _align
+.endm
+
+# macro RES_D name, size [, align]
+.macro RES_D _name, _size, _align=4
+RES_int _name 4*(_size) _align
+.endm
+
+# macro RES_Q name, size [, align]
+.macro RES_Q _name, _size, _align=8
+RES_int _name 8*(_size) _align
+.endm
+
+# macro RES_DQ name, size [, align]
+.macro RES_DQ _name, _size, _align=16
+RES_int _name 16*(_size) _align
+.endm
+
+# macro RES_Y name, size [, align]
+.macro RES_Y _name, _size, _align=32
+RES_int _name 32*(_size) _align
+.endm
+
+# macro RES_Z name, size [, align]
+.macro RES_Z _name, _size, _align=64
+RES_int _name 64*(_size) _align
+.endm
+
+#endif
+
+###################################################################
+### Define SHA512 Out Of Order Data Structures
+###################################################################
+
+START_FIELDS    # LANE_DATA
+###     name            size    align
+FIELD   _job_in_lane,   8,      8       # pointer to job object
+END_FIELDS
+
+ _LANE_DATA_size = _FIELD_OFFSET
+ _LANE_DATA_align = _STRUCT_ALIGN
+
+####################################################################
+
+START_FIELDS    # SHA512_ARGS_X4
+###     name            size    align
+FIELD   _digest,        8*8*4,  4      # transposed digest
+FIELD   _data_ptr,      8*4,    8       # array of pointers to data
+END_FIELDS
+
+ _SHA512_ARGS_X4_size  =  _FIELD_OFFSET
+ _SHA512_ARGS_X4_align =  _STRUCT_ALIGN
+
+#####################################################################
+
+START_FIELDS    # MB_MGR
+###     name            size    align
+FIELD   _args,          _SHA512_ARGS_X4_size, _SHA512_ARGS_X4_align
+FIELD   _lens,          8*4,    8
+FIELD   _unused_lanes,  8,      8
+FIELD   _ldata,         _LANE_DATA_size*4, _LANE_DATA_align
+END_FIELDS
+
+ _MB_MGR_size  =  _FIELD_OFFSET
+ _MB_MGR_align =  _STRUCT_ALIGN
+
+_args_digest = _args + _digest
+_args_data_ptr = _args + _data_ptr
+
+#######################################################################
+
+#######################################################################
+#### Define constants
+#######################################################################
+
+#define STS_UNKNOWN             0
+#define STS_BEING_PROCESSED     1
+#define STS_COMPLETED           2
+
+#######################################################################
+#### Define JOB_SHA512 structure
+#######################################################################
+
+START_FIELDS    # JOB_SHA512
+###     name                            size    align
+FIELD   _buffer,                        8,      8       # pointer to buffer
+FIELD   _len,                           8,      8       # length in bytes
+FIELD   _result_digest,                 8*8,    32      # Digest (output)
+FIELD   _status,                        4,      4
+FIELD   _user_data,                     8,      8
+END_FIELDS
+
+ _JOB_SHA512_size = _FIELD_OFFSET
+ _JOB_SHA512_align = _STRUCT_ALIGN
-- 
1.9.1
