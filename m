Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA8AD529
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675257; cv=none; b=gVxLV8JYlrzqzWLHD0v6lavRJ0rAYQEHYXGmNFtg92RnKvyRFDw4IzEwunXRaPlUU8AwmKyuzx4v3RGwy9liHFQfe56/VXq1yefNIvUK+KelGzw2ovBb80JC3rFJ9hhrhVnsTTKUv4niK9CWlveWFHAj8t4ivPvqk7QMln/UcYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675257; c=relaxed/simple;
	bh=FgMRcSiz++yxQFbyjgHWDdvMPi0Me/uAuTDmDaziJdk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=WRcAu9Tv2RBOe2RAfcFN85LnLLE88xngFWHHos2ojPcumb/G0JID++qDv+c5nFOljyfKBVvi773VPhGerUM6WDBbs+4SitTmmItWmzqUwaKtuC4iFYihZ0JeOLGU2mEBkYxczFp1JoNob/dFgMgSVwGcwB4IAjPdqXxc4dA6X/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hVTG/IKs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hVTG/IKs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pRdl186KSm6UHqDbgX/MMif8LkpukCGpeS4TFYLpgEc=; b=hVTG/IKsKxK9CNsFPkjTpSxs3u
	rb68cuqAklLOhIzz12mIb9PZ0UJhefw46Tq5L0MMeDmgrjO83NLAT5EWeXYQGYJQWiMqFIztqv813
	C3JZfYTf0Nll8Nz3//gJWXryJnAHqZqNzgDRXkw2fZCF22liRhomhQFU0uMQIH27um2BbFKBGpOWf
	92pcQJ6WC3I2YM3DeENh7jrArK5Q2h1VOvdpMZB9lLgIrdAixrlPXminy8MP74FBQTcddFOsdl5wl
	oPSnklD9Bke7TufoylJIv5WQIKB8jL905Q9H7oQCiMz5K5e4G6g6gVkqBp3zFe2Y7oNY1uwA6RTGZ
	4xcNp0cQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnI-000gZj-10;
	Sun, 16 Feb 2025 11:07:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:29 +0800
Date: Sun, 16 Feb 2025 11:07:29 +0800
Message-Id: <e2bdd715fec3b2bc12d663e76315b3d4d5603980.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 08/11] crypto: x86/sha2 - Restore multibuffer AVX2 support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Resurrect the old multibuffer AVX2 code removed by commit ab8085c130ed
("crypto: x86 - remove SHA multibuffer routines and mcryptd") using
the new request chaining interface.

This is purely a proof of concept and only meant to illustrate the
utility of the new API rather than a serious attempt at improving
the performance.

However, it is interesting to note that with x8 multibuffer the
performance of AVX2 is on par with SHA-NI.

testing speed of multibuffer sha256 (sha256-avx2)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 1 operation in 184 cycles (16 bytes)
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 1 operation in 165 cycles (64 bytes)
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 1 operation in 444 cycles (256 bytes)
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates): 1 operation in 1549 cycles (1024 bytes)
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates): 1 operation in 3060 cycles (2048 bytes)
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 1 operation in 5983 cycles (4096 bytes)
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 1 operation in 11980 cycles (8192 bytes)
tcrypt: testing speed of async sha256 (sha256-avx2)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    475 cycles/operation,   29 cycles/byte
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    780 cycles/operation,   12 cycles/byte
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   1872 cycles/operation,    7 cycles/byte
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   5416 cycles/operation,    5 cycles/byte
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  10339 cycles/operation,    5 cycles/byte
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  20214 cycles/operation,    4 cycles/byte
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  40042 cycles/operation,    4 cycles/byte
tcrypt: testing speed of async sha256-ni (sha256-ni)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    207 cycles/operation,   12 cycles/byte
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    299 cycles/operation,    4 cycles/byte
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    543 cycles/operation,    2 cycles/byte
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1523 cycles/operation,    1 cycles/byte
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2835 cycles/operation,    1 cycles/byte
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   5459 cycles/operation,    1 cycles/byte
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  10724 cycles/operation,    1 cycles/byte

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/x86/crypto/Makefile                   |   2 +-
 arch/x86/crypto/sha256_mb_mgr_datastruct.S | 304 +++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c        | 540 +++++++++++++++++--
 arch/x86/crypto/sha256_x8_avx2.S           | 598 +++++++++++++++++++++
 4 files changed, 1401 insertions(+), 43 deletions(-)
 create mode 100644 arch/x86/crypto/sha256_mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/sha256_x8_avx2.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 07b00bfca64b..ab3fb2a9ebea 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -60,7 +60,7 @@ sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
 sha1-ssse3-$(CONFIG_AS_SHA1_NI) += sha1_ni_asm.o
 
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
-sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
+sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o sha256_x8_avx2.o
 sha256-ssse3-$(CONFIG_AS_SHA256_NI) += sha256_ni_asm.o
 
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
diff --git a/arch/x86/crypto/sha256_mb_mgr_datastruct.S b/arch/x86/crypto/sha256_mb_mgr_datastruct.S
new file mode 100644
index 000000000000..5c377bac21d0
--- /dev/null
+++ b/arch/x86/crypto/sha256_mb_mgr_datastruct.S
@@ -0,0 +1,304 @@
+/*
+ * Header file for multi buffer SHA256 algorithm data structure
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
+ *     Megha Dey <megha.dey@linux.intel.com>
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
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
+ */
+
+# Macros for defining data structures
+
+# Usage example
+
+#START_FIELDS	# JOB_AES
+###	name		size	align
+#FIELD	_plaintext,	8,	8	# pointer to plaintext
+#FIELD	_ciphertext,	8,	8	# pointer to ciphertext
+#FIELD	_IV,		16,	8	# IV
+#FIELD	_keys,		8,	8	# pointer to keys
+#FIELD	_len,		4,	4	# length in bytes
+#FIELD	_status,	4,	4	# status enumeration
+#FIELD	_user_data,	8,	8	# pointer to user data
+#UNION  _union,         size1,  align1, \
+#	                size2,  align2, \
+#	                size3,  align3, \
+#	                ...
+#END_FIELDS
+#%assign _JOB_AES_size	_FIELD_OFFSET
+#%assign _JOB_AES_align	_STRUCT_ALIGN
+
+#########################################################################
+
+# Alternate "struc-like" syntax:
+#	STRUCT job_aes2
+#	RES_Q	.plaintext,	1
+#	RES_Q	.ciphertext, 	1
+#	RES_DQ	.IV,		1
+#	RES_B	.nested,	_JOB_AES_SIZE, _JOB_AES_ALIGN
+#	RES_U	.union,		size1, align1, \
+#				size2, align2, \
+#				...
+#	ENDSTRUCT
+#	# Following only needed if nesting
+#	%assign job_aes2_size	_FIELD_OFFSET
+#	%assign job_aes2_align	_STRUCT_ALIGN
+#
+# RES_* macros take a name, a count and an optional alignment.
+# The count in in terms of the base size of the macro, and the
+# default alignment is the base size.
+# The macros are:
+# Macro    Base size
+# RES_B	    1
+# RES_W	    2
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
+#define SZ8			8*SHA256_DIGEST_WORD_SIZE
+#define ROUNDS			64*SZ8
+#define PTR_SZ                  8
+#define SHA256_DIGEST_WORD_SIZE 4
+#define MAX_SHA256_LANES        8
+#define SHA256_DIGEST_WORDS 8
+#define SHA256_DIGEST_ROW_SIZE  (MAX_SHA256_LANES * SHA256_DIGEST_WORD_SIZE)
+#define SHA256_DIGEST_SIZE      (SHA256_DIGEST_ROW_SIZE * SHA256_DIGEST_WORDS)
+#define SHA256_BLK_SZ           64
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
+ \name	= _FIELD_OFFSET
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
+########################################################################
+
+.macro STRUCT p1
+START_FIELDS
+.struc \p1
+.endm
+
+.macro ENDSTRUCT
+ tmp = _FIELD_OFFSET
+ END_FIELDS
+ tmp = (_FIELD_OFFSET - %%tmp)
+.if (tmp > 0)
+	.lcomm	tmp
+.endif
+.endstruc
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
+
+########################################################################
+#### Define SHA256 Out Of Order Data Structures
+########################################################################
+
+START_FIELDS    # LANE_DATA
+###     name            size    align
+FIELD   _job_in_lane,   8,      8       # pointer to job object
+END_FIELDS
+
+ _LANE_DATA_size = _FIELD_OFFSET
+ _LANE_DATA_align = _STRUCT_ALIGN
+
+########################################################################
+
+START_FIELDS    # SHA256_ARGS_X4
+###     name            size    align
+FIELD   _digest,        4*8*8,  4       # transposed digest
+FIELD   _data_ptr,      8*8,    8       # array of pointers to data
+END_FIELDS
+
+ _SHA256_ARGS_X4_size  =  _FIELD_OFFSET
+ _SHA256_ARGS_X4_align = _STRUCT_ALIGN
+ _SHA256_ARGS_X8_size  =	_FIELD_OFFSET
+ _SHA256_ARGS_X8_align =	_STRUCT_ALIGN
+
+#######################################################################
+
+START_FIELDS    # MB_MGR
+###     name            size    align
+FIELD   _args,          _SHA256_ARGS_X4_size, _SHA256_ARGS_X4_align
+FIELD   _lens,          4*8,    8
+FIELD   _unused_lanes,  8,      8
+FIELD   _ldata,         _LANE_DATA_size*8, _LANE_DATA_align
+END_FIELDS
+
+ _MB_MGR_size  =  _FIELD_OFFSET
+ _MB_MGR_align =  _STRUCT_ALIGN
+
+_args_digest   =     _args + _digest
+_args_data_ptr =     _args + _data_ptr
+
+#######################################################################
+
+START_FIELDS    #STACK_FRAME
+###     name            size    align
+FIELD   _data,		16*SZ8,   1       # transposed digest
+FIELD   _digest,         8*SZ8,   1       # array of pointers to data
+FIELD   _ytmp,           4*SZ8,   1
+FIELD   _rsp,            8,       1
+END_FIELDS
+
+ _STACK_FRAME_size  =  _FIELD_OFFSET
+ _STACK_FRAME_align =  _STRUCT_ALIGN
+
+#######################################################################
+
+########################################################################
+#### Define constants
+########################################################################
+
+#define STS_UNKNOWN             0
+#define STS_BEING_PROCESSED     1
+#define STS_COMPLETED           2
+
+########################################################################
+#### Define JOB_SHA256 structure
+########################################################################
+
+START_FIELDS    # JOB_SHA256
+
+###     name                            size    align
+FIELD   _buffer,                        8,      8       # pointer to buffer
+FIELD   _len,                           8,      8       # length in bytes
+FIELD   _result_digest,                 8*4,    32      # Digest (output)
+FIELD   _status,                        4,      4
+FIELD   _user_data,                     8,      8
+END_FIELDS
+
+ _JOB_SHA256_size = _FIELD_OFFSET
+ _JOB_SHA256_align = _STRUCT_ALIGN
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index e04a43d9f7d5..130918d01930 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -41,8 +41,24 @@
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
+struct sha256_x8_mbctx {
+	u32 state[8][8];
+	const u8 *input[8];
+};
+
+struct sha256_reqctx {
+	struct sha256_state state;
+	struct crypto_hash_walk walk;
+	const u8 *input;
+	int total;
+	unsigned int next;
+};
+
 asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
 				       const u8 *data, int blocks);
