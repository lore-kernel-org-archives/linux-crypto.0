Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBA4C7EE22
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 04:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbjEKEaj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 00:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjEKEah (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 00:30:37 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177753C30
        for <linux-crypto@vger.kernel.org>; Wed, 10 May 2023 21:30:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pwxwi-007ZXn-PE; Thu, 11 May 2023 12:30:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 May 2023 12:30:29 +0800
Date:   Thu, 11 May 2023 12:30:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ross Philipson <ross.philipson@oracle.com>
Subject: [PATCH] crypto: lib/sha256 - Use generic code from sha256_base
Message-ID: <ZFxvZTGcSgPHG2aI@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of duplicating the sha256 block processing code, reuse
the common code from crypto/sha256_base.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/sha256_base.h |   50 +++++++++++++++++++++--------
 lib/crypto/sha256.c          |   73 +++++++++++--------------------------------
 2 files changed, 55 insertions(+), 68 deletions(-)

diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 76173c613058..ab904d82236f 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -8,13 +8,12 @@
 #ifndef _CRYPTO_SHA256_BASE_H
 #define _CRYPTO_SHA256_BASE_H
 
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
-#include <linux/crypto.h>
-#include <linux/module.h>
 #include <linux/string.h>
-
-#include <asm/unaligned.h>
+#include <linux/types.h>
 
 typedef void (sha256_block_fn)(struct sha256_state *sst, u8 const *src,
 			       int blocks);
@@ -35,12 +34,11 @@ static inline int sha256_base_init(struct shash_desc *desc)
 	return 0;
 }
 
-static inline int sha256_base_do_update(struct shash_desc *desc,
-					const u8 *data,
-					unsigned int len,
-					sha256_block_fn *block_fn)
+static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
+					    const u8 *data,
+					    unsigned int len,
+					    sha256_block_fn *block_fn)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
 
 	sctx->count += len;
@@ -73,11 +71,20 @@ static inline int sha256_base_do_update(struct shash_desc *desc,
 	return 0;
 }
 
-static inline int sha256_base_do_finalize(struct shash_desc *desc,
-					  sha256_block_fn *block_fn)
+static inline int sha256_base_do_update(struct shash_desc *desc,
+					const u8 *data,
+					unsigned int len,
+					sha256_block_fn *block_fn)
 {
-	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
 	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	return lib_sha256_base_do_update(sctx, data, len, block_fn);
+}
+
+static inline int lib_sha256_base_do_finalize(struct sha256_state *sctx,
+					      sha256_block_fn *block_fn)
+{
+	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
 	__be64 *bits = (__be64 *)(sctx->buf + bit_offset);
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
 
@@ -96,10 +103,17 @@ static inline int sha256_base_do_finalize(struct shash_desc *desc,
 	return 0;
 }
 
-static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
+static inline int sha256_base_do_finalize(struct shash_desc *desc,
+					  sha256_block_fn *block_fn)
 {
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
 	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	return lib_sha256_base_do_finalize(sctx, block_fn);
+}
+
+static inline int lib_sha256_base_finish(struct sha256_state *sctx, u8 *out,
+					 unsigned int digest_size)
+{
 	__be32 *digest = (__be32 *)out;
 	int i;
 
@@ -110,4 +124,12 @@ static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
+static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
+{
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	return lib_sha256_base_finish(sctx, out, digest_size);
+}
+
 #endif /* _CRYPTO_SHA256_BASE_H */
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index b32b6cc016a8..3ac1ef8677db 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -11,12 +11,11 @@
  * Copyright (c) 2014 Red Hat Inc.
  */
 
-#include <linux/bitops.h>
-#include <linux/export.h>
+#include <asm/unaligned.h>
+#include <crypto/sha256_base.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <crypto/sha2.h>
-#include <asm/unaligned.h>
 
 static const u32 SHA256_K[] = {
 	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
@@ -119,74 +118,40 @@ static void sha256_transform(u32 *state, const u8 *input, u32 *W)
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
 }
 
-void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
+static void sha256_transform_blocks(struct sha256_state *sctx,
+				    const u8 *input, int blocks)
 {
-	unsigned int partial, done;
-	const u8 *src;
 	u32 W[64];
 
-	partial = sctx->count & 0x3f;
-	sctx->count += len;
-	done = 0;
-	src = data;
-
-	if ((partial + len) > 63) {
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buf + partial, data, done + 64);
-			src = sctx->buf;
-		}
+	do {
+		sha256_transform(sctx->state, input, W);
+		input += SHA256_BLOCK_SIZE;
+	} while (--blocks);
 
-		do {
-			sha256_transform(sctx->state, src, W);
-			done += 64;
-			src = data + done;
-		} while (done + 63 < len);
-
-		memzero_explicit(W, sizeof(W));
+	memzero_explicit(W, sizeof(W));
+}
 
-		partial = 0;
-	}
-	memcpy(sctx->buf + partial, src, len - done);
+void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
+{
+	lib_sha256_base_do_update(sctx, data, len, sha256_transform_blocks);
 }
 EXPORT_SYMBOL(sha256_update);
 
-static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
+static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_size)
 {
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	unsigned int index, pad_len;
-	int i;
-	static const u8 padding[64] = { 0x80, };
-
-	/* Save number of bits */
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64. */
-	index = sctx->count & 0x3f;
-	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
-	sha256_update(sctx, padding, pad_len);
-
-	/* Append length (before padding) */
-	sha256_update(sctx, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < digest_words; i++)
-		put_unaligned_be32(sctx->state[i], &dst[i]);
-
-	/* Zeroize sensitive information. */
-	memzero_explicit(sctx, sizeof(*sctx));
+	lib_sha256_base_do_finalize(sctx, sha256_transform_blocks);
+	lib_sha256_base_finish(sctx, out, digest_size);
 }
 
 void sha256_final(struct sha256_state *sctx, u8 *out)
 {
-	__sha256_final(sctx, out, 8);
+	__sha256_final(sctx, out, 32);
 }
 EXPORT_SYMBOL(sha256_final);
 
 void sha224_final(struct sha256_state *sctx, u8 *out)
 {
-	__sha256_final(sctx, out, 7);
+	__sha256_final(sctx, out, 28);
 }
 EXPORT_SYMBOL(sha224_final);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
