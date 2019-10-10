Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12CFC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 14:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8795F206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 14:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfJJOJ7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 10:09:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:55760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbfJJOJ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 10:09:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25D3EAD26;
        Thu, 10 Oct 2019 14:09:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00B3DDA7E3; Thu, 10 Oct 2019 16:10:09 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, ard.biesheuvel@linaro.org
Subject: [PATCH v3] crypto: add blake2b generic implementation
Date:   Thu, 10 Oct 2019 16:10:05 +0200
Message-Id: <e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The patch brings support of several BLAKE2 variants (2b with various
digest lengths).  The keyed digest is supported, using tfm->setkey call.
The in-tree user will be btrfs (for checksumming), we're going to use
the BLAKE2b-256 variant.

The code is reference implementation taken from the official sources and
modified only in terms of kernel coding style (whitespace, comments,
uintXX_t -> uXX types, removed unused prototypes and #ifdefs, removed
testing code, changed secure_zero_memory -> memzero_explicit, used own
helpers for unaligned reads/writes and rotations).

Signed-off-by: David Sterba <dsterba@suse.com>
---

V3:

- added 'static' to blake2b_* and removed .h declarations
- updated Kconfig help text
- replaced custom build bug check with BUILD_BUG_ON

- added .setkey to TFM, optional key, the length validation is same as
  what blake2b_init_key accepts, ie. 1..BLAKE2B_KEYBYTES

- fixed a serious bug: digestsize in all callbacks must be obtained from
  TFM, as the same functions are used for all variants but the default
  output size was used (in digest_init, digest_final, digest_finup),

I'm going to do the selftests next so the above can't happen again.

 crypto/Kconfig           |  18 ++
 crypto/Makefile          |   1 +
 crypto/blake2b_generic.c | 504 +++++++++++++++++++++++++++++++++++++++
 include/crypto/blake2b.h |  48 ++++
 4 files changed, 571 insertions(+)
 create mode 100644 crypto/blake2b_generic.c
 create mode 100644 include/crypto/blake2b.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e801450bcb1c..2b76752608ae 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -691,6 +691,24 @@ config CRYPTO_XXHASH
 	  xxHash non-cryptographic hash algorithm. Extremely fast, working at
 	  speeds close to RAM limits.
 
