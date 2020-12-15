Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F239C3526B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9BF22D05
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgLPABe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgLOXyb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:54:31 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH 1/5] crypto: blake2b - rename constants for consistency with blake2s
Date:   Tue, 15 Dec 2020 15:47:04 -0800
Message-Id: <20201215234708.105527-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201215234708.105527-1-ebiggers@kernel.org>
References: <20201215234708.105527-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Rename some BLAKE2b-related constants to be consistent with the names
used in the BLAKE2s implementation (see include/crypto/blake2s.h):

	BLAKE2B_*_DIGEST_SIZE  => BLAKE2B_*_HASH_SIZE
	BLAKE2B_BLOCKBYTES     => BLAKE2B_BLOCK_SIZE
	BLAKE2B_KEYBYTES       => BLAKE2B_KEY_SIZE

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2b_generic.c | 58 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index a2ffe60e06d34..83942f511075e 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -25,21 +25,22 @@
 #include <linux/bitops.h>
 #include <crypto/internal/hash.h>
 
-#define BLAKE2B_160_DIGEST_SIZE		(160 / 8)
-#define BLAKE2B_256_DIGEST_SIZE		(256 / 8)
-#define BLAKE2B_384_DIGEST_SIZE		(384 / 8)
-#define BLAKE2B_512_DIGEST_SIZE		(512 / 8)
-
-enum blake2b_constant {
-	BLAKE2B_BLOCKBYTES    = 128,
-	BLAKE2B_KEYBYTES      = 64,
+
+enum blake2b_lengths {
+	BLAKE2B_BLOCK_SIZE = 128,
+	BLAKE2B_KEY_SIZE = 64,
+
+	BLAKE2B_160_HASH_SIZE = 20,
+	BLAKE2B_256_HASH_SIZE =	32,
+	BLAKE2B_384_HASH_SIZE = 48,
+	BLAKE2B_512_HASH_SIZE = 64,
 };
 
 struct blake2b_state {
 	u64      h[8];
 	u64      t[2];
 	u64      f[2];
-	u8       buf[BLAKE2B_BLOCKBYTES];
+	u8       buf[BLAKE2B_BLOCK_SIZE];
 	size_t   buflen;
 };
 
@@ -96,7 +97,7 @@ static void blake2b_increment_counter(struct blake2b_state *S, const u64 inc)
 	} while (0)
 
 static void blake2b_compress(struct blake2b_state *S,
-			     const u8 block[BLAKE2B_BLOCKBYTES])
+			     const u8 block[BLAKE2B_BLOCK_SIZE])
 {
 	u64 m[16];
 	u64 v[16];
@@ -140,7 +141,7 @@ static void blake2b_compress(struct blake2b_state *S,
 #undef ROUND
 
 struct blake2b_tfm_ctx {
-	u8 key[BLAKE2B_KEYBYTES];
+	u8 key[BLAKE2B_KEY_SIZE];
 	unsigned int keylen;
 };
 
@@ -149,7 +150,7 @@ static int blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
-	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES)
+	if (keylen == 0 || keylen > BLAKE2B_KEY_SIZE)
 		return -EINVAL;
 
 	memcpy(tctx->key, key, keylen);
@@ -176,7 +177,7 @@ static int blake2b_init(struct shash_desc *desc)
 		 * _final will process it
 		 */
 		memcpy(state->buf, tctx->key, tctx->keylen);
-		state->buflen = BLAKE2B_BLOCKBYTES;
+		state->buflen = BLAKE2B_BLOCK_SIZE;
 	}
 	return 0;
 }
@@ -186,7 +187,7 @@ static int blake2b_update(struct shash_desc *desc, const u8 *in,
 {
 	struct blake2b_state *state = shash_desc_ctx(desc);
 	const size_t left = state->buflen;
-	const size_t fill = BLAKE2B_BLOCKBYTES - left;
+	const size_t fill = BLAKE2B_BLOCK_SIZE - left;
 
 	if (!inlen)
 		return 0;
@@ -195,16 +196,16 @@ static int blake2b_update(struct shash_desc *desc, const u8 *in,
 		state->buflen = 0;
 		/* Fill buffer */
 		memcpy(state->buf + left, in, fill);
-		blake2b_increment_counter(state, BLAKE2B_BLOCKBYTES);
+		blake2b_increment_counter(state, BLAKE2B_BLOCK_SIZE);
 		/* Compress */
 		blake2b_compress(state, state->buf);
 		in += fill;
 		inlen -= fill;
-		while (inlen > BLAKE2B_BLOCKBYTES) {
-			blake2b_increment_counter(state, BLAKE2B_BLOCKBYTES);
+		while (inlen > BLAKE2B_BLOCK_SIZE) {
+			blake2b_increment_counter(state, BLAKE2B_BLOCK_SIZE);
 			blake2b_compress(state, in);
-			in += BLAKE2B_BLOCKBYTES;
-			inlen -= BLAKE2B_BLOCKBYTES;
+			in += BLAKE2B_BLOCK_SIZE;
+			inlen -= BLAKE2B_BLOCK_SIZE;
 		}
 	}
 	memcpy(state->buf + state->buflen, in, inlen);
@@ -223,7 +224,8 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 	/* Set last block */
 	state->f[0] = (u64)-1;
 	/* Padding */
-	memset(state->buf + state->buflen, 0, BLAKE2B_BLOCKBYTES - state->buflen);
+	memset(state->buf + state->buflen, 0,
+	       BLAKE2B_BLOCK_SIZE - state->buflen);
 	blake2b_compress(state, state->buf);
 
 	/* Avoid temporary buffer and switch the internal output to LE order */
@@ -240,10 +242,10 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_driver_name	= "blake2b-160-generic",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_160_DIGEST_SIZE,
+		.digestsize		= BLAKE2B_160_HASH_SIZE,
 		.setkey			= blake2b_setkey,
 		.init			= blake2b_init,
 		.update			= blake2b_update,
@@ -254,10 +256,10 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_driver_name	= "blake2b-256-generic",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_256_DIGEST_SIZE,
+		.digestsize		= BLAKE2B_256_HASH_SIZE,
 		.setkey			= blake2b_setkey,
 		.init			= blake2b_init,
 		.update			= blake2b_update,
@@ -268,10 +270,10 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_driver_name	= "blake2b-384-generic",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_384_DIGEST_SIZE,
+		.digestsize		= BLAKE2B_384_HASH_SIZE,
 		.setkey			= blake2b_setkey,
 		.init			= blake2b_init,
 		.update			= blake2b_update,
@@ -282,10 +284,10 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_driver_name	= "blake2b-512-generic",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
+		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
+		.digestsize		= BLAKE2B_512_HASH_SIZE,
 		.setkey			= blake2b_setkey,
 		.init			= blake2b_init,
 		.update			= blake2b_update,
-- 
2.29.2