+asmlinkage void sha256_transform_rorx(struct sha256_state *state,
+				      const u8 *data, int blocks);
+asmlinkage void sha256_x8_avx2(struct sha256_x8_mbctx *mbctx, int blocks);
 
 static const struct x86_cpu_id module_cpu_ids[] = {
 #ifdef CONFIG_AS_SHA256_NI
@@ -55,14 +71,69 @@ static const struct x86_cpu_id module_cpu_ids[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
 
-static int _sha256_update(struct shash_desc *desc, const u8 *data,
-			  unsigned int len, sha256_block_fn *sha256_xform)
+static int sha256_import(struct ahash_request *req, const void *in)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
 
+	memcpy(&rctx->state, in, sizeof(rctx->state));
+	return 0;
+}
+
+static int sha256_export(struct ahash_request *req, void *out)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+
+	memcpy(out, &rctx->state, sizeof(rctx->state));
+	return 0;
+}
+
+static int sha256_ahash_init(struct ahash_request *req)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *r2;
+
+	sha256_init(&rctx->state);
+
+	if (!ahash_request_chained(req))
+		return 0;
+
+	req->base.err = 0;
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		r2->base.err = 0;
+		rctx = ahash_request_ctx(r2);
+		sha256_init(&rctx->state);
+	}
+
+	return 0;
+}
+
+static int sha224_ahash_init(struct ahash_request *req)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *r2;
+
+	sha224_init(&rctx->state);
+
+	if (!ahash_request_chained(req))
+		return 0;
+
+	req->base.err = 0;
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		rctx = ahash_request_ctx(r2);
+		sha224_init(&rctx->state);
+	}
+
+	return 0;
+}
+
+static void __sha256_update(struct sha256_state *sctx, const u8 *data,
+			   unsigned int len, sha256_block_fn *sha256_xform)
+{
 	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
-		return crypto_sha256_update(desc, data, len);
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE) {
+		sha256_update(sctx, data, len);
+		return;
+	}
 
 	/*
 	 * Make sure struct sha256_state begins directly with the SHA256
@@ -71,25 +142,97 @@ static int _sha256_update(struct shash_desc *desc, const u8 *data,
 	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
 
 	kernel_fpu_begin();
-	sha256_base_do_update(desc, data, len, sha256_xform);
+	lib_sha256_base_do_update(sctx, data, len, sha256_xform);
+	kernel_fpu_end();
+}
+
+static int _sha256_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len, sha256_block_fn *sha256_xform)
+{
+	__sha256_update(shash_desc_ctx(desc), data, len, sha256_xform);
+	return 0;
+}
+
+static int sha256_ahash_update(struct ahash_request *req,
+			       sha256_block_fn *sha256_xform)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_hash_walk *walk = &rctx->walk;
+	struct sha256_state *state = &rctx->state;
+	int nbytes;
+
+	/*
+	 * Make sure struct sha256_state begins directly with the SHA256
+	 * 256-bit internal state, as this is what the asm functions expect.
+	 */
+	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
+
+	for (nbytes = crypto_hash_walk_first(req, walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(walk, 0))
+		__sha256_update(state, walk->data, nbytes, sha256_xform);
+
+	return nbytes;
+}
+
+static void _sha256_finup(struct sha256_state *state, const u8 *data,
+			  unsigned int len, u8 *out, unsigned int ds,
+			  sha256_block_fn *sha256_xform)
+{
+	if (!crypto_simd_usable()) {
+		sha256_update(state, data, len);
+		if (ds == SHA224_DIGEST_SIZE)
+			sha224_final(state, out);
+		else
+			sha256_final(state, out);
+		return;
+	}
+
+	kernel_fpu_begin();
+	if (len)
+		lib_sha256_base_do_update(state, data, len, sha256_xform);
+	lib_sha256_base_do_finalize(state, sha256_xform);
 	kernel_fpu_end();
 
-	return 0;
+	lib_sha256_base_finish(state, out, ds);
+}
+
+static int sha256_ahash_finup(struct ahash_request *req, bool nodata,
+			      sha256_block_fn *sha256_xform)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_hash_walk *walk = &rctx->walk;
+	struct sha256_state *state = &rctx->state;
+	unsigned int ds;
+	int nbytes;
+
+	ds = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	if (nodata || !req->nbytes) {
+		_sha256_finup(state, NULL, 0, req->result,
+			      ds, sha256_xform);
+		return 0;
+	}
+
+	for (nbytes = crypto_hash_walk_first(req, walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(walk, 0)) {
+		if (crypto_hash_walk_last(walk)) {
+			_sha256_finup(state, walk->data, nbytes, req->result,
+				      ds, sha256_xform);
+			continue;
+		}
+
+		__sha256_update(state, walk->data, nbytes, sha256_xform);
+	}
+
+	return nbytes;
 }
 
 static int sha256_finup(struct shash_desc *desc, const u8 *data,
 	      unsigned int len, u8 *out, sha256_block_fn *sha256_xform)
 {
-	if (!crypto_simd_usable())
-		return crypto_sha256_finup(desc, data, len, out);
+	unsigned int ds = crypto_shash_digestsize(desc->tfm);
 
-	kernel_fpu_begin();
-	if (len)
-		sha256_base_do_update(desc, data, len, sha256_xform);
-	sha256_base_do_finalize(desc, sha256_xform);
-	kernel_fpu_end();
-
-	return sha256_base_finish(desc, out);
+	_sha256_finup(shash_desc_ctx(desc), data, len, out, ds, sha256_xform);
+	return 0;
 }
 
 static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
