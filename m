Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA32EC2BBCD
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6485122D07
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLPABg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgLOXyc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:54:32 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH 3/5] crypto: blake2b - export helpers for optimized implementations
Date:   Tue, 15 Dec 2020 15:47:06 -0800
Message-Id: <20201215234708.105527-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201215234708.105527-1-ebiggers@kernel.org>
References: <20201215234708.105527-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding architecture-specific implementations of
BLAKE2b, create a header <crypto/blake2b.h> that contains common
constants, structs, and helper functions for BLAKE2b.

Furthermore, export the BLAKE2b generic setkey(), init(), update(), and
final() functions, and add functions __crypto_blake2b_update() and
__crypto_blake2b_final() which take a pointer to a
blake2b_compress_blocks_t function.

This way, optimized implementations of BLAKE2b only have to provide an
implementation of blake2b_compress_blocks_t.  (This is modeled on how
the nhpoly1305 implementations work.  Also, the prototype of
blake2b_compress_blocks_t is meant to be similar to that of
blake2s_compress_arch().)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2b_generic.c | 100 +++++++++++++++++++++------------------
 include/crypto/blake2b.h |  54 +++++++++++++++++++++
 2 files changed, 109 insertions(+), 45 deletions(-)
 create mode 100644 include/crypto/blake2b.h

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 0e38e3e48297c..fd5159b7aa9f2 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -23,27 +23,9 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
+#include <crypto/blake2b.h>
 #include <crypto/internal/hash.h>
 
-
-enum blake2b_lengths {
-	BLAKE2B_BLOCK_SIZE = 128,
-	BLAKE2B_KEY_SIZE = 64,
-
-	BLAKE2B_160_HASH_SIZE = 20,
-	BLAKE2B_256_HASH_SIZE =	32,
-	BLAKE2B_384_HASH_SIZE = 48,
-	BLAKE2B_512_HASH_SIZE = 64,
-};
-
-struct blake2b_state {
-	u64      h[8];
-	u64      t[2];
-	u64      f[2];
-	u8       buf[BLAKE2B_BLOCK_SIZE];
-	size_t   buflen;
-};
-
 static const u64 blake2b_IV[8] = {
 	0x6a09e667f3bcc908ULL, 0xbb67ae8584caa73bULL,
 	0x3c6ef372fe94f82bULL, 0xa54ff53a5f1d36f1ULL,
@@ -96,8 +78,8 @@ static void blake2b_increment_counter(struct blake2b_state *S, const u64 inc)
 		G(r,7,v[ 3],v[ 4],v[ 9],v[14]); \
 	} while (0)
 
