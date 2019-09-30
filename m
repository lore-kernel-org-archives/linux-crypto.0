Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16785C35280
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 13:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDA772086A
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 13:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbfI3NM5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 09:12:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:47784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728214AbfI3NM4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 09:12:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21D31AD4F;
        Mon, 30 Sep 2019 13:12:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7614EDA88C; Mon, 30 Sep 2019 15:13:08 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] crypto: BLAKE2 reference implementation
Date:   Mon, 30 Sep 2019 15:13:08 +0200
Message-Id: <8087a8b358b5f97304963a38a17433a416d1382b.1569849051.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1569849051.git.dsterba@suse.com>
References: <cover.1569849051.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The patch brings support of several BLAKE2 algorithms (2b, 2s, various
digest lengths). The in-tree user will be btrfs (for checksumming),
we're going to use the BLAKE2b-256 variant. It would be ideal if the
patches get merged to 5.5, thats our target to release the support of
new hashes.

The code is reference implementation taken from the official sources and
slightly modified only in terms of kernel coding style (whitespace,
comments, uintXX_t -> uXX types, removed unused prototypes and #ifdefs,
removed testing code, changed secure_zero_memory -> memzero_explicit).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/Kconfig           |  35 +++
 crypto/Makefile          |   2 +
 crypto/blake2-impl.h     | 145 +++++++++++++
 crypto/blake2.h          | 143 +++++++++++++
 crypto/blake2b_generic.c | 445 ++++++++++++++++++++++++++++++++++++++
 crypto/blake2s_generic.c | 446 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 1216 insertions(+)
 create mode 100644 crypto/blake2-impl.h
 create mode 100644 crypto/blake2.h
 create mode 100644 crypto/blake2b_generic.c
 create mode 100644 crypto/blake2s_generic.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e801450bcb1c..961e602bb273 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -691,6 +691,41 @@ config CRYPTO_XXHASH
 	  xxHash non-cryptographic hash algorithm. Extremely fast, working at
 	  speeds close to RAM limits.
 