@@ -247,61 +390,374 @@ static void unregister_sha256_avx(void)
 				ARRAY_SIZE(sha256_avx_algs));
 }
 
-asmlinkage void sha256_transform_rorx(struct sha256_state *state,
-				      const u8 *data, int blocks);
-
-static int sha256_avx2_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int len)
+static int sha256_pad2(unsigned int partial, struct ahash_request *req)
 {
-	return _sha256_update(desc, data, len, sha256_transform_rorx);
+	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct sha256_state *state = &rctx->state;
+	__be64 *bits;
+
+	if (rctx->total)
+		return 0;
+
+	rctx->total = -1;
+
+	memset(state->buf + partial, 0, bit_offset - partial);
+	bits = (__be64 *)(state->buf + bit_offset);
+	*bits = cpu_to_be64(state->count << 3);
+
+	return SHA256_BLOCK_SIZE;
 }
 
-static int sha256_avx2_finup(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out)
+static int sha256_pad1(struct ahash_request *req, bool final)
 {
-	return sha256_finup(desc, data, len, out, sha256_transform_rorx);
+	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct sha256_state *state = &rctx->state;
+	unsigned int partial = state->count;
+
+	if (!final)
+		return 0;
+
+	rctx->total = 0;
+	rctx->input = state->buf;
+
+	partial %= SHA256_BLOCK_SIZE;
+	state->buf[partial++] = 0x80;
+
+	if (partial > bit_offset) {
+		memset(state->buf + partial, 0, SHA256_BLOCK_SIZE - partial);
+		return SHA256_BLOCK_SIZE;
+	}
+
+	return sha256_pad2(partial, req);
 }
 
-static int sha256_avx2_final(struct shash_desc *desc, u8 *out)
+static int sha256_mb_fill(struct ahash_request *req, bool final)
 {
-	return sha256_avx2_finup(desc, NULL, 0, out);
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct sha256_state *state = &rctx->state;
+	int nbytes = rctx->total;
+	unsigned int partial;
+
+	partial = state->count % SHA256_BLOCK_SIZE;
+	while (partial + nbytes < SHA256_BLOCK_SIZE) {
+		memcpy(state->buf + partial, rctx->input, nbytes);
+		state->count += nbytes;
+		partial += nbytes;
+
+		nbytes = crypto_hash_walk_done(&rctx->walk, 0);
+		if (!nbytes)
+			return sha256_pad1(req, final);
+
+		rctx->input = rctx->walk.data;
+		rctx->total = nbytes;
+	}
+
+	if (partial) {
+		unsigned int offset = SHA256_BLOCK_SIZE - partial;
+
+		memcpy(state->buf + partial, rctx->input, offset);
+		rctx->input = state->buf;
+
+		return SHA256_BLOCK_SIZE;
+	}
+
+	return nbytes;
 }
 
-static int sha256_avx2_digest(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out)
+static int sha256_mb_start(struct ahash_request *req, bool nodata, bool final)
 {
-	return sha256_base_init(desc) ?:
-	       sha256_avx2_finup(desc, data, len, out);
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	int nbytes;
+
+	nbytes = nodata ? 0 : crypto_hash_walk_first(req, &rctx->walk);
+	if (!nbytes)
+		return sha256_pad1(req, final);
+
+	rctx->input = rctx->walk.data;
+	rctx->total = nbytes;
+
+	return sha256_mb_fill(req, final);
 }
 
