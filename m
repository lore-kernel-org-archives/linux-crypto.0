Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068ACC3526A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE425238A0
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgLQWZm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 17:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732063AbgLQWZm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 17:25:42 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v2 03/11] crypto: blake2b - export helpers for optimized implementations
Date:   Thu, 17 Dec 2020 14:21:30 -0800
Message-Id: <20201217222138.170526-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217222138.170526-1-ebiggers@kernel.org>
References: <20201217222138.170526-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding optimized implementations of BLAKE2b (as well
as possibly supporting BLAKE2b through the library API in the future),
create headers <crypto/blake2b.h> and <crypto/internal/blake2b.h> that
contain common constants, structs, and helper functions for BLAKE2b.

Furthermore, export helper functions that reduce the amount of
boilerplate that needs to be duplicated in optimized implementations of
BLAKE2b.  This includes exporting the generic setkey() and init()
functions as-is, as well as exporting the update() and final() functions
with a function pointer argument added to provide an implementation of
the compression function.  (The compression function is the only thing
that optimized implementations really want to override.)

This is similar to what is already done for nhpoly1305, sha1, and
sha256.  It's also similar to what I'll be doing for blake2s.

I didn't go so far as to put the helper functions in a separate module
blake2b_helpers.ko, like I'm doing for BLAKE2s.  This would be needed if
BLAKE2b gets exposed through the library API, but it can be done later.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2b_generic.c          | 95 ++++++++++++++++---------------
 include/crypto/blake2b.h          | 27 +++++++++
 include/crypto/internal/blake2b.h | 33 +++++++++++
 3 files changed, 110 insertions(+), 45 deletions(-)
 create mode 100644 include/crypto/blake2b.h
 create mode 100644 include/crypto/internal/blake2b.h

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 0e38e3e48297c..ee5084f3c92e1 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -23,27 +23,9 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
+#include <crypto/internal/blake2b.h>
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
+static void blake2b_compress_one_generic(struct blake2b_state *S,
+					 const u8 block[BLAKE2B_BLOCK_SIZE])
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
+void blake2b_compress_generic(struct blake2b_state *state,
+			      const u8 *block, size_t nblocks, u32 inc)
+{
+	do {
+		blake2b_increment_counter(state, inc);
+		blake2b_compress_one_generic(state, block);
+		block += BLAKE2B_BLOCK_SIZE;
+	} while (--nblocks);
+}
+EXPORT_SYMBOL_GPL(blake2b_compress_generic);
 
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
@@ -181,9 +170,10 @@ static int blake2b_init(struct shash_desc *desc)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_blake2b_init);
 
-static int blake2b_update(struct shash_desc *desc, const u8 *in,
-			  unsigned int inlen)
+int crypto_blake2b_update(struct shash_desc *desc, const u8 *in,
+			  unsigned int inlen, blake2b_compress_t compress)
 {
 	struct blake2b_state *state = shash_desc_ctx(desc);
 	const size_t left = state->buflen;
@@ -194,18 +184,19 @@ static int blake2b_update(struct shash_desc *desc, const u8 *in,
 
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
@@ -213,20 +204,28 @@ static int blake2b_update(struct shash_desc *desc, const u8 *in,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_blake2b_update);
+
+static int crypto_blake2b_update_generic(struct shash_desc *desc,
+					 const u8 *in, unsigned int inlen)
+{
+	return crypto_blake2b_update(desc, in, inlen, blake2b_compress_generic);
+}
 
-static int blake2b_final(struct shash_desc *desc, u8 *out)
+int crypto_blake2b_final(struct shash_desc *desc, u8 *out,
+			 blake2b_compress_t compress)
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
@@ -235,6 +234,12 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 	memcpy(out, state->h, digestsize);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_blake2b_final);
+
+static int crypto_blake2b_final_generic(struct shash_desc *desc, u8 *out)
+{
+	return crypto_blake2b_final(desc, out, blake2b_compress_generic);
+}
 
 #define BLAKE2B_ALG(name, driver_name, digest_size)			\
 	{								\
@@ -246,10 +251,10 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx), \
 		.base.cra_module	= THIS_MODULE,			\
 		.digestsize		= digest_size,			\
-		.setkey			= blake2b_setkey,		\
-		.init			= blake2b_init,			\
-		.update			= blake2b_update,		\
-		.final			= blake2b_final,		\
+		.setkey			= crypto_blake2b_setkey,	\
+		.init			= crypto_blake2b_init,		\
+		.update			= crypto_blake2b_update_generic, \
+		.final			= crypto_blake2b_final_generic,	\
 		.descsize		= sizeof(struct blake2b_state),	\
 	}
 
diff --git a/include/crypto/blake2b.h b/include/crypto/blake2b.h
new file mode 100644
index 0000000000000..7c3045df597c0
--- /dev/null
+++ b/include/crypto/blake2b.h
@@ -0,0 +1,27 @@
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
+#endif /* _CRYPTO_BLAKE2B_H */
diff --git a/include/crypto/internal/blake2b.h b/include/crypto/internal/blake2b.h
new file mode 100644
index 0000000000000..822dff79bab91
--- /dev/null
+++ b/include/crypto/internal/blake2b.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _CRYPTO_INTERNAL_BLAKE2B_H
+#define _CRYPTO_INTERNAL_BLAKE2B_H
+
+#include <crypto/blake2b.h>
+
+struct blake2b_tfm_ctx {
+	u8 key[BLAKE2B_KEY_SIZE];
+	unsigned int keylen;
+};
+
+void blake2b_compress_generic(struct blake2b_state *state,
+			      const u8 *block, size_t nblocks, u32 inc);
+
+typedef void (*blake2b_compress_t)(struct blake2b_state *state,
+				   const u8 *block, size_t nblocks, u32 inc);
+
+struct crypto_shash;
+struct shash_desc;
+
+int crypto_blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
+			  unsigned int keylen);
+
+int crypto_blake2b_init(struct shash_desc *desc);
+
+int crypto_blake2b_update(struct shash_desc *desc, const u8 *in,
+			  unsigned int inlen, blake2b_compress_t compress);
+
+int crypto_blake2b_final(struct shash_desc *desc, u8 *out,
+			 blake2b_compress_t compress);
+
+#endif /* _CRYPTO_INTERNAL_BLAKE2B_H */
-- 
2.29.2