+config CRYPTO_BLAKE2B
+	tristate "BLAKE2b digest algorithm"
+	select CRYPTO_HASH
+	help
+	  Implementation of cryptographic hash function BLAKE2b (or just BLAKE2),
+	  optimized for 64bit platforms and can produce digests of any size
+	  between 1 to 64.
+
+	  This module provides the following algorithms:
+
+	  - blake2b     - the default 512b digest
+	  - blake2b-160
+	  - blake2b-256
+	  - blake2b-384
+	  - blake2b-512
+
+	  See https://blake2.net for further information.
+
+config CRYPTO_BLAKE2S
+	tristate "BLAKE2s digest algorithm"
+	select CRYPTO_HASH
+	help
+	  Implementation of cryptographic hash function BLAKE2s optimized for
+	  8-32bit platforms and can produce digests of any size between 1 to 32.
+
+	  This module provides the following algorithms:
+
+	  - blake2s     - the default 256b digest
+	  - blake2s-128
+	  - blake2s-160
+	  - blake2s-224
+	  - blake2s-256
+
+	  See https://blake2.net for further information.
+
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 9479e1a45d8c..8119c382e60c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,6 +74,8 @@ obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
+obj-$(CONFIG_CRYPTO_BLAKE2S) += blake2s_generic.o
+obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
diff --git a/crypto/blake2-impl.h b/crypto/blake2-impl.h
new file mode 100644
index 000000000000..9b98474d7511
--- /dev/null
+++ b/crypto/blake2-impl.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0) */
+/*
+ * BLAKE2 reference source code package - reference C implementations
+ *
+ * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
+ * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
+ * your option.  The terms of these licenses can be found at:
+ *
+ * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
+ * - OpenSSL license   : https://www.openssl.org/source/license.html
+ * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * More information about the BLAKE2 hash function can be found at
+ * https://blake2.net.
+ */
+
+#ifndef BLAKE2_IMPL_H
+#define BLAKE2_IMPL_H
+
+#include <linux/string.h>
+
+static inline u32 load32(const void *src)
+{
+#ifdef __LITTLE_ENDIAN
+	u32 w;
+	memcpy(&w, src, sizeof w);
+	return w;
+#else
+	const u8 *p = (const u8 *)src;
+	return  ((u32)(p[0]) <<  0) |
+		((u32)(p[1]) <<  8) |
+		((u32)(p[2]) << 16) |
+		((u32)(p[3]) << 24) ;
+#endif
+}
+
+static inline u64 load64(const void *src)
+{
+#ifdef __LITTLE_ENDIAN
+	u64 w;
+	memcpy(&w, src, sizeof w);
+	return w;
+#else
+	const u8 *p = (const u8 *)src;
+	return  ((u64)(p[0]) <<  0) |
+		((u64)(p[1]) <<  8) |
+		((u64)(p[2]) << 16) |
+		((u64)(p[3]) << 24) |
+		((u64)(p[4]) << 32) |
+		((u64)(p[5]) << 40) |
+		((u64)(p[6]) << 48) |
+		((u64)(p[7]) << 56) ;
+#endif
+}
+
+static inline u16 load16(const void *src)
+{
+#ifdef __LITTLE_ENDIAN
+	u16 w;
+	memcpy(&w, src, sizeof w);
+	return w;
+#else
+	const u8 *p = (const u8 *)src;
+	return (u16)(((u32)(p[0]) <<  0) |
+		     ((u32)(p[1]) <<  8));
+#endif
+}
+
+static inline void store16(void *dst, u16 w)
+{
+#ifdef __LITTLE_ENDIAN
+	memcpy(dst, &w, sizeof w);
+#else
+	u8 *p = (u8 *)dst;
+	*p++ = (u8)w;
+	w >>= 8;
+	*p++ = (u8)w;
+#endif
+}
+
+static inline void store32(void *dst, u32 w)
+{
+#ifdef __LITTLE_ENDIAN
+	memcpy(dst, &w, sizeof w);
+#else
+	u8 *p = (u8 *)dst;
+	p[0] = (u8)(w >>  0);
+	p[1] = (u8)(w >>  8);
+	p[2] = (u8)(w >> 16);
+	p[3] = (u8)(w >> 24);
+#endif
+}
+
+static inline void store64(void *dst, u64 w)
+{
+#ifdef __LITTLE_ENDIAN
+	memcpy(dst, &w, sizeof w);
+#else
+	u8 *p = (u8 *)dst;
+	p[0] = (u8)(w >>  0);
+	p[1] = (u8)(w >>  8);
+	p[2] = (u8)(w >> 16);
+	p[3] = (u8)(w >> 24);
+	p[4] = (u8)(w >> 32);
+	p[5] = (u8)(w >> 40);
+	p[6] = (u8)(w >> 48);
+	p[7] = (u8)(w >> 56);
+#endif
+}
+
+static inline u64 load48(const void *src)
+{
+	const u8 *p = (const u8 *)src;
+
+	return  ((u64)(p[0]) <<  0) |
+		((u64)(p[1]) <<  8) |
+		((u64)(p[2]) << 16) |
+		((u64)(p[3]) << 24) |
+		((u64)(p[4]) << 32) |
+		((u64)(p[5]) << 40) ;
+}
+
+static inline void store48(void *dst, u64 w)
+{
+	u8 *p = (u8 *)dst;
+
+	p[0] = (u8)(w >>  0);
+	p[1] = (u8)(w >>  8);
+	p[2] = (u8)(w >> 16);
+	p[3] = (u8)(w >> 24);
+	p[4] = (u8)(w >> 32);
+	p[5] = (u8)(w >> 40);
+}
+
+static inline u32 rotr32(const u32 w, const unsigned c)
+{
+	return (w >> c) | (w << (32 - c));
+}
+
+static inline u64 rotr64(const u64 w, const unsigned c)
+{
+	return (w >> c) | (w << (64 - c));
+}
+
+#endif
diff --git a/crypto/blake2.h b/crypto/blake2.h
new file mode 100644
index 000000000000..f5f80335e5e7
--- /dev/null
+++ b/crypto/blake2.h
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0) */
+/*
+ * BLAKE2 reference source code package - reference C implementations
+ *
+ * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
+ * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
+ * your option.  The terms of these licenses can be found at:
+ *
+ * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
+ * - OpenSSL license   : https://www.openssl.org/source/license.html
+ * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * More information about the BLAKE2 hash function can be found at
+ * https://blake2.net.
+*/
+
+#ifndef BLAKE2_H
+#define BLAKE2_H
+
+#include <linux/compiler.h>
+#include <stddef.h>
+
+enum blake2s_constant
+{
+	BLAKE2S_BLOCKBYTES = 64,
+	BLAKE2S_OUTBYTES   = 32,
+	BLAKE2S_KEYBYTES   = 32,
+	BLAKE2S_SALTBYTES  = 8,
+	BLAKE2S_PERSONALBYTES = 8
+};
+
+enum blake2b_constant
+{
+	BLAKE2B_BLOCKBYTES = 128,
+	BLAKE2B_OUTBYTES   = 64,
+	BLAKE2B_KEYBYTES   = 64,
+	BLAKE2B_SALTBYTES  = 16,
+	BLAKE2B_PERSONALBYTES = 16
+};
+
+struct blake2s_state
+{
+	u32      h[8];
+	u32      t[2];
+	u32      f[2];
+	u8       buf[BLAKE2S_BLOCKBYTES];
+	size_t   buflen;
+	size_t   outlen;
+	u8  last_node;
+};
+
+struct blake2b_state
+{
+	u64      h[8];
+	u64      t[2];
+	u64      f[2];
+	u8       buf[BLAKE2B_BLOCKBYTES];
+	size_t   buflen;
+	size_t   outlen;
+	u8       last_node;
+};
+
+struct blake2sp_state
+{
+	struct blake2s_state S[8][1];
+	struct blake2s_state R[1];
+	u8            buf[8 * BLAKE2S_BLOCKBYTES];
+	size_t        buflen;
+	size_t        outlen;
+};
+
+struct blake2bp_state
+{
+	struct blake2b_state S[4][1];
+	struct blake2b_state R[1];
+	u8            buf[4 * BLAKE2B_BLOCKBYTES];
+	size_t        buflen;
+	size_t        outlen;
+};
+
+struct blake2s_param
+{
+	u8  digest_length; /* 1 */
+	u8  key_length;    /* 2 */
+	u8  fanout;        /* 3 */
+	u8  depth;         /* 4 */
+	u32 leaf_length;   /* 8 */
+	u32 node_offset;   /* 12 */
+	u16 xof_length;    /* 14 */
+	u8  node_depth;    /* 15 */
+	u8  inner_length;  /* 16 */
+	u8  salt[BLAKE2S_SALTBYTES]; /* 24 */
+	u8  personal[BLAKE2S_PERSONALBYTES];  /* 32 */
+} __packed;
+
+struct blake2b_param
+{
+	u8  digest_length; /* 1 */
+	u8  key_length;    /* 2 */
+	u8  fanout;        /* 3 */
+	u8  depth;         /* 4 */
+	u32 leaf_length;   /* 8 */
+	u32 node_offset;   /* 12 */
+	u32 xof_length;    /* 16 */
+	u8  node_depth;    /* 17 */
+	u8  inner_length;  /* 18 */
+	u8  reserved[14];  /* 32 */
+	u8  salt[BLAKE2B_SALTBYTES]; /* 48 */
+	u8  personal[BLAKE2B_PERSONALBYTES];  /* 64 */
+} __packed;
+
+struct blake2xs_state
+{
+	struct blake2s_state S[1];
+	struct blake2s_param P[1];
+};
+
+struct blake2xb_state
+{
+	struct blake2b_state S[1];
+	struct blake2b_param P[1];
+};
+
+/* Padded structs result in a compile-time error */
+enum {
+	BLAKE2_DUMMY_1 = 1 / (sizeof(struct blake2s_param) == BLAKE2S_OUTBYTES),
+	BLAKE2_DUMMY_2 = 1 / (sizeof(struct blake2b_param) == BLAKE2B_OUTBYTES)
+};
+
+/* Streaming API */
+int blake2s_init(struct blake2s_state *S, size_t outlen);
+int blake2s_init_key(struct blake2s_state *S, size_t outlen, const void *key, size_t keylen);
+int blake2s_init_param(struct blake2s_state *S, const struct blake2s_param *P);
+int blake2s_update(struct blake2s_state *S, const void *in, size_t inlen);
+int blake2s_final(struct blake2s_state *S, void *out, size_t outlen);
+
+int blake2b_init(struct blake2b_state *S, size_t outlen);
+int blake2b_init_key(struct blake2b_state *S, size_t outlen, const void *key, size_t keylen);
+int blake2b_init_param(struct blake2b_state *S, const struct blake2b_param *P);
+int blake2b_update(struct blake2b_state *S, const void *in, size_t inlen);
+int blake2b_final(struct blake2b_state *S, void *out, size_t outlen);
+
+#endif
diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
new file mode 100644
index 000000000000..63fa1192fd20
--- /dev/null
+++ b/crypto/blake2b_generic.c
@@ -0,0 +1,445 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0)
+/*
+ * BLAKE2 reference source code package - reference C implementations
+ *
+ * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
+ * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
+ * your option.  The terms of these licenses can be found at:
+ *
+ * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
+ * - OpenSSL license   : https://www.openssl.org/source/license.html
+ * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * More information about the BLAKE2 hash function can be found at
+ * https://blake2.net.
+ */
+
+#include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+#include "blake2.h"
+#include "blake2-impl.h"
+
+#define BLAKE2B_160_DIGEST_SIZE		(160 / 8)
+#define BLAKE2B_256_DIGEST_SIZE		(256 / 8)
+#define BLAKE2B_384_DIGEST_SIZE		(384 / 8)
+#define BLAKE2B_512_DIGEST_SIZE		(512 / 8)
+
+static const u64 blake2b_IV[8] =
+{
+	0x6a09e667f3bcc908ULL, 0xbb67ae8584caa73bULL,
+	0x3c6ef372fe94f82bULL, 0xa54ff53a5f1d36f1ULL,
+	0x510e527fade682d1ULL, 0x9b05688c2b3e6c1fULL,
+	0x1f83d9abfb41bd6bULL, 0x5be0cd19137e2179ULL
+};
+
+static const u8 blake2b_sigma[12][16] =
+{
+	{  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 },
+	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 },
+	{ 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 },
+	{  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 },
+	{  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 },
+	{  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 },
+	{ 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 },
+	{ 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 },
+	{  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 },
+	{ 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13 , 0 },
+	{  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 },
+	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 }
+};
+
+static void blake2b_set_lastnode(struct blake2b_state *S)
+{
+	S->f[1] = (u64)-1;
+}
+
+/* Some helper functions, not necessarily useful */
+static int blake2b_is_lastblock(const struct blake2b_state *S)
+{
+	return S->f[0] != 0;
+}
+
+static void blake2b_set_lastblock(struct blake2b_state *S)
+{
+	if (S->last_node)
+		blake2b_set_lastnode(S);
+
+	S->f[0] = (u64)-1;
+}
+
+static void blake2b_increment_counter(struct blake2b_state *S, const u64 inc)
+{
+	S->t[0] += inc;
+	S->t[1] += (S->t[0] < inc);
+}
+
+static void blake2b_init0(struct blake2b_state *S)
+{
+	size_t i;
+
+	memset(S, 0, sizeof(struct blake2b_state));
+
+	for (i = 0; i < 8; ++i)
+		S->h[i] = blake2b_IV[i];
+}
+
+/* init xors IV with input parameter block */
+int blake2b_init_param(struct blake2b_state *S, const struct blake2b_param *P)
+{
+	const u8 *p = (const u8 *)(P);
+	size_t i;
+
+	blake2b_init0(S);
+
+	/* IV XOR ParamBlock */
+	for (i = 0; i < 8; ++i)
+		S->h[i] ^= load64(p + sizeof(S->h[i]) * i);
+
+	S->outlen = P->digest_length;
+	return 0;
+}
+
+int blake2b_init(struct blake2b_state *S, size_t outlen)
+{
+	struct blake2b_param P[1];
+
+	if ((!outlen) || (outlen > BLAKE2B_OUTBYTES))
+		return -1;
+
+	P->digest_length = (u8)outlen;
+	P->key_length    = 0;
+	P->fanout        = 1;
+	P->depth         = 1;
+	store32(&P->leaf_length, 0);
+	store32(&P->node_offset, 0);
+	store32(&P->xof_length, 0);
+	P->node_depth    = 0;
+	P->inner_length  = 0;
+	memset(P->reserved, 0, sizeof(P->reserved));
+	memset(P->salt,     0, sizeof(P->salt));
+	memset(P->personal, 0, sizeof(P->personal));
+	return blake2b_init_param(S, P);
+}
+
+int blake2b_init_key(struct blake2b_state *S, size_t outlen, const void *key,
+		     size_t keylen)
+{
+	struct blake2b_param P[1];
+
+	if ((!outlen) || (outlen > BLAKE2B_OUTBYTES))
+		return -1;
+
+	if (!key || !keylen || keylen > BLAKE2B_KEYBYTES)
+		return -1;
+
+	P->digest_length = (u8)outlen;
+	P->key_length    = (u8)keylen;
+	P->fanout        = 1;
+	P->depth         = 1;
+	store32(&P->leaf_length, 0);
+	store32(&P->node_offset, 0);
+	store32(&P->xof_length, 0);
+	P->node_depth    = 0;
+	P->inner_length  = 0;
+	memset(P->reserved, 0, sizeof(P->reserved));
+	memset(P->salt,     0, sizeof(P->salt));
+	memset(P->personal, 0, sizeof(P->personal));
+
+	if (blake2b_init_param(S, P) < 0)
+		return -1;
+
+	{
+		u8 block[BLAKE2B_BLOCKBYTES];
+
+		memset(block, 0, BLAKE2B_BLOCKBYTES);
+		memcpy(block, key, keylen);
+		blake2b_update(S, block, BLAKE2B_BLOCKBYTES);
+		memzero_explicit(block, BLAKE2B_BLOCKBYTES);
+	}
+	return 0;
+}
+
+#define G(r,i,a,b,c,d)                                  \
+	do {                                            \
+		a = a + b + m[blake2b_sigma[r][2*i+0]]; \
+		d = rotr64(d ^ a, 32);                  \
+		c = c + d;                              \
+		b = rotr64(b ^ c, 24);                  \
+		a = a + b + m[blake2b_sigma[r][2*i+1]]; \
+		d = rotr64(d ^ a, 16);                  \
+		c = c + d;                              \
+		b = rotr64(b ^ c, 63);                  \
+	} while(0)
+
+#define ROUND(r)                                \
+	do {                                    \
+		G(r,0,v[ 0],v[ 4],v[ 8],v[12]); \
+		G(r,1,v[ 1],v[ 5],v[ 9],v[13]); \
+		G(r,2,v[ 2],v[ 6],v[10],v[14]); \
+		G(r,3,v[ 3],v[ 7],v[11],v[15]); \
+		G(r,4,v[ 0],v[ 5],v[10],v[15]); \
+		G(r,5,v[ 1],v[ 6],v[11],v[12]); \
+		G(r,6,v[ 2],v[ 7],v[ 8],v[13]); \
+		G(r,7,v[ 3],v[ 4],v[ 9],v[14]); \
+	} while(0)
+
+static void blake2b_compress(struct blake2b_state *S,
+			     const u8 block[BLAKE2B_BLOCKBYTES])
+{
+	u64 m[16];
+	u64 v[16];
+	size_t i;
+
+	for (i = 0; i < 16; ++i)
+		m[i] = load64(block + i * sizeof(m[i]));
+
+	for (i = 0; i < 8; ++i)
+		v[i] = S->h[i];
+
+	v[ 8] = blake2b_IV[0];
+	v[ 9] = blake2b_IV[1];
+	v[10] = blake2b_IV[2];
+	v[11] = blake2b_IV[3];
+	v[12] = blake2b_IV[4] ^ S->t[0];
+	v[13] = blake2b_IV[5] ^ S->t[1];
+	v[14] = blake2b_IV[6] ^ S->f[0];
+	v[15] = blake2b_IV[7] ^ S->f[1];
+
+	ROUND(0);
+	ROUND(1);
+	ROUND(2);
+	ROUND(3);
+	ROUND(4);
+	ROUND(5);
+	ROUND(6);
+	ROUND(7);
+	ROUND(8);
+	ROUND(9);
+	ROUND(10);
+	ROUND(11);
+
+	for (i = 0; i < 8; ++i)
+		S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
+}
+
+#undef G
+#undef ROUND
+
+int blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen)
+{
+	const unsigned char *in = (const unsigned char *)pin;
+
+	if (inlen > 0) {
+		size_t left = S->buflen;
+		size_t fill = BLAKE2B_BLOCKBYTES - left;
+
+		if (inlen > fill) {
+			S->buflen = 0;
+			/* Fill buffer */
+			memcpy(S->buf + left, in, fill);
+			blake2b_increment_counter(S, BLAKE2B_BLOCKBYTES);
+			/* Compress */
+			blake2b_compress(S, S->buf);
+			in += fill;
+			inlen -= fill;
+			while (inlen > BLAKE2B_BLOCKBYTES) {
+				blake2b_increment_counter(S, BLAKE2B_BLOCKBYTES);
+				blake2b_compress(S, in);
+				in += BLAKE2B_BLOCKBYTES;
+				inlen -= BLAKE2B_BLOCKBYTES;
+			}
+		}
+		memcpy(S->buf + S->buflen, in, inlen);
+		S->buflen += inlen;
+	}
+	return 0;
+}
+
+int blake2b_final(struct blake2b_state *S, void *out, size_t outlen)
+{
+	u8 buffer[BLAKE2B_OUTBYTES] = {0};
+	size_t i;
+
+	if (out == NULL || outlen < S->outlen)
+		return -1;
+
+	if (blake2b_is_lastblock(S))
+		return -1;
+
+	blake2b_increment_counter(S, S->buflen);
+	blake2b_set_lastblock(S);
+	/* Padding */
+	memset(S->buf + S->buflen, 0, BLAKE2B_BLOCKBYTES - S->buflen);
+	blake2b_compress(S, S->buf);
+
+	/* Output full hash to temp buffer */
+	for (i = 0; i < 8; ++i)
+		store64(buffer + sizeof(S->h[i]) * i, S->h[i]);
+
+	memcpy(out, buffer, S->outlen);
+	memzero_explicit(buffer, sizeof(buffer));
+	return 0;
+}
+
+struct digest_desc_ctx {
+	struct blake2b_state S[1];
+};
+
+static int digest_init(struct shash_desc *desc)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	int ret;
+
+	ret = blake2b_init(ctx->S, BLAKE2B_OUTBYTES);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int digest_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	int ret;
+
+	ret = blake2b_update(ctx->S, data, length);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
+static int digest_final(struct shash_desc *desc, u8 *out)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	int ret;
+
+	ret = blake2b_final(ctx->S, out, BLAKE2B_OUTBYTES);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
+static int digest_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	int ret;
+
+	ret = blake2b_update(ctx->S, data, len);
+	if (ret)
+		return -EINVAL;
+	ret = blake2b_final(ctx->S, out, BLAKE2B_OUTBYTES);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct shash_alg blake2b_algs[] = { {
+	.digestsize	=	BLAKE2B_512_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2b",
+		.cra_driver_name	=	"blake2b-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2B_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2B_160_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2b-160",
+		.cra_driver_name	=	"blake2b-160-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2B_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2B_256_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2b-256",
+		.cra_driver_name	=	"blake2b-256-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2B_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2B_384_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2b-384",
+		.cra_driver_name	=	"blake2b-384-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2B_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2B_512_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2b-512",
+		.cra_driver_name	=	"blake2b-512-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2B_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+} };
+
+static int __init blake2b_mod_init(void)
+{
+	return crypto_register_shashes(blake2b_algs, ARRAY_SIZE(blake2b_algs));
+}
+
+static void __exit blake2b_mod_fini(void)
+{
+	crypto_unregister_shashes(blake2b_algs, ARRAY_SIZE(blake2b_algs));
+}
+
+subsys_initcall(blake2b_mod_init);
+module_exit(blake2b_mod_fini);
+
+MODULE_AUTHOR("David Sterba <kdave@kernel.org>");
+MODULE_DESCRIPTION("BLAKE2b reference implementation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("blake2b");
+MODULE_ALIAS_CRYPTO("blake2b-generic");
+MODULE_ALIAS_CRYPTO("blake2b-160");
+MODULE_ALIAS_CRYPTO("blake2b-160-generic");
+MODULE_ALIAS_CRYPTO("blake2b-256");
+MODULE_ALIAS_CRYPTO("blake2b-256-generic");
+MODULE_ALIAS_CRYPTO("blake2b-384");
+MODULE_ALIAS_CRYPTO("blake2b-384-generic");
+MODULE_ALIAS_CRYPTO("blake2b-512");
+MODULE_ALIAS_CRYPTO("blake2b-512-generic");
diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
new file mode 100644
index 000000000000..37af5df60cf4
--- /dev/null
+++ b/crypto/blake2s_generic.c
@@ -0,0 +1,446 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0)
+/*
+ * BLAKE2 reference source code package - reference C implementations
+ *
+ * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
+ * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
+ * your option.  The terms of these licenses can be found at:
+ *
+ * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
+ * - OpenSSL license   : https://www.openssl.org/source/license.html
+ * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * More information about the BLAKE2 hash function can be found at
+ * https://blake2.net.
+ */
+
+#include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+#include "blake2.h"
+#include "blake2-impl.h"
+
+#define BLAKE2S_128_DIGEST_SIZE		(128 / 8)
+#define BLAKE2S_160_DIGEST_SIZE		(160 / 8)
+#define BLAKE2S_224_DIGEST_SIZE		(224 / 8)
+#define BLAKE2S_256_DIGEST_SIZE		(256 / 8)
+
+static const u32 blake2s_IV[8] =
+{
+	0x6A09E667UL, 0xBB67AE85UL, 0x3C6EF372UL, 0xA54FF53AUL,
+	0x510E527FUL, 0x9B05688CUL, 0x1F83D9ABUL, 0x5BE0CD19UL
+};
+
+static const u8 blake2s_sigma[10][16] =
+{
+	{  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 },
+	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 },
+	{ 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 },
+	{  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 },
+	{  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 },
+	{  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 },
+	{ 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 },
+	{ 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 },
+	{  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 },
+	{ 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13 , 0 },
+};
+
+static void blake2s_set_lastnode(struct blake2s_state *S)
+{
+	S->f[1] = (u32)-1;
+}
+
+/* Some helper functions, not necessarily useful */
+static int blake2s_is_lastblock(const struct blake2s_state *S)
+{
+	return S->f[0] != 0;
+}
+
+static void blake2s_set_lastblock(struct blake2s_state *S)
+{
+	if (S->last_node)
+		blake2s_set_lastnode(S);
+
+	S->f[0] = (u32)-1;
+}
+
+static void blake2s_increment_counter(struct blake2s_state *S, const u32 inc)
+{
+	S->t[0] += inc;
+	S->t[1] += (S->t[0] < inc);
+}
+
+static void blake2s_init0(struct blake2s_state *S)
+{
+	size_t i;
+
+	memset(S, 0, sizeof(struct blake2s_state));
+
+	for (i = 0; i < 8; ++i)
+		S->h[i] = blake2s_IV[i];
+}
+
+/* init2 xors IV with input parameter block */
+int blake2s_init_param(struct blake2s_state *S, const struct blake2s_param *P)
+{
+	const unsigned char *p = (const unsigned char *)(P);
+	size_t i;
+
+	blake2s_init0(S);
+
+	/* IV XOR ParamBlock */
+	for (i = 0; i < 8; ++i)
+		S->h[i] ^= load32(&p[i * 4]);
+
+	S->outlen = P->digest_length;
+	return 0;
+}
+
+/* Sequential blake2s initialization */
+int blake2s_init(struct blake2s_state *S, size_t outlen)
+{
+	struct blake2s_param P[1];
+
+	/* Move interval verification here? */
+	if ((!outlen) || (outlen > BLAKE2S_OUTBYTES))
+		return -1;
+
+	P->digest_length = (u8)outlen;
+	P->key_length    = 0;
+	P->fanout        = 1;
+	P->depth         = 1;
+	store32(&P->leaf_length, 0);
+	store32(&P->node_offset, 0);
+	store16(&P->xof_length, 0);
+	P->node_depth    = 0;
+	P->inner_length  = 0;
+	memset(P->salt,     0, sizeof(P->salt));
+	memset(P->personal, 0, sizeof(P->personal));
+	return blake2s_init_param(S, P);
+}
+
+int blake2s_init_key(struct blake2s_state *S, size_t outlen, const void *key,
+		     size_t keylen)
+{
+	struct blake2s_param P[1];
+
+	if ((!outlen) || (outlen > BLAKE2S_OUTBYTES))
+		return -1;
+
+	if (!key || !keylen || keylen > BLAKE2S_KEYBYTES)
+		return -1;
+
+	P->digest_length = (u8)outlen;
+	P->key_length    = (u8)keylen;
+	P->fanout        = 1;
+	P->depth         = 1;
+	store32(&P->leaf_length, 0);
+	store32(&P->node_offset, 0);
+	store16(&P->xof_length, 0);
+	P->node_depth    = 0;
+	P->inner_length  = 0;
+	memset(P->salt,     0, sizeof(P->salt));
+	memset(P->personal, 0, sizeof(P->personal));
+
+	if (blake2s_init_param(S, P) < 0)
+		return -1;
+
+	{
+		u8 block[BLAKE2S_BLOCKBYTES];
+
+		memset(block, 0, BLAKE2S_BLOCKBYTES);
+		memcpy(block, key, keylen);
+		blake2s_update(S, block, BLAKE2S_BLOCKBYTES);
+		memzero_explicit(block, BLAKE2S_BLOCKBYTES);
+	}
+	return 0;
+}
+
+#define G(r,i,a,b,c,d)                                  \
+	do {                                            \
+		a = a + b + m[blake2s_sigma[r][2*i+0]]; \
+		d = rotr32(d ^ a, 16);                  \
+		c = c + d;                              \
+		b = rotr32(b ^ c, 12);                  \
+		a = a + b + m[blake2s_sigma[r][2*i+1]]; \
+		d = rotr32(d ^ a, 8);                   \
+		c = c + d;                              \
+		b = rotr32(b ^ c, 7);                   \
+	} while(0)
+
+#define ROUND(r)                                \
+	do {                                    \
+		G(r,0,v[ 0],v[ 4],v[ 8],v[12]); \
+		G(r,1,v[ 1],v[ 5],v[ 9],v[13]); \
+		G(r,2,v[ 2],v[ 6],v[10],v[14]); \
+		G(r,3,v[ 3],v[ 7],v[11],v[15]); \
+		G(r,4,v[ 0],v[ 5],v[10],v[15]); \
+		G(r,5,v[ 1],v[ 6],v[11],v[12]); \
+		G(r,6,v[ 2],v[ 7],v[ 8],v[13]); \
+		G(r,7,v[ 3],v[ 4],v[ 9],v[14]); \
+	} while(0)
+
+static void blake2s_compress(struct blake2s_state *S,
+			     const u8 in[BLAKE2S_BLOCKBYTES])
+{
+	u32 m[16];
+	u32 v[16];
+	size_t i;
+
+	for (i = 0; i < 16; ++i)
+		m[i] = load32(in + i * sizeof(m[i]));
+
+	for (i = 0; i < 8; ++i)
+		v[i] = S->h[i];
+
+	v[ 8] = blake2s_IV[0];
+	v[ 9] = blake2s_IV[1];
+	v[10] = blake2s_IV[2];
+	v[11] = blake2s_IV[3];
+	v[12] = S->t[0] ^ blake2s_IV[4];
+	v[13] = S->t[1] ^ blake2s_IV[5];
+	v[14] = S->f[0] ^ blake2s_IV[6];
+	v[15] = S->f[1] ^ blake2s_IV[7];
+
+	ROUND(0);
+	ROUND(1);
+	ROUND(2);
+	ROUND(3);
+	ROUND(4);
+	ROUND(5);
+	ROUND(6);
+	ROUND(7);
+	ROUND(8);
+	ROUND(9);
+
+	for (i = 0; i < 8; ++i)
+		S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
+}
+
+#undef G
+#undef ROUND
+
+int blake2s_update(struct blake2s_state *S, const void *pin, size_t inlen)
+{
+	const unsigned char *in = (const unsigned char *)pin;
+
+	if (inlen > 0) {
+		size_t left = S->buflen;
+		size_t fill = BLAKE2S_BLOCKBYTES - left;
+
+		if (inlen > fill) {
+			S->buflen = 0;
+			/* Fill buffer */
+			memcpy(S->buf + left, in, fill);
+			blake2s_increment_counter(S, BLAKE2S_BLOCKBYTES);
+			/* Compress */
+			blake2s_compress(S, S->buf);
+			in += fill;
+			inlen -= fill;
+			while (inlen > BLAKE2S_BLOCKBYTES) {
+				blake2s_increment_counter(S, BLAKE2S_BLOCKBYTES);
+				blake2s_compress(S, in);
+				in += BLAKE2S_BLOCKBYTES;
+				inlen -= BLAKE2S_BLOCKBYTES;
+			}
+		}
+		memcpy(S->buf + S->buflen, in, inlen);
+		S->buflen += inlen;
+	}
+	return 0;
+}
+
+int blake2s_final(struct blake2s_state *S, void *out, size_t outlen)
+{
+	u8 buffer[BLAKE2S_OUTBYTES] = {0};
+	size_t i;
+
+	if (out == NULL || outlen < S->outlen)
+		return -1;
+
+	if (blake2s_is_lastblock(S))
+		return -1;
+
+	blake2s_increment_counter(S, (u32)S->buflen);
+	blake2s_set_lastblock(S);
+	/* Padding */
+	memset(S->buf + S->buflen, 0, BLAKE2S_BLOCKBYTES - S->buflen);
+	blake2s_compress(S, S->buf);
+
+	/* Output full hash to temp buffer */
+	for (i = 0; i < 8; ++i)
+		store32(buffer + sizeof(S->h[i]) * i, S->h[i]);
+
+	memcpy(out, buffer, outlen);
+	memzero_explicit(buffer, sizeof(buffer));
+	return 0;
+}
+
+/* crypto API glue code */
+
+struct digest_desc_ctx {
+	struct blake2s_state S[1];
+};
+
+static int digest_init(struct shash_desc *desc)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	int ret;
+
+	ret = blake2s_init(ctx->S, digest_size);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int digest_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	int ret;
+
+	ret = blake2s_update(ctx->S, data, length);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
+static int digest_final(struct shash_desc *desc, u8 *out)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	const unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	int ret;
+
+	ret = blake2s_final(ctx->S, out, digest_size);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
+static int digest_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	const unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	int ret;
+
+	ret = blake2s_update(ctx->S, data, len);
+	if (ret)
+		return -EINVAL;
+	ret = blake2s_final(ctx->S, out, digest_size);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct shash_alg blake2s_algs[] = { {
+	.digestsize	=	BLAKE2S_256_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2s",
+		.cra_driver_name	=	"blake2s-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2S_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2S_128_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2s-128",
+		.cra_driver_name	=	"blake2s-128-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2S_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2S_160_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2s-160",
+		.cra_driver_name	=	"blake2s-160-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2S_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2S_224_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2s-224",
+		.cra_driver_name	=	"blake2s-224-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	BLAKE2S_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+}, {
+	.digestsize	=	BLAKE2S_256_DIGEST_SIZE,
+	.init		=	digest_init,
+	.update		=	digest_update,
+	.final		=	digest_final,
+	.finup		=	digest_finup,
+	.descsize	=	sizeof(struct digest_desc_ctx),
+	.base		=	{
+		.cra_name		=	"blake2s-256",
+		.cra_driver_name	=	"blake2s-256-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	1,
+		.cra_blocksize		=	BLAKE2S_BLOCKBYTES,
+		.cra_ctxsize		=	0,
+		.cra_module		=	THIS_MODULE,
+	}
+} };
+
+static int __init blake2s_mod_init(void)
+{
+	return crypto_register_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+}
+
+static void __exit blake2s_mod_fini(void)
+{
+	crypto_unregister_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+}
+
+subsys_initcall(blake2s_mod_init);
+module_exit(blake2s_mod_fini);
+
+MODULE_AUTHOR("David Sterba <kdave@kernel.org>");
+MODULE_DESCRIPTION("BLAKE2s reference implementation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("blake2s");
+MODULE_ALIAS_CRYPTO("blake2s-generic");
+MODULE_ALIAS_CRYPTO("blake2s-128");
+MODULE_ALIAS_CRYPTO("blake2s-128-generic");
+MODULE_ALIAS_CRYPTO("blake2s-160");
+MODULE_ALIAS_CRYPTO("blake2s-160-generic");
+MODULE_ALIAS_CRYPTO("blake2s-224");
+MODULE_ALIAS_CRYPTO("blake2s-224-generic");
+MODULE_ALIAS_CRYPTO("blake2s-256");
+MODULE_ALIAS_CRYPTO("blake2s-256-generic");
-- 
2.23.0