-static struct shash_alg sha256_avx2_algs[] = { {
-	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_base_init,
+static int sha256_mb_next(struct ahash_request *req, unsigned int len,
+			  bool final)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct sha256_state *state = &rctx->state;
+
+	if (rctx->input != state->buf)
+		;
+	else if (rctx->total <= 0)
+		return sha256_pad2(0, req);
+	else {
+		len = SHA256_BLOCK_SIZE - state->count % SHA256_BLOCK_SIZE;
+		rctx->input = rctx->walk.data;
+	}
+
+	rctx->input += len;
+	rctx->total -= len;
+	state->count += len;
+
+	return sha256_mb_fill(req, final);
+}
+
+static struct ahash_request *sha256_update_x8x1(
+	struct list_head *list, struct ahash_request *r2,
+	struct ahash_request *reqs[8], bool nodata, bool final)
+{
+	struct sha256_state *states[8];
+	struct sha256_x8_mbctx mbctx;
+	unsigned int len = 0;
+	int i = 0;
+
+	do {
+		struct sha256_reqctx *rctx = ahash_request_ctx(reqs[i]);
+		unsigned int nbytes;
+
+		nbytes = rctx->next;
+		if (!i || nbytes < len)
+			len = nbytes;
+
+		states[i] = &rctx->state;
+		mbctx.input[i] = rctx->input;
+	} while (++i < 8 && reqs[i]);
+
+	len &= ~(SHA256_BLOCK_SIZE - 1);
+
+	/* 3 is the break-even point for x8. */
+	if (i < 3) {
+		do {
+			i--;
+			sha256_transform_rorx(states[i], mbctx.input[i],
+					      len / SHA256_BLOCK_SIZE);
+		} while (i);
+		goto done;
+	}
+
+	for (; i < 8; i++) {
+		mbctx.input[i] = mbctx.input[0];
+		states[i] = NULL;
+	}
+
+	for (i = 0; i < 8; i++) {
+		int j;
+
+		for (j = 0; j < 8; j++)
+			mbctx.state[i][j] = states[j] ? states[j]->state[i] : 0;
+	}
+
+	sha256_x8_avx2(&mbctx, len / SHA256_BLOCK_SIZE);
+
+	for (i = 0; i < 8 && states[i]; i++) {
+		int j;
+
+		for (j = 0; j < 8; j++)
+			states[i]->state[j] = mbctx.state[j][i];
+	}
+
+done:
+	i = 0;
+	do {
+		struct sha256_reqctx *rctx = ahash_request_ctx(reqs[i]);
+
+		rctx->next = sha256_mb_next(reqs[i], len, final);
+
+		if (rctx->next) {
+			if (++i >= 8)
+				break;
+			continue;
+		}
+
+		if (i < 7 && reqs[i + 1]) {
+			memmove(reqs + i, reqs + i + 1, sizeof(r2) * (7 - i));
+			reqs[7] = NULL;
+			continue;
+		}
+
+		reqs[i] = NULL;
+
+		do {
+			while (!list_is_last(&r2->base.list, list)) {
+				r2 = list_next_entry(r2, base.list);
+				r2->base.err = 0;
+
+				rctx = ahash_request_ctx(r2);
+				rctx->next = sha256_mb_start(r2, nodata, final);
+				if (rctx->next) {
+					reqs[i] = r2;
+					break;
+				}
+			}
+		} while (reqs[i] && ++i < 8);
+
+		break;
+	} while (reqs[i]);
+
+	return r2;
+}
+
+static void sha256_update_x8(struct list_head *list,
+			     struct ahash_request *reqs[8], int i,
+			     bool nodata, bool final)
+{
+	struct ahash_request *r2 = reqs[i - 1];
+
+	do {
+		r2 = sha256_update_x8x1(list, r2, reqs, nodata, final);
+	} while (reqs[0]);
+}
+
+static void sha256_chain(struct ahash_request *req, bool nodata, bool final)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	struct ahash_request *reqs[8] = {};
+	struct ahash_request *r2;
+	int i;
+
+	req->base.err = 0;
+	reqs[0] = req;
+	rctx->next = sha256_mb_start(req, nodata, final);
+	i = !!rctx->next;
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		struct sha256_reqctx *r2ctx = ahash_request_ctx(r2);
+
+		r2->base.err = 0;
+
+		r2ctx = ahash_request_ctx(r2);
+		r2ctx->next = sha256_mb_start(r2, nodata, final);
+		if (!r2ctx->next)
+			continue;
+
+		reqs[i++] = r2;
+		if (i >= 8)
+			break;
+	}
+
+	if (i)
+		sha256_update_x8(&req->base.list, reqs, i, nodata, final);
+
+	if (!final)
+		return;
+
+	lib_sha256_base_finish(&rctx->state, req->result, ds);
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		struct sha256_reqctx *r2ctx = ahash_request_ctx(r2);
+
+		lib_sha256_base_finish(&r2ctx->state, r2->result, ds);
+	}
+}
+
+static int sha256_avx2_update(struct ahash_request *req)
+{
+	struct ahash_request *r2;
+	int err;
+
+	if (ahash_request_chained(req) && crypto_simd_usable()) {
+		sha256_chain(req, false, false);
+		return 0;
+	}
+
+	err = sha256_ahash_update(req, sha256_transform_rorx);
+	if (!ahash_request_chained(req))
+		return err;
+
+	req->base.err = err;
+
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		err = sha256_ahash_update(r2, sha256_transform_rorx);
+		r2->base.err = err;
+	}
+
+	return 0;
+}
+
+static int _sha256_avx2_finup(struct ahash_request *req, bool nodata)
+{
+	struct ahash_request *r2;
+	int err;
+
+	if (ahash_request_chained(req) && crypto_simd_usable()) {
+		sha256_chain(req, nodata, true);
+		return 0;
+	}
+
+	err = sha256_ahash_finup(req, nodata, sha256_transform_rorx);
+	if (!ahash_request_chained(req))
+		return err;
+
+	req->base.err = err;
+
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		err = sha256_ahash_finup(r2, nodata, sha256_transform_rorx);
+		r2->base.err = err;
+	}
+
+	return 0;
+}
+
+static int sha256_avx2_finup(struct ahash_request *req)
+{
+	return _sha256_avx2_finup(req, false);
+}
+
+static int sha256_avx2_final(struct ahash_request *req)
+{
+	return _sha256_avx2_finup(req, true);
+}
+
+static int sha256_avx2_digest(struct ahash_request *req)
+{
+	return sha256_ahash_init(req) ?:
+	       sha256_avx2_finup(req);
+}
+
+static int sha224_avx2_digest(struct ahash_request *req)
+{
+	return sha224_ahash_init(req) ?:
+	       sha256_avx2_finup(req);
+}
+
+static struct ahash_alg sha256_avx2_algs[] = { {
+	.halg.digestsize =	SHA256_DIGEST_SIZE,
+	.halg.statesize	=	sizeof(struct sha256_state),
+	.reqsize	=	sizeof(struct sha256_reqctx),
+	.init		=	sha256_ahash_init,
 	.update		=	sha256_avx2_update,
 	.final		=	sha256_avx2_final,
 	.finup		=	sha256_avx2_finup,
 	.digest		=	sha256_avx2_digest,
-	.descsize	=	sizeof(struct sha256_state),
-	.base		=	{
+	.import		=	sha256_import,
+	.export		=	sha256_export,
+	.halg.base	=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-avx2",
 		.cra_priority	=	170,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
+		.cra_flags	=	CRYPTO_ALG_REQ_CHAIN,
 	}
 }, {
-	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_base_init,
+	.halg.digestsize =	SHA224_DIGEST_SIZE,
+	.halg.statesize	=	sizeof(struct sha256_state),
+	.reqsize	=	sizeof(struct sha256_reqctx),
+	.init		=	sha224_ahash_init,
 	.update		=	sha256_avx2_update,
 	.final		=	sha256_avx2_final,
 	.finup		=	sha256_avx2_finup,
-	.descsize	=	sizeof(struct sha256_state),
-	.base		=	{
+	.digest		=	sha224_avx2_digest,
+	.import		=	sha256_import,
+	.export		=	sha256_export,
+	.halg.base	=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name =	"sha224-avx2",
 		.cra_priority	=	170,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
+		.cra_flags	=	CRYPTO_ALG_REQ_CHAIN,
 	}
 } };
 