+config CRYPTO_BLAKE2B
+	tristate "BLAKE2b digest algorithm"
+	select CRYPTO_HASH
+	help
+	  Implementation of cryptographic hash function BLAKE2b (or just BLAKE2),
+	  optimized for 64bit platforms and can produce digests of any size
+	  between 1 to 64.  The keyed hash is also implemented.
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
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 9479e1a45d8c..2318420d3e71 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
+obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
new file mode 100644
index 000000000000..588f2c5daa2d
--- /dev/null
+++ b/crypto/blake2b_generic.c
@@ -0,0 +1,504 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0)
+/*
+ * BLAKE2b reference source code package - reference C implementations
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
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <crypto/internal/hash.h>
+#include <crypto/blake2b.h>
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
+static int blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen);
+
+static void blake2b_set_lastnode(struct blake2b_state *S)
+{
+	S->f[1] = (u64)-1;
+}
+
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
+static int blake2b_init_param(struct blake2b_state *S,
+			      const struct blake2b_param *P)
+{
+	const u8 *p = (const u8 *)(P);
+	size_t i;
+
+	blake2b_init0(S);
+
+	/* IV XOR ParamBlock */
+	for (i = 0; i < 8; ++i)
+		S->h[i] ^= get_unaligned_le64(p + sizeof(S->h[i]) * i);
+
+	S->outlen = P->digest_length;
+	return 0;
+}
+
+static int blake2b_init(struct blake2b_state *S, size_t outlen)
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
+	put_unaligned_le32(0, &P->leaf_length);
+	put_unaligned_le32(0, &P->node_offset);
+	put_unaligned_le32(0, &P->xof_length);
+	P->node_depth    = 0;
+	P->inner_length  = 0;
+	memset(P->reserved, 0, sizeof(P->reserved));
+	memset(P->salt,     0, sizeof(P->salt));
+	memset(P->personal, 0, sizeof(P->personal));
+	return blake2b_init_param(S, P);
+}
+
+static int blake2b_init_key(struct blake2b_state *S, size_t outlen,
+			 const void *key, size_t keylen)
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
+	put_unaligned_le32(0, &P->leaf_length);
+	put_unaligned_le32(0, &P->node_offset);
+	put_unaligned_le32(0, &P->xof_length);
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
+		d = ror64(d ^ a, 32);                   \
+		c = c + d;                              \
+		b = ror64(b ^ c, 24);                   \
+		a = a + b + m[blake2b_sigma[r][2*i+1]]; \
+		d = ror64(d ^ a, 16);                   \
+		c = c + d;                              \
+		b = ror64(b ^ c, 63);                   \
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
+		m[i] = get_unaligned_le64(block + i * sizeof(m[i]));
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
+static int blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen)
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
+static int blake2b_final(struct blake2b_state *S, void *out, size_t outlen)
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
+		put_unaligned_le64(S->h[i], buffer + sizeof(S->h[i]) * i);
+
+	memcpy(out, buffer, S->outlen);
+	memzero_explicit(buffer, sizeof(buffer));
+	return 0;
+}
+
+struct digest_tfm_ctx {
+	u8 key[BLAKE2B_KEYBYTES];
+	unsigned int keylen;
+};
+
+struct digest_desc_ctx {
+	struct blake2b_state S[1];
+};
+
+static int digest_setkey(struct crypto_shash *tfm, const u8 *key,
+			 unsigned int keylen)
+{
+	struct digest_tfm_ctx *mctx = crypto_shash_ctx(tfm);
+
+	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(mctx->key, key, BLAKE2B_KEYBYTES);
+	mctx->keylen = keylen;
+
+	return 0;
+}
+
+static int digest_init(struct shash_desc *desc)
+{
+	struct digest_tfm_ctx *mctx = crypto_shash_ctx(desc->tfm);
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	const int digestsize = crypto_shash_digestsize(desc->tfm);
+	int ret;
+
+	if (mctx->keylen == 0)
+		ret = blake2b_init(ctx->S, digestsize);
+	else
+		ret = blake2b_init_key(ctx->S, digestsize, mctx->key,
+				       mctx->keylen);
+	if (ret)
+		return -EINVAL;
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
+	const int digestsize = crypto_shash_digestsize(desc->tfm);
+	int ret;
+
+	ret = blake2b_final(ctx->S, out, digestsize);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
+static int digest_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
+	const int digestsize = crypto_shash_digestsize(desc->tfm);
+	int ret;
+
+	ret = blake2b_update(ctx->S, data, len);
+	if (ret)
+		return -EINVAL;
+	ret = blake2b_final(ctx->S, out, digestsize);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
+static int blake2b_cra_init(struct crypto_tfm *tfm)
+{
+	struct digest_tfm_ctx *mctx = crypto_tfm_ctx(tfm);
+
+	/* Use the unkeyed version by default */
+	memset(mctx->key, 0, BLAKE2B_KEYBYTES);
+	mctx->keylen = 0;
+
+	return 0;
+}
+
+static struct shash_alg blake2b_algs[] = {
+	{
+		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
+		.setkey			= digest_setkey,
+		.init			= digest_init,
+		.update			= digest_update,
+		.final			= digest_final,
+		.finup			= digest_finup,
+		.descsize		= sizeof(struct digest_desc_ctx),
+		.base.cra_name		= "blake2b",
+		.base.cra_driver_name	= "blake2b-generic",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_ctxsize	= 0,
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= blake2b_cra_init,
+	}, {
+		.digestsize		= BLAKE2B_160_DIGEST_SIZE,
+		.setkey			= digest_setkey,
+		.init			= digest_init,
+		.update			= digest_update,
+		.final			= digest_final,
+		.finup			= digest_finup,
+		.descsize		= sizeof(struct digest_desc_ctx),
+		.base.cra_name		= "blake2b-160",
+		.base.cra_driver_name	= "blake2b-160-generic",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_ctxsize	= 0,
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= blake2b_cra_init,
+	}, {
+		.digestsize		= BLAKE2B_256_DIGEST_SIZE,
+		.setkey			= digest_setkey,
+		.init			= digest_init,
+		.update			= digest_update,
+		.final			= digest_final,
+		.finup			= digest_finup,
+		.descsize		= sizeof(struct digest_desc_ctx),
+		.base.cra_name		= "blake2b-256",
+		.base.cra_driver_name	= "blake2b-256-generic",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_ctxsize	= 0,
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= blake2b_cra_init,
+	}, {
+		.digestsize		= BLAKE2B_384_DIGEST_SIZE,
+		.setkey			= digest_setkey,
+		.init			= digest_init,
+		.update			= digest_update,
+		.final			= digest_final,
+		.finup			= digest_finup,
+		.descsize		= sizeof(struct digest_desc_ctx),
+		.base.cra_name		= "blake2b-384",
+		.base.cra_driver_name	= "blake2b-384-generic",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_ctxsize	= 0,
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= blake2b_cra_init,
+	}, {
+		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
+		.setkey			= digest_setkey,
+		.init			= digest_init,
+		.update			= digest_update,
+		.final			= digest_final,
+		.finup			= digest_finup,
+		.descsize		= sizeof(struct digest_desc_ctx),
+		.base.cra_name		= "blake2b-512",
+		.base.cra_driver_name	= "blake2b-512-generic",
+		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_ctxsize	= 0,
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= blake2b_cra_init,
+	}
+};
+
+static int __init blake2b_mod_init(void)
+{
+	BUILD_BUG_ON(sizeof(struct blake2b_param) != BLAKE2B_OUTBYTES);
+
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
+MODULE_DESCRIPTION("BLAKE2b generic implementation");
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
diff --git a/include/crypto/blake2b.h b/include/crypto/blake2b.h
new file mode 100644
index 000000000000..197cf6f680bf
--- /dev/null
+++ b/include/crypto/blake2b.h
@@ -0,0 +1,48 @@
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
+#ifndef _CRYPTO_BLAKE2B_H
+#define _CRYPTO_BLAKE2B_H
+
+#include <linux/compiler.h>
+#include <stddef.h>
+
+#define BLAKE2B_160_DIGEST_SIZE		(160 / 8)
+#define BLAKE2B_256_DIGEST_SIZE		(256 / 8)
+#define BLAKE2B_384_DIGEST_SIZE		(384 / 8)
+#define BLAKE2B_512_DIGEST_SIZE		(512 / 8)
+
+enum blake2b_constant
+{
+	BLAKE2B_BLOCKBYTES    = 128,
+	BLAKE2B_OUTBYTES      = 64,
+	BLAKE2B_KEYBYTES      = 64,
+	BLAKE2B_SALTBYTES     = 16,
+	BLAKE2B_PERSONALBYTES = 16
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
+#endif
-- 
2.23.0