-static void blake2b_compress(struct blake2b_state *S,
-			     const u8 block[BLAKE2B_BLOCK_SIZE])
+static void blake2b_compress_generic(struct blake2b_state *S,
+				     const u8 block[BLAKE2B_BLOCK_SIZE])
 {
 	u64 m[16];
 	u64 v[16];
@@ -140,12 +122,18 @@ static void blake2b_compress(struct blake2b_state *S,
 #undef G
 #undef ROUND
 
-struct blake2b_tfm_ctx {
-	u8 key[BLAKE2B_KEY_SIZE];
-	unsigned int keylen;
-};
+static void blake2b_compress_blocks_generic(struct blake2b_state *S,
+					    const u8 *in, size_t nblocks,
+					    unsigned int inc)
+{
+	do {
+		blake2b_increment_counter(S, inc);
+		blake2b_compress_generic(S, in);
+		in += BLAKE2B_BLOCK_SIZE;
+	} while (--nblocks);
+}
 
-static int blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
+int crypto_blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
 			  unsigned int keylen)
 {
 	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(tfm);
@@ -158,8 +146,9 @@ static int blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_blake2b_setkey);
 
-static int blake2b_init(struct shash_desc *desc)
+int crypto_blake2b_init(struct shash_desc *desc)
 {
 	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct blake2b_state *state = shash_desc_ctx(desc);
@@ -181,9 +170,19 @@ static int blake2b_init(struct shash_desc *desc)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_blake2b_init);
+
+int crypto_blake2b_update(struct shash_desc *desc,
+			  const u8 *in, unsigned int inlen)
+{
+	return __crypto_blake2b_update(desc, in, inlen,
+				       blake2b_compress_blocks_generic);
+}
+EXPORT_SYMBOL_GPL(crypto_blake2b_update);
 
-static int blake2b_update(struct shash_desc *desc, const u8 *in,
-			  unsigned int inlen)
+int __crypto_blake2b_update(struct shash_desc *desc,
+			    const u8 *in, unsigned int inlen,
+			    blake2b_compress_blocks_t compress)
 {
 	struct blake2b_state *state = shash_desc_ctx(desc);
 	const size_t left = state->buflen;
@@ -194,18 +193,19 @@ static int blake2b_update(struct shash_desc *desc, const u8 *in,
 
 	if (inlen > fill) {
 		state->buflen = 0;
-		/* Fill buffer */
 		memcpy(state->buf + left, in, fill);
-		blake2b_increment_counter(state, BLAKE2B_BLOCK_SIZE);
-		/* Compress */
-		blake2b_compress(state, state->buf);
+		(*compress)(state, state->buf, 1, BLAKE2B_BLOCK_SIZE);
 		in += fill;
 		inlen -= fill;
-		while (inlen > BLAKE2B_BLOCK_SIZE) {
-			blake2b_increment_counter(state, BLAKE2B_BLOCK_SIZE);
-			blake2b_compress(state, in);
-			in += BLAKE2B_BLOCK_SIZE;
-			inlen -= BLAKE2B_BLOCK_SIZE;
+		if (inlen > BLAKE2B_BLOCK_SIZE) {
+			/* Hash one less (full) block than strictly possible */
+			size_t nbytes = round_up(inlen - BLAKE2B_BLOCK_SIZE,
+						 BLAKE2B_BLOCK_SIZE);
+
+			(*compress)(state, in, nbytes / BLAKE2B_BLOCK_SIZE,
+				    BLAKE2B_BLOCK_SIZE);
+			in += nbytes;
+			inlen -= nbytes;
 		}
 	}
 	memcpy(state->buf + state->buflen, in, inlen);
@@ -213,20 +213,29 @@ static int blake2b_update(struct shash_desc *desc, const u8 *in,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__crypto_blake2b_update);
 
-static int blake2b_final(struct shash_desc *desc, u8 *out)
+int crypto_blake2b_final(struct shash_desc *desc, u8 *out)
+{
+	return __crypto_blake2b_final(desc, out,
+				      blake2b_compress_blocks_generic);
+}
+EXPORT_SYMBOL_GPL(crypto_blake2b_final);
+
+int __crypto_blake2b_final(struct shash_desc *desc, u8 *out,
+			   blake2b_compress_blocks_t compress)
 {
 	struct blake2b_state *state = shash_desc_ctx(desc);
 	const int digestsize = crypto_shash_digestsize(desc->tfm);
 	size_t i;
 
-	blake2b_increment_counter(state, state->buflen);
 	/* Set last block */
 	state->f[0] = (u64)-1;
 	/* Padding */
 	memset(state->buf + state->buflen, 0,
 	       BLAKE2B_BLOCK_SIZE - state->buflen);
-	blake2b_compress(state, state->buf);
+
+	(*compress)(state, state->buf, 1, state->buflen);
 
 	/* Avoid temporary buffer and switch the internal output to LE order */
 	for (i = 0; i < ARRAY_SIZE(state->h); i++)
@@ -235,6 +244,7 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 	memcpy(out, state->h, digestsize);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__crypto_blake2b_final);
 
 #define BLAKE2B_ALG(name, driver_name, digest_size)			\
 	{								\
@@ -246,10 +256,10 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx), \
 		.base.cra_module	= THIS_MODULE,			\
 		.digestsize		= digest_size,			\
-		.setkey			= blake2b_setkey,		\
-		.init			= blake2b_init,			\
-		.update			= blake2b_update,		\
-		.final			= blake2b_final,		\
+		.setkey			= crypto_blake2b_setkey,	\
+		.init			= crypto_blake2b_init,		\
+		.update			= crypto_blake2b_update,	\
+		.final			= crypto_blake2b_final,		\
 		.descsize		= sizeof(struct blake2b_state),	\
 	}
 
diff --git a/include/crypto/blake2b.h b/include/crypto/blake2b.h
new file mode 100644
index 0000000000000..ced3ba5b45c8d
--- /dev/null
+++ b/include/crypto/blake2b.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _CRYPTO_BLAKE2B_H
+#define _CRYPTO_BLAKE2B_H
+
+#include <linux/types.h>
+
+enum blake2b_lengths {
+	BLAKE2B_BLOCK_SIZE = 128,
+	BLAKE2B_KEY_SIZE = 64,
+
+	BLAKE2B_160_HASH_SIZE = 20,
+	BLAKE2B_256_HASH_SIZE =	32,
+	BLAKE2B_384_HASH_SIZE = 48,
+	BLAKE2B_512_HASH_SIZE = 64,
+};
+
+struct blake2b_state {
+	/* 'h', 't', and 'f' are used in assembly code, so keep them as-is. */
+	u64      h[8];
+	u64      t[2];
+	u64      f[2];
+	u8       buf[BLAKE2B_BLOCK_SIZE];
+	size_t   buflen;
+};
+
+struct blake2b_tfm_ctx {
+	u8 key[BLAKE2B_KEY_SIZE];
+	unsigned int keylen;
+};
+
+typedef void (*blake2b_compress_blocks_t)(struct blake2b_state *S,
+					  const u8 *in, size_t nblocks,
+					  unsigned int inc);
+
+struct crypto_shash;
+struct shash_desc;
+
+int crypto_blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
+			  unsigned int keylen);
+
+int crypto_blake2b_init(struct shash_desc *desc);
+
+int crypto_blake2b_update(struct shash_desc *desc,
+			  const u8 *in, unsigned int inlen);
+int __crypto_blake2b_update(struct shash_desc *desc,
+			    const u8 *in, unsigned int inlen,
+			    blake2b_compress_blocks_t compress);
+
+int crypto_blake2b_final(struct shash_desc *desc, u8 *out);
+int __crypto_blake2b_final(struct shash_desc *desc, u8 *out,
+			   blake2b_compress_blocks_t compress);
+
+#endif /* _CRYPTO_BLAKE2B_H */
-- 
2.29.2