@@ -317,7 +773,7 @@ static bool avx2_usable(void)
 static int register_sha256_avx2(void)
 {
 	if (avx2_usable())
-		return crypto_register_shashes(sha256_avx2_algs,
+		return crypto_register_ahashes(sha256_avx2_algs,
 				ARRAY_SIZE(sha256_avx2_algs));
 	return 0;
 }
@@ -325,7 +781,7 @@ static int register_sha256_avx2(void)
 static void unregister_sha256_avx2(void)
 {
 	if (avx2_usable())
-		crypto_unregister_shashes(sha256_avx2_algs,
+		crypto_unregister_ahashes(sha256_avx2_algs,
 				ARRAY_SIZE(sha256_avx2_algs));
 }
 
diff --git a/arch/x86/crypto/sha256_x8_avx2.S b/arch/x86/crypto/sha256_x8_avx2.S
new file mode 100644
index 000000000000..ce74f8963236
--- /dev/null
+++ b/arch/x86/crypto/sha256_x8_avx2.S
@@ -0,0 +1,598 @@
+/*
+ * Multi-buffer SHA256 algorithm hash compute routine
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
+ *	Megha Dey <megha.dey@linux.intel.com>
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
+#include <asm/frame.h>
+#include <linux/cfi_types.h>
+#include <linux/linkage.h>
+#include "sha256_mb_mgr_datastruct.S"
+
+## code to compute oct SHA256 using SSE-256
+## outer calling routine takes care of save and restore of XMM registers
+## Logic designed/laid out by JDG
+
+## Function clobbers: rax, rcx, rdx,   rbx, rsi, rdi, r9-r15; %ymm0-15
+## Linux clobbers:    rax rbx rcx rdx rsi            r9 r10 r11 r12 r13 r14 r15
+## Linux preserves:                       rdi rbp r8
+##
+## clobbers %ymm0-15
+
+arg1 = %rdi
+arg2 = %rsi
+reg3 = %rcx
+reg4 = %rdx
+
+# Common definitions
+STATE = arg1
+INP_SIZE = arg2
+
+IDX = %rax
+ROUND = %rbx
+TBL = reg3
+
+inp0 = %r9
+inp1 = %r10
+inp2 = %r11
+inp3 = %r12
+inp4 = %r13
+inp5 = %r14
+inp6 = %r15
+inp7 = reg4
+
+a = %ymm0
+b = %ymm1
+c = %ymm2
+d = %ymm3
+e = %ymm4
+f = %ymm5
+g = %ymm6
+h = %ymm7
+
+T1 = %ymm8
+
+a0 = %ymm12
+a1 = %ymm13
+a2 = %ymm14
+TMP = %ymm15
+TMP0 = %ymm6
+TMP1 = %ymm7
+
+TT0 = %ymm8
+TT1 = %ymm9
+TT2 = %ymm10
+TT3 = %ymm11
+TT4 = %ymm12
+TT5 = %ymm13
+TT6 = %ymm14
+TT7 = %ymm15
+
+# Define stack usage
+
+# Assume stack aligned to 32 bytes before call
+# Therefore FRAMESZ mod 32 must be 32-8 = 24
+
+#define FRAMESZ	0x388
+
+#define VMOVPS	vmovups
+
+# TRANSPOSE8 r0, r1, r2, r3, r4, r5, r6, r7, t0, t1
+# "transpose" data in {r0...r7} using temps {t0...t1}
+# Input looks like: {r0 r1 r2 r3 r4 r5 r6 r7}
+# r0 = {a7 a6 a5 a4   a3 a2 a1 a0}
+# r1 = {b7 b6 b5 b4   b3 b2 b1 b0}
+# r2 = {c7 c6 c5 c4   c3 c2 c1 c0}
+# r3 = {d7 d6 d5 d4   d3 d2 d1 d0}
+# r4 = {e7 e6 e5 e4   e3 e2 e1 e0}
+# r5 = {f7 f6 f5 f4   f3 f2 f1 f0}
+# r6 = {g7 g6 g5 g4   g3 g2 g1 g0}
+# r7 = {h7 h6 h5 h4   h3 h2 h1 h0}
+#
+# Output looks like: {r0 r1 r2 r3 r4 r5 r6 r7}
+# r0 = {h0 g0 f0 e0   d0 c0 b0 a0}
+# r1 = {h1 g1 f1 e1   d1 c1 b1 a1}
+# r2 = {h2 g2 f2 e2   d2 c2 b2 a2}
+# r3 = {h3 g3 f3 e3   d3 c3 b3 a3}
+# r4 = {h4 g4 f4 e4   d4 c4 b4 a4}
+# r5 = {h5 g5 f5 e5   d5 c5 b5 a5}
+# r6 = {h6 g6 f6 e6   d6 c6 b6 a6}
+# r7 = {h7 g7 f7 e7   d7 c7 b7 a7}
+#
+
+.macro TRANSPOSE8 r0 r1 r2 r3 r4 r5 r6 r7 t0 t1
+	# process top half (r0..r3) {a...d}
+	vshufps	$0x44, \r1, \r0, \t0 # t0 = {b5 b4 a5 a4   b1 b0 a1 a0}
+	vshufps	$0xEE, \r1, \r0, \r0 # r0 = {b7 b6 a7 a6   b3 b2 a3 a2}
+	vshufps	$0x44, \r3, \r2, \t1 # t1 = {d5 d4 c5 c4   d1 d0 c1 c0}
+	vshufps	$0xEE, \r3, \r2, \r2 # r2 = {d7 d6 c7 c6   d3 d2 c3 c2}
+	vshufps	$0xDD, \t1, \t0, \r3 # r3 = {d5 c5 b5 a5   d1 c1 b1 a1}
+	vshufps	$0x88, \r2, \r0, \r1 # r1 = {d6 c6 b6 a6   d2 c2 b2 a2}
+	vshufps	$0xDD, \r2, \r0, \r0 # r0 = {d7 c7 b7 a7   d3 c3 b3 a3}
+	vshufps	$0x88, \t1, \t0, \t0 # t0 = {d4 c4 b4 a4   d0 c0 b0 a0}
+
+	# use r2 in place of t0
+	# process bottom half (r4..r7) {e...h}
+	vshufps	$0x44, \r5, \r4, \r2 # r2 = {f5 f4 e5 e4   f1 f0 e1 e0}
+	vshufps	$0xEE, \r5, \r4, \r4 # r4 = {f7 f6 e7 e6   f3 f2 e3 e2}
+	vshufps	$0x44, \r7, \r6, \t1 # t1 = {h5 h4 g5 g4   h1 h0 g1 g0}
+	vshufps	$0xEE, \r7, \r6, \r6 # r6 = {h7 h6 g7 g6   h3 h2 g3 g2}
+	vshufps	$0xDD, \t1, \r2, \r7 # r7 = {h5 g5 f5 e5   h1 g1 f1 e1}
+	vshufps	$0x88, \r6, \r4, \r5 # r5 = {h6 g6 f6 e6   h2 g2 f2 e2}
+	vshufps	$0xDD, \r6, \r4, \r4 # r4 = {h7 g7 f7 e7   h3 g3 f3 e3}
+	vshufps	$0x88, \t1, \r2, \t1 # t1 = {h4 g4 f4 e4   h0 g0 f0 e0}
+
+	vperm2f128	$0x13, \r1, \r5, \r6  # h6...a6
+	vperm2f128	$0x02, \r1, \r5, \r2  # h2...a2
+	vperm2f128	$0x13, \r3, \r7, \r5  # h5...a5
+	vperm2f128	$0x02, \r3, \r7, \r1  # h1...a1
+	vperm2f128	$0x13, \r0, \r4, \r7  # h7...a7
+	vperm2f128	$0x02, \r0, \r4, \r3  # h3...a3
+	vperm2f128	$0x13, \t0, \t1, \r4  # h4...a4
+	vperm2f128	$0x02, \t0, \t1, \r0  # h0...a0
+
+.endm
+
+.macro ROTATE_ARGS
+TMP_ = h
+h = g
+g = f
+f = e
+e = d
+d = c
+c = b
+b = a
+a = TMP_
+.endm
+
+.macro _PRORD reg imm tmp
+	vpslld	$(32-\imm),\reg,\tmp
+	vpsrld	$\imm,\reg, \reg
+	vpor	\tmp,\reg, \reg
+.endm
+
+# PRORD_nd reg, imm, tmp, src
+.macro _PRORD_nd reg imm tmp src
+	vpslld	$(32-\imm), \src, \tmp
+	vpsrld	$\imm, \src, \reg
+	vpor	\tmp, \reg, \reg
+.endm
+
+# PRORD dst/src, amt
+.macro PRORD reg imm
+	_PRORD	\reg,\imm,TMP
+.endm
+
+# PRORD_nd dst, src, amt
+.macro PRORD_nd reg tmp imm
+	_PRORD_nd	\reg, \imm, TMP, \tmp
+.endm
+
+# arguments passed implicitly in preprocessor symbols i, a...h
+.macro ROUND_00_15 _T1 i
+	PRORD_nd	a0,e,5	# sig1: a0 = (e >> 5)
+
+	vpxor	g, f, a2	# ch: a2 = f^g
+	vpand	e,a2, a2	# ch: a2 = (f^g)&e
+	vpxor	g, a2, a2	# a2 = ch
+
+	PRORD_nd	a1,e,25	# sig1: a1 = (e >> 25)
+
+	vmovdqu	\_T1,(SZ8*(\i & 0xf))(%rsp)
+	vpaddd	(TBL,ROUND,1), \_T1, \_T1	# T1 = W + K
+	vpxor	e,a0, a0	# sig1: a0 = e ^ (e >> 5)
+	PRORD	a0, 6		# sig1: a0 = (e >> 6) ^ (e >> 11)
+	vpaddd	a2, h, h	# h = h + ch
+	PRORD_nd	a2,a,11	# sig0: a2 = (a >> 11)
+	vpaddd	\_T1,h, h 	# h = h + ch + W + K
+	vpxor	a1, a0, a0	# a0 = sigma1
+	PRORD_nd	a1,a,22	# sig0: a1 = (a >> 22)
+	vpxor	c, a, \_T1	# maj: T1 = a^c
+	add	$SZ8, ROUND	# ROUND++
+	vpand	b, \_T1, \_T1	# maj: T1 = (a^c)&b
+	vpaddd	a0, h, h
+	vpaddd	h, d, d
+	vpxor	a, a2, a2	# sig0: a2 = a ^ (a >> 11)
+	PRORD	a2,2		# sig0: a2 = (a >> 2) ^ (a >> 13)
+	vpxor	a1, a2, a2	# a2 = sig0
+	vpand	c, a, a1	# maj: a1 = a&c
+	vpor	\_T1, a1, a1 	# a1 = maj
+	vpaddd	a1, h, h	# h = h + ch + W + K + maj
+	vpaddd	a2, h, h	# h = h + ch + W + K + maj + sigma0
+	ROTATE_ARGS
+.endm
+
+# arguments passed implicitly in preprocessor symbols i, a...h
+.macro ROUND_16_XX _T1 i
+	vmovdqu	(SZ8*((\i-15)&0xf))(%rsp), \_T1
+	vmovdqu	(SZ8*((\i-2)&0xf))(%rsp), a1
+	vmovdqu	\_T1, a0
+	PRORD	\_T1,11
+	vmovdqu	a1, a2
+	PRORD	a1,2
+	vpxor	a0, \_T1, \_T1
+	PRORD	\_T1, 7
+	vpxor	a2, a1, a1
+	PRORD	a1, 17
+	vpsrld	$3, a0, a0
+	vpxor	a0, \_T1, \_T1
+	vpsrld	$10, a2, a2
+	vpxor	a2, a1, a1
+	vpaddd	(SZ8*((\i-16)&0xf))(%rsp), \_T1, \_T1
+	vpaddd	(SZ8*((\i-7)&0xf))(%rsp), a1, a1
+	vpaddd	a1, \_T1, \_T1
+
+	ROUND_00_15 \_T1,\i
+.endm
+
+# void sha256_x8_avx2(struct sha256_mbctx *ctx, int blocks);
+#
+# arg 1 : ctx : pointer to array of pointers to input data
+# arg 2 : blocks : size of input in blocks
+	# save rsp, allocate 32-byte aligned for local variables
+SYM_FUNC_START(sha256_x8_avx2)
+	# save callee-saved clobbered registers to comply with C function ABI
+	push	%rbx
+	push    %r12
+	push    %r13
+	push    %r14
+	push    %r15
+
+	push	%rbp
+	mov	%rsp, %rbp
+
+	sub	$FRAMESZ, %rsp
+	and	$~0x1F, %rsp
+
+	# Load the pre-transposed incoming digest.
+	vmovdqu	0*SHA256_DIGEST_ROW_SIZE(STATE),a
+	vmovdqu	1*SHA256_DIGEST_ROW_SIZE(STATE),b
+	vmovdqu	2*SHA256_DIGEST_ROW_SIZE(STATE),c
+	vmovdqu	3*SHA256_DIGEST_ROW_SIZE(STATE),d
+	vmovdqu	4*SHA256_DIGEST_ROW_SIZE(STATE),e
+	vmovdqu	5*SHA256_DIGEST_ROW_SIZE(STATE),f
+	vmovdqu	6*SHA256_DIGEST_ROW_SIZE(STATE),g
+	vmovdqu	7*SHA256_DIGEST_ROW_SIZE(STATE),h
+
+	lea	K256_8(%rip),TBL
+
+	# load the address of each of the 4 message lanes
+	# getting ready to transpose input onto stack
+	mov	_args_data_ptr+0*PTR_SZ(STATE),inp0
+	mov	_args_data_ptr+1*PTR_SZ(STATE),inp1
+	mov	_args_data_ptr+2*PTR_SZ(STATE),inp2
+	mov	_args_data_ptr+3*PTR_SZ(STATE),inp3
+	mov	_args_data_ptr+4*PTR_SZ(STATE),inp4
+	mov	_args_data_ptr+5*PTR_SZ(STATE),inp5
+	mov	_args_data_ptr+6*PTR_SZ(STATE),inp6
+	mov	_args_data_ptr+7*PTR_SZ(STATE),inp7
+
+	xor	IDX, IDX
+lloop:
+	xor	ROUND, ROUND
+
+	# save old digest
+	vmovdqu	a, _digest(%rsp)
+	vmovdqu	b, _digest+1*SZ8(%rsp)
+	vmovdqu	c, _digest+2*SZ8(%rsp)
+	vmovdqu	d, _digest+3*SZ8(%rsp)
+	vmovdqu	e, _digest+4*SZ8(%rsp)
+	vmovdqu	f, _digest+5*SZ8(%rsp)
+	vmovdqu	g, _digest+6*SZ8(%rsp)
+	vmovdqu	h, _digest+7*SZ8(%rsp)
+	i = 0
+.rep 2
+	VMOVPS	i*32(inp0, IDX), TT0
+	VMOVPS	i*32(inp1, IDX), TT1
+	VMOVPS	i*32(inp2, IDX), TT2
+	VMOVPS	i*32(inp3, IDX), TT3
+	VMOVPS	i*32(inp4, IDX), TT4
+	VMOVPS	i*32(inp5, IDX), TT5
+	VMOVPS	i*32(inp6, IDX), TT6
+	VMOVPS	i*32(inp7, IDX), TT7
+	vmovdqu	g, _ytmp(%rsp)
+	vmovdqu	h, _ytmp+1*SZ8(%rsp)
+	TRANSPOSE8	TT0, TT1, TT2, TT3, TT4, TT5, TT6, TT7,   TMP0, TMP1
+	vmovdqu	PSHUFFLE_BYTE_FLIP_MASK(%rip), TMP1
+	vmovdqu	_ytmp(%rsp), g
+	vpshufb	TMP1, TT0, TT0
+	vpshufb	TMP1, TT1, TT1
+	vpshufb	TMP1, TT2, TT2
+	vpshufb	TMP1, TT3, TT3
+	vpshufb	TMP1, TT4, TT4
+	vpshufb	TMP1, TT5, TT5
+	vpshufb	TMP1, TT6, TT6
+	vpshufb	TMP1, TT7, TT7
+	vmovdqu	_ytmp+1*SZ8(%rsp), h
+	vmovdqu	TT4, _ytmp(%rsp)
+	vmovdqu	TT5, _ytmp+1*SZ8(%rsp)
+	vmovdqu	TT6, _ytmp+2*SZ8(%rsp)
+	vmovdqu	TT7, _ytmp+3*SZ8(%rsp)
+	ROUND_00_15	TT0,(i*8+0)
+	vmovdqu	_ytmp(%rsp), TT0
+	ROUND_00_15	TT1,(i*8+1)
+	vmovdqu	_ytmp+1*SZ8(%rsp), TT1
+	ROUND_00_15	TT2,(i*8+2)
+	vmovdqu	_ytmp+2*SZ8(%rsp), TT2
+	ROUND_00_15	TT3,(i*8+3)
+	vmovdqu	_ytmp+3*SZ8(%rsp), TT3
+	ROUND_00_15	TT0,(i*8+4)
+	ROUND_00_15	TT1,(i*8+5)
+	ROUND_00_15	TT2,(i*8+6)
+	ROUND_00_15	TT3,(i*8+7)
+	i = (i+1)
+.endr
+	add	$64, IDX
+	i = (i*8)
+
+	jmp	Lrounds_16_xx
+.align 16
+Lrounds_16_xx:
+.rep 16
+	ROUND_16_XX	T1, i
+	i = (i+1)
+.endr
+
+	cmp	$ROUNDS,ROUND
+	jb	Lrounds_16_xx
+
+	# add old digest
+	vpaddd	_digest+0*SZ8(%rsp), a, a
+	vpaddd	_digest+1*SZ8(%rsp), b, b
+	vpaddd	_digest+2*SZ8(%rsp), c, c
+	vpaddd	_digest+3*SZ8(%rsp), d, d
+	vpaddd	_digest+4*SZ8(%rsp), e, e
+	vpaddd	_digest+5*SZ8(%rsp), f, f
+	vpaddd	_digest+6*SZ8(%rsp), g, g
+	vpaddd	_digest+7*SZ8(%rsp), h, h
+
+	sub	$1, INP_SIZE  # unit is blocks
+	jne	lloop
+
+	# write back to memory (state object) the transposed digest
+	vmovdqu	a, 0*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	b, 1*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	c, 2*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	d, 3*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	e, 4*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	f, 5*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	g, 6*SHA256_DIGEST_ROW_SIZE(STATE)
+	vmovdqu	h, 7*SHA256_DIGEST_ROW_SIZE(STATE)
+
+	# update input pointers
+	add	IDX, inp0
+	mov	inp0, _args_data_ptr+0*8(STATE)
+	add	IDX, inp1
+	mov	inp1, _args_data_ptr+1*8(STATE)
+	add	IDX, inp2
+	mov	inp2, _args_data_ptr+2*8(STATE)
+	add	IDX, inp3
+	mov	inp3, _args_data_ptr+3*8(STATE)
+	add	IDX, inp4
+	mov	inp4, _args_data_ptr+4*8(STATE)
+	add	IDX, inp5
+	mov	inp5, _args_data_ptr+5*8(STATE)
+	add	IDX, inp6
+	mov	inp6, _args_data_ptr+6*8(STATE)
+	add	IDX, inp7
+	mov	inp7, _args_data_ptr+7*8(STATE)
+
+	# Postamble
+	mov	%rbp, %rsp
+	pop	%rbp
+
+	# restore callee-saved clobbered registers
+	pop     %r15
+	pop     %r14
+	pop     %r13
+	pop     %r12
+	pop	%rbx
+
+	RET
+SYM_FUNC_END(sha256_x8_avx2)
+
+.section	.rodata.K256_8, "a", @progbits
+.align 64
+K256_8:
+	.octa	0x428a2f98428a2f98428a2f98428a2f98
+	.octa	0x428a2f98428a2f98428a2f98428a2f98
+	.octa	0x71374491713744917137449171374491
+	.octa	0x71374491713744917137449171374491
+	.octa	0xb5c0fbcfb5c0fbcfb5c0fbcfb5c0fbcf
+	.octa	0xb5c0fbcfb5c0fbcfb5c0fbcfb5c0fbcf
+	.octa	0xe9b5dba5e9b5dba5e9b5dba5e9b5dba5
+	.octa	0xe9b5dba5e9b5dba5e9b5dba5e9b5dba5
+	.octa	0x3956c25b3956c25b3956c25b3956c25b
+	.octa	0x3956c25b3956c25b3956c25b3956c25b
+	.octa	0x59f111f159f111f159f111f159f111f1
+	.octa	0x59f111f159f111f159f111f159f111f1
+	.octa	0x923f82a4923f82a4923f82a4923f82a4
+	.octa	0x923f82a4923f82a4923f82a4923f82a4
+	.octa	0xab1c5ed5ab1c5ed5ab1c5ed5ab1c5ed5
+	.octa	0xab1c5ed5ab1c5ed5ab1c5ed5ab1c5ed5
+	.octa	0xd807aa98d807aa98d807aa98d807aa98
+	.octa	0xd807aa98d807aa98d807aa98d807aa98
+	.octa	0x12835b0112835b0112835b0112835b01
+	.octa	0x12835b0112835b0112835b0112835b01
+	.octa	0x243185be243185be243185be243185be
+	.octa	0x243185be243185be243185be243185be
+	.octa	0x550c7dc3550c7dc3550c7dc3550c7dc3
+	.octa	0x550c7dc3550c7dc3550c7dc3550c7dc3
+	.octa	0x72be5d7472be5d7472be5d7472be5d74
+	.octa	0x72be5d7472be5d7472be5d7472be5d74
+	.octa	0x80deb1fe80deb1fe80deb1fe80deb1fe
+	.octa	0x80deb1fe80deb1fe80deb1fe80deb1fe
+	.octa	0x9bdc06a79bdc06a79bdc06a79bdc06a7
+	.octa	0x9bdc06a79bdc06a79bdc06a79bdc06a7
+	.octa	0xc19bf174c19bf174c19bf174c19bf174
+	.octa	0xc19bf174c19bf174c19bf174c19bf174
+	.octa	0xe49b69c1e49b69c1e49b69c1e49b69c1
+	.octa	0xe49b69c1e49b69c1e49b69c1e49b69c1
+	.octa	0xefbe4786efbe4786efbe4786efbe4786
+	.octa	0xefbe4786efbe4786efbe4786efbe4786
+	.octa	0x0fc19dc60fc19dc60fc19dc60fc19dc6
+	.octa	0x0fc19dc60fc19dc60fc19dc60fc19dc6
+	.octa	0x240ca1cc240ca1cc240ca1cc240ca1cc
+	.octa	0x240ca1cc240ca1cc240ca1cc240ca1cc
+	.octa	0x2de92c6f2de92c6f2de92c6f2de92c6f
+	.octa	0x2de92c6f2de92c6f2de92c6f2de92c6f
+	.octa	0x4a7484aa4a7484aa4a7484aa4a7484aa
+	.octa	0x4a7484aa4a7484aa4a7484aa4a7484aa
+	.octa	0x5cb0a9dc5cb0a9dc5cb0a9dc5cb0a9dc
+	.octa	0x5cb0a9dc5cb0a9dc5cb0a9dc5cb0a9dc
+	.octa	0x76f988da76f988da76f988da76f988da
+	.octa	0x76f988da76f988da76f988da76f988da
+	.octa	0x983e5152983e5152983e5152983e5152
+	.octa	0x983e5152983e5152983e5152983e5152
+	.octa	0xa831c66da831c66da831c66da831c66d
+	.octa	0xa831c66da831c66da831c66da831c66d
+	.octa	0xb00327c8b00327c8b00327c8b00327c8
+	.octa	0xb00327c8b00327c8b00327c8b00327c8
+	.octa	0xbf597fc7bf597fc7bf597fc7bf597fc7
+	.octa	0xbf597fc7bf597fc7bf597fc7bf597fc7
+	.octa	0xc6e00bf3c6e00bf3c6e00bf3c6e00bf3
+	.octa	0xc6e00bf3c6e00bf3c6e00bf3c6e00bf3
+	.octa	0xd5a79147d5a79147d5a79147d5a79147
+	.octa	0xd5a79147d5a79147d5a79147d5a79147
+	.octa	0x06ca635106ca635106ca635106ca6351
+	.octa	0x06ca635106ca635106ca635106ca6351
+	.octa	0x14292967142929671429296714292967
+	.octa	0x14292967142929671429296714292967
+	.octa	0x27b70a8527b70a8527b70a8527b70a85
+	.octa	0x27b70a8527b70a8527b70a8527b70a85
+	.octa	0x2e1b21382e1b21382e1b21382e1b2138
+	.octa	0x2e1b21382e1b21382e1b21382e1b2138
+	.octa	0x4d2c6dfc4d2c6dfc4d2c6dfc4d2c6dfc
+	.octa	0x4d2c6dfc4d2c6dfc4d2c6dfc4d2c6dfc
+	.octa	0x53380d1353380d1353380d1353380d13
+	.octa	0x53380d1353380d1353380d1353380d13
+	.octa	0x650a7354650a7354650a7354650a7354
+	.octa	0x650a7354650a7354650a7354650a7354
+	.octa	0x766a0abb766a0abb766a0abb766a0abb
+	.octa	0x766a0abb766a0abb766a0abb766a0abb
+	.octa	0x81c2c92e81c2c92e81c2c92e81c2c92e
+	.octa	0x81c2c92e81c2c92e81c2c92e81c2c92e
+	.octa	0x92722c8592722c8592722c8592722c85
+	.octa	0x92722c8592722c8592722c8592722c85
+	.octa	0xa2bfe8a1a2bfe8a1a2bfe8a1a2bfe8a1
+	.octa	0xa2bfe8a1a2bfe8a1a2bfe8a1a2bfe8a1
+	.octa	0xa81a664ba81a664ba81a664ba81a664b
+	.octa	0xa81a664ba81a664ba81a664ba81a664b
+	.octa	0xc24b8b70c24b8b70c24b8b70c24b8b70
+	.octa	0xc24b8b70c24b8b70c24b8b70c24b8b70
+	.octa	0xc76c51a3c76c51a3c76c51a3c76c51a3
+	.octa	0xc76c51a3c76c51a3c76c51a3c76c51a3
+	.octa	0xd192e819d192e819d192e819d192e819
+	.octa	0xd192e819d192e819d192e819d192e819
+	.octa	0xd6990624d6990624d6990624d6990624
+	.octa	0xd6990624d6990624d6990624d6990624
+	.octa	0xf40e3585f40e3585f40e3585f40e3585
+	.octa	0xf40e3585f40e3585f40e3585f40e3585
+	.octa	0x106aa070106aa070106aa070106aa070
+	.octa	0x106aa070106aa070106aa070106aa070
+	.octa	0x19a4c11619a4c11619a4c11619a4c116
+	.octa	0x19a4c11619a4c11619a4c11619a4c116
+	.octa	0x1e376c081e376c081e376c081e376c08
+	.octa	0x1e376c081e376c081e376c081e376c08
+	.octa	0x2748774c2748774c2748774c2748774c
+	.octa	0x2748774c2748774c2748774c2748774c
+	.octa	0x34b0bcb534b0bcb534b0bcb534b0bcb5
+	.octa	0x34b0bcb534b0bcb534b0bcb534b0bcb5
+	.octa	0x391c0cb3391c0cb3391c0cb3391c0cb3
+	.octa	0x391c0cb3391c0cb3391c0cb3391c0cb3
+	.octa	0x4ed8aa4a4ed8aa4a4ed8aa4a4ed8aa4a
+	.octa	0x4ed8aa4a4ed8aa4a4ed8aa4a4ed8aa4a
+	.octa	0x5b9cca4f5b9cca4f5b9cca4f5b9cca4f
+	.octa	0x5b9cca4f5b9cca4f5b9cca4f5b9cca4f
+	.octa	0x682e6ff3682e6ff3682e6ff3682e6ff3
+	.octa	0x682e6ff3682e6ff3682e6ff3682e6ff3
+	.octa	0x748f82ee748f82ee748f82ee748f82ee
+	.octa	0x748f82ee748f82ee748f82ee748f82ee
+	.octa	0x78a5636f78a5636f78a5636f78a5636f
+	.octa	0x78a5636f78a5636f78a5636f78a5636f
+	.octa	0x84c8781484c8781484c8781484c87814
+	.octa	0x84c8781484c8781484c8781484c87814
+	.octa	0x8cc702088cc702088cc702088cc70208
+	.octa	0x8cc702088cc702088cc702088cc70208
+	.octa	0x90befffa90befffa90befffa90befffa
+	.octa	0x90befffa90befffa90befffa90befffa
+	.octa	0xa4506ceba4506ceba4506ceba4506ceb
+	.octa	0xa4506ceba4506ceba4506ceba4506ceb
+	.octa	0xbef9a3f7bef9a3f7bef9a3f7bef9a3f7
+	.octa	0xbef9a3f7bef9a3f7bef9a3f7bef9a3f7
+	.octa	0xc67178f2c67178f2c67178f2c67178f2
+	.octa	0xc67178f2c67178f2c67178f2c67178f2
+
+.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
+.align 32
+PSHUFFLE_BYTE_FLIP_MASK:
+.octa 0x0c0d0e0f08090a0b0405060700010203
+.octa 0x0c0d0e0f08090a0b0405060700010203
+
+.section	.rodata.cst256.K256, "aM", @progbits, 256
+.align 64
+.global K256
+K256:
+	.int	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
+	.int	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
+	.int	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
+	.int	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
+	.int	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
+	.int	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
+	.int	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
+	.int	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
+	.int	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
+	.int	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
+	.int	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
+	.int	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
+	.int	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
+	.int	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
+	.int	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
+	.int	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
-- 
2.39.5

