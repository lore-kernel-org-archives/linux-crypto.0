From: Megha Dey <megha.dey@linux.intel.com>
Subject: [PATCH V8 2/5] crypto: AES CBC multi-buffer data structures
Date: Tue,  9 Jan 2018 16:09:05 -0800
Message-ID: <1515542948-24041-3-git-send-email-megha.dey@linux.intel.com>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
Cc: megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch introduces the data structures and prototypes of functions
needed for doing AES CBC encryption using multi-buffer. Included are
the structures of the multi-buffer AES CBC job, job scheduler in C and
data structure defines in x86 assembly code.

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h    |  97 +++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h    | 132 ++++++++++++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S | 271 +++++++++++++++++++++++++
 arch/x86/crypto/aes-cbc-mb/reg_sizes.S         | 126 ++++++++++++
 4 files changed, 626 insertions(+)
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h
 create mode 100644 arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/aes-cbc-mb/reg_sizes.S

diff --git a/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h b/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h
new file mode 100644
index 0000000..024586b
--- /dev/null
+++ b/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h
@@ -0,0 +1,97 @@
+/*
+ *	Header file for multi buffer AES CBC algorithm manager
+ *	that deals with 8 buffers at a time
+ *
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Tim Chen <tim.c.chen@linux.intel.com>
+ * Megha Dey <megha.dey@linux.intel.com>
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in
+ * the documentation and/or other materials provided with the
+ * distribution.
+ * Neither the name of Intel Corporation nor the names of its
+ * contributors may be used to endorse or promote products derived
+ * from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#ifndef __AES_CBC_MB_CTX_H
+#define __AES_CBC_MB_CTX_H
+
+
+#include <linux/types.h>
+
+#include "aes_cbc_mb_mgr.h"
+
+#define CBC_ENCRYPT	0x01
+#define CBC_DECRYPT	0x02
+#define CBC_START	0x04
+#define CBC_DONE	0x08
+
+#define CBC_CTX_STS_IDLE       0x00
+#define CBC_CTX_STS_PROCESSING 0x01
+#define CBC_CTX_STS_LAST       0x02
+#define CBC_CTX_STS_COMPLETE   0x04
+
+enum cbc_ctx_error {
+	CBC_CTX_ERROR_NONE               =  0,
+	CBC_CTX_ERROR_INVALID_FLAGS      = -1,
+	CBC_CTX_ERROR_ALREADY_PROCESSING = -2,
+	CBC_CTX_ERROR_ALREADY_COMPLETED  = -3,
+};
+
+#define cbc_ctx_init(ctx, n_bytes, op) \
+	do { \
+		(ctx)->flag = (op) | CBC_START; \
+		(ctx)->nbytes = (n_bytes); \
+	} while (0)
+
+/* AESNI routines to perform cbc decrypt and key expansion */
+
+asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+			     unsigned int key_len);
+
+#endif /* __AES_CBC_MB_CTX_H */
diff --git a/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h b/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h
new file mode 100644
index 0000000..788180e
--- /dev/null
+++ b/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h
@@ -0,0 +1,132 @@
+/*
+ *	Header file for multi buffer AES CBC algorithm manager
+ *	that deals with 8 buffers at a time
+ *
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Tim Chen <tim.c.chen@linux.intel.com>
+ * Megha Dey <megha.dey@linux.intel.com>
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in
+ * the documentation and/or other materials provided with the
+ * distribution.
+ * Neither the name of Intel Corporation nor the names of its
+ * contributors may be used to endorse or promote products derived
+ * from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#ifndef __AES_CBC_MB_MGR_H
+#define __AES_CBC_MB_MGR_H
+
+
+#include <linux/types.h>
+#include <linux/printk.h>
+#include <crypto/aes.h>
+#include <crypto/b128ops.h>
+
+#define MAX_AES_JOBS		128
+
+enum job_sts {
+	STS_UNKNOWN = 0,
+	STS_BEING_PROCESSED = 1,
+	STS_COMPLETED = 2,
+	STS_INTERNAL_ERROR = 3,
+	STS_ERROR = 4
+};
+
+/* AES CBC multi buffer in order job structure */
+
+struct job_aes_cbc {
+	u8	*plaintext;	/* pointer to plaintext */
+	u8	*ciphertext;	/* pointer to ciphertext */
+	u128	iv;		/* initialization vector */
+	u128	*keys;		/* pointer to keys */
+	u32	len;		/* length in bytes, must be multiple of 16 */
+	enum	job_sts status;	/* status enumeration */
+	void	*user_data;	/* pointer to user data */
+	u32	key_len;	/* key length */
+};
+
+struct aes_cbc_args_x8 {
+	u8	*arg_in[8];	/* array of 8 pointers to in text */
+	u8	*arg_out[8];	/* array of 8 pointers to out text */
+	u128	*arg_keys[8];	/* array of 8 pointers to keys */
+	u128	arg_iv[8] __aligned(16);	/* array of 8 128-bit IVs */
+};
+
+struct aes_cbc_mb_mgr_inorder_x8 {
+	struct aes_cbc_args_x8 args;
+	u16 lens[8] __aligned(16);
+	u64 unused_lanes; /* each nibble is index (0...7) of unused lanes */
+	/* nibble 8 is set to F as a flag */
+	struct job_aes_cbc *job_in_lane[8];
+	/* In-order components */
+	u32 earliest_job; /* byte offset, -1 if none */
+	u32 next_job;      /* byte offset */
+	struct job_aes_cbc jobs[MAX_AES_JOBS];
+};
+
+/* define AES CBC multi buffer manager function proto */
+struct job_aes_cbc *aes_cbc_submit_job_inorder_128x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+struct job_aes_cbc *aes_cbc_submit_job_inorder_192x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+struct job_aes_cbc *aes_cbc_submit_job_inorder_256x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+struct job_aes_cbc *aes_cbc_flush_job_inorder_x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+struct job_aes_cbc *aes_cbc_get_next_job_inorder_x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+struct job_aes_cbc *aes_cbc_get_completed_job_inorder_x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+void aes_cbc_init_mb_mgr_inorder_x8(
+	struct aes_cbc_mb_mgr_inorder_x8 *state);
+void aes_cbc_submit_job_ooo_x8(struct aes_cbc_mb_mgr_inorder_x8 *state,
+		struct job_aes_cbc *job);
+void aes_cbc_flush_job_ooo_x8(struct aes_cbc_mb_mgr_inorder_x8 *state);
+void aes_cbc_flush_job_ooo_128x8(struct aes_cbc_mb_mgr_inorder_x8 *state);
+void aes_cbc_flush_job_ooo_192x8(struct aes_cbc_mb_mgr_inorder_x8 *state);
+void aes_cbc_flush_job_ooo_256x8(struct aes_cbc_mb_mgr_inorder_x8 *state);
+
+#endif /* __AES_CBC_MB_MGR_H */
diff --git a/arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S b/arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S
new file mode 100644
index 0000000..6892893
--- /dev/null
+++ b/arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S
@@ -0,0 +1,271 @@
+/*
+ *	Header file: Data structure: AES CBC multibuffer optimization
+ *				(x86_64)
+ *
+ * This is the generic header file defining data stuctures for
+ * AES multi-buffer CBC implementation. This file is to be included
+ * by the AES CBC multibuffer scheduler.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Tim Chen <tim.c.chen@linux.intel.com>
+ * Megha Dey <megha.dey@linux.intel.com>
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in
+ * the documentation and/or other materials provided with the
+ * distribution.
+ * Neither the name of Intel Corporation nor the names of its
+ * contributors may be used to endorse or promote products derived
+ * from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+/* This is the AES CBC BY8 implementation */
+#define	NBY	8
+
+#define AES_KEYSIZE_128 16
+#define AES_KEYSIZE_192 24
+#define AES_KEYSIZE_256 32
+
+#ifndef _AES_CBC_MB_MGR_DATASTRUCT_ASM_
+#define _AES_CBC_MB_MGR_DATASTRUCT_ASM_
+
+/* Macros for defining data structures */
+
+/* Usage example */
+
+/*
+ * Alternate "struct-like" syntax:
+ *	STRUCT job_aes2
+ *	RES_Q	.plaintext,	1
+ *	RES_Q	.ciphertext,	1
+ *	RES_DQ	.IV,		1
+ *	RES_B	.nested,	_JOB_AES_SIZE, _JOB_AES_ALIGN
+ *	RES_U	.union,		size1, align1, \
+ *				size2, align2, \
+ *				...
+ *	ENDSTRUCT
+ *	; Following only needed if nesting
+ *	%assign job_aes2_size	_FIELD_OFFSET
+ *	%assign job_aes2_align	_STRUCT_ALIGN
+ *
+ * RES_* macros take a name, a count and an optional alignment.
+ * The count in terms of the base size of the macro, and the
+ * default alignment is the base size.
+ * The macros are:
+ * Macro    Base size
+ * RES_B	    1
+ * RES_W	    2
+ * RES_D     4
+ * RES_Q     8
+ * RES_DQ   16
+ * RES_Y    32
+ * RES_Z    64
+ *
+ * RES_U defines a union. It's arguments are a name and two or more
+ * pairs of "size, alignment"
+ *
+ * The two assigns are only needed if this structure is being nested
+ * within another. Even if the assigns are not done, one can still use
+ * STRUCT_NAME_size as the size of the structure.
+ *
+ * Note that for nesting, you still need to assign to STRUCT_NAME_size.
+ *
+ * The differences between this and using "struct" directly are that each
+ * type is implicitly aligned to its natural length (although this can be
+ * over-ridden with an explicit third parameter), and that the structure
+ * is padded at the end to its overall alignment.
+ *
+ */
+
+/* START_FIELDS */
+
+.macro START_FIELDS
+_FIELD_OFFSET	=	0
+_STRUCT_ALIGN	=	0
+.endm
+
+/* FIELD name size align */
+.macro FIELD name, size, align
+
+	_FIELD_OFFSET = (_FIELD_OFFSET + (\align) - 1) & (~ ((\align)-1))
+	\name = _FIELD_OFFSET
+	_FIELD_OFFSET = _FIELD_OFFSET + (\size)
+	.if (\align > _STRUCT_ALIGN)
+		_STRUCT_ALIGN = \align
+	.endif
+.endm
+
+/* END_FIELDS */
+
+.macro END_FIELDS
+	_FIELD_OFFSET = \
+	(_FIELD_OFFSET + _STRUCT_ALIGN-1) & (~ (_STRUCT_ALIGN-1))
+.endm
+
+.macro STRUCT p1
+	START_FIELDS
+	.struct \p1
+.endm
+
+.macro ENDSTRUCT
+	tmp = _FIELD_OFFSET
+	END_FIELDS
+	tmp = (_FIELD_OFFSET - %%tmp)
+	.if (tmp > 0)
+		.lcomm	tmp
+.endif
+.endstruc
+.endm
+
+/* RES_int name size align */
+.macro RES_int p1, p2, p3
+	name = \p1
+	size = \p2
+	align = \p3
+
+	_FIELD_OFFSET = (_FIELD_OFFSET + (align) - 1) & (~ ((align)-1))
+	.align align
+	.lcomm name size
+	_FIELD_OFFSET = _FIELD_OFFSET + (size)
+	.if (align > _STRUCT_ALIGN)
+		_STRUCT_ALIGN = align
+	.endif
+.endm
+
+/* macro RES_B name, size [, align] */
+.macro RES_B _name, _size, _align=1
+	RES_int _name, _size, _align
+.endm
+
+/* macro RES_W name, size [, align] */
+.macro RES_W _name, _size, _align=2
+	RES_int _name, 2*(_size), _align
+.endm
+
+/* macro RES_D name, size [, align] */
+.macro RES_D _name, _size, _align=4
+	RES_int _name, 4*(_size), _align
+.endm
+
+/* macro RES_Q name, size [, align] */
+.macro RES_Q _name, _size, _align=8
+	RES_int _name, 8*(_size), _align
+.endm
+
+/* macro RES_DQ name, size [, align] */
+.macro RES_DQ _name, _size, _align=16
+	RES_int _name, 16*(_size), _align
+.endm
+
+/* macro RES_Y name, size [, align] */
+.macro RES_Y _name, _size, _align=32
+	RES_int _name, 32*(_size), _align
+.endm
+
+/*; macro RES_Z name, size [, align] */
+.macro RES_Z _name, _size, _align=64
+	RES_int _name, 64*(_size), _align
+.endm
+#endif /* _AES_CBC_MB_MGR_DATASTRUCT_ASM_ */
+
+/* Define JOB_AES structure */
+
+START_FIELDS	/* JOB_AES */
+/*	name		size	align	*/
+FIELD	_plaintext,	8,	8	/* pointer to plaintext */
+FIELD	_ciphertext,	8,	8	/* pointer to ciphertext */
+FIELD	_IV,		16,	8	/* IV */
+FIELD	_keys,		8,	8	/* pointer to keys */
+FIELD	_len,		4,	4	/* length in bytes */
+FIELD	_status,	4,	4	/* status enumeration */
+FIELD	_user_data,	8,	8	/* pointer to user data */
+FIELD	_key_len,	4,	8	/* key length */
+
+END_FIELDS
+
+_JOB_AES_size	=	_FIELD_OFFSET
+_JOB_AES_align	=	_STRUCT_ALIGN
+
+START_FIELDS	/* AES_ARGS_XX */
+/*	name		size	align	*/
+FIELD	_arg_in,	8*NBY, 8	/* [] of NBY pointers to in text */
+FIELD	_arg_out,	8*NBY, 8	/* [] of NBY pointers to out text */
+FIELD	_arg_keys,	8*NBY, 8	/* [] of NBY pointers to keys */
+FIELD	_arg_IV,	16*NBY, 16	/* [] of NBY 128-bit IV's */
+
+END_FIELDS
+
+_AES_ARGS_SIZE	=	_FIELD_OFFSET
+_AES_ARGS_ALIGN	=	_STRUCT_ALIGN
+
+START_FIELDS	/* MB_MGR_AES_INORDER_XX */
+/*	name		size	align				*/
+FIELD	_args,		_AES_ARGS_SIZE, _AES_ARGS_ALIGN
+FIELD	_lens,		16,	16	/* lengths */
+FIELD	_unused_lanes,	8,	8
+FIELD	_job_in_lane,	8*NBY,	8	/* [] of NBY pointers to jobs */
+
+FIELD	_earliest_job,	4,	4	/* -1 if none */
+FIELD	_next_job,	4,	4
+FIELD	_jobs,		_JOB_AES_size,	_JOB_AES_align	/*> 8, start of array */
+
+END_FIELDS
+
+/* size is not accurate because the arrays are not represented */
+
+_MB_MGR_AES_INORDER_align	=	_STRUCT_ALIGN
+
+_args_in	=	_args+_arg_in
+_args_out	=	_args+_arg_out
+_args_keys	=	_args+_arg_keys
+_args_IV	=	_args+_arg_IV
+
+
+#define STS_UNKNOWN		0
+#define STS_BEING_PROCESSED	1
+#define STS_COMPLETED		2
+#define STS_INTERNAL_ERROR	3
+#define STS_ERROR		4
+
+#define MAX_AES_JOBS		128
diff --git a/arch/x86/crypto/aes-cbc-mb/reg_sizes.S b/arch/x86/crypto/aes-cbc-mb/reg_sizes.S
new file mode 100644
index 0000000..eeff13c
--- /dev/null
+++ b/arch/x86/crypto/aes-cbc-mb/reg_sizes.S
@@ -0,0 +1,126 @@
+/*
+ *	Header file AES CBC multibuffer SSE optimization (x86_64)
+ *
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Tim Chen <tim.c.chen@linux.intel.com>
+ * Megha Dey <megha.dey@linux.intel.com>
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in
+ * the documentation and/or other materials provided with the
+ * distribution.
+ * Neither the name of Intel Corporation nor the names of its
+ * contributors may be used to endorse or promote products derived
+ * from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+/* define d and w variants for registers */
+
+#define	raxd	eax
+#define raxw	ax
+#define raxb	al
+
+#define	rbxd	ebx
+#define rbxw	bx
+#define rbxb	bl
+
+#define	rcxd	ecx
+#define rcxw	cx
+#define rcxb	cl
+
+#define	rdxd	edx
+#define rdxw	dx
+#define rdxb	dl
+
+#define	rsid	esi
+#define rsiw	si
+#define rsib	sil
+
+#define	rdid	edi
+#define rdiw	di
+#define rdib	dil
+
+#define	rbpd	ebp
+#define rbpw	bp
+#define rbpb	bpl
+
+#define ymm0x	%xmm0
+#define ymm1x	%xmm1
+#define ymm2x	%xmm2
+#define ymm3x	%xmm3
+#define ymm4x	%xmm4
+#define ymm5x	%xmm5
+#define ymm6x	%xmm6
+#define ymm7x	%xmm7
+#define ymm8x	%xmm8
+#define ymm9x	%xmm9
+#define ymm10x	%xmm10
+#define ymm11x	%xmm11
+#define ymm12x	%xmm12
+#define ymm13x	%xmm13
+#define ymm14x	%xmm14
+#define ymm15x	%xmm15
+
+#define CONCAT(a,b)	a##b
+#define DWORD(reg)	CONCAT(reg, d)
+#define WORD(reg)	CONCAT(reg, w)
+#define BYTE(reg)	CONCAT(reg, b)
+
+#define XWORD(reg)	CONCAT(reg,x)
+
+/* common macros */
+
+/* Generate a label to go to */
+.macro LABEL prefix, num
+\prefix\num\():
+.endm
+
+/*
+ * cond_jump ins, name, suffix
+ * ins - conditional jump instruction to execute
+ * name,suffix - concatenate to form the label to go to
+ */
+.macro cond_jump ins, name, suffix
+	\ins	\name\suffix
+.endm
-- 
1.9.1
