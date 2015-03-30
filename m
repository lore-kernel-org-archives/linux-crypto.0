From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/6] crypto: sha512-generic: move to generic glue implementation
Date: Mon, 30 Mar 2015 11:36:13 +0200
Message-ID: <1427708184-2353-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37257 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbC3Jgr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:36:47 -0400
Received: by wiaa2 with SMTP id a2so120320558wia.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:36:46 -0700 (PDT)
In-Reply-To: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updated the generic SHA-512 implementation to use the
generic shared SHA-512 glue code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig          |   1 +
 crypto/sha512_generic.c | 117 +++++++-----------------------------------------
 2 files changed, 16 insertions(+), 102 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3400cf4e3cdb..880aa518c2eb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -646,6 +646,7 @@ config CRYPTO_SHA512_BASE
 
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
+	select CRYPTO_SHA512_BASE
 	select CRYPTO_HASH
 	help
 	  SHA512 secure hash standard (DFIPS 180-2).
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 1c3c3767e079..0d8e973d0d4b 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -130,123 +130,36 @@ sha512_transform(u64 *state, const u8 *input)
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
 }
 
-static int
-sha512_init(struct shash_desc *desc)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	sctx->state[0] = SHA512_H0;
-	sctx->state[1] = SHA512_H1;
-	sctx->state[2] = SHA512_H2;
-	sctx->state[3] = SHA512_H3;
-	sctx->state[4] = SHA512_H4;
-	sctx->state[5] = SHA512_H5;
-	sctx->state[6] = SHA512_H6;
-	sctx->state[7] = SHA512_H7;
-	sctx->count[0] = sctx->count[1] = 0;
-
-	return 0;
-}
-
-static int
-sha384_init(struct shash_desc *desc)
+static void sha512_generic_block_fn(int blocks, u8 const *src, u64 *state,
+				    const u8 *head, void *p)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	sctx->state[0] = SHA384_H0;
-	sctx->state[1] = SHA384_H1;
-	sctx->state[2] = SHA384_H2;
-	sctx->state[3] = SHA384_H3;
-	sctx->state[4] = SHA384_H4;
-	sctx->state[5] = SHA384_H5;
-	sctx->state[6] = SHA384_H6;
-	sctx->state[7] = SHA384_H7;
-	sctx->count[0] = sctx->count[1] = 0;
+	if (head)
+		sha512_transform(state, head);
 
-	return 0;
+	while (blocks--) {
+		sha512_transform(state, src);
+		src += SHA512_BLOCK_SIZE;
+	}
 }
 
 int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	unsigned int i, index, part_len;
-
-	/* Compute number of bytes mod 128 */
-	index = sctx->count[0] & 0x7f;
-
-	/* Update number of bytes */
-	if ((sctx->count[0] += len) < len)
-		sctx->count[1]++;
-
-        part_len = 128 - index;
-
-	/* Transform as many times as possible. */
-	if (len >= part_len) {
-		memcpy(&sctx->buf[index], data, part_len);
-		sha512_transform(sctx->state, sctx->buf);
-
-		for (i = part_len; i + 127 < len; i+=128)
-			sha512_transform(sctx->state, &data[i]);
-
-		index = 0;
-	} else {
-		i = 0;
-	}
-
-	/* Buffer remaining input */
-	memcpy(&sctx->buf[index], &data[i], len - i);
-
-	return 0;
+	return sha512_base_do_update(desc, data, len, sha512_generic_block_fn,
+				     NULL);
 }
 EXPORT_SYMBOL(crypto_sha512_update);
 
 static int
 sha512_final(struct shash_desc *desc, u8 *hash)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-        static u8 padding[128] = { 0x80, };
-	__be64 *dst = (__be64 *)hash;
-	__be64 bits[2];
-	unsigned int index, pad_len;
-	int i;
-
-	/* Save number of bits */
-	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
-
-	/* Pad out to 112 mod 128. */
-	index = sctx->count[0] & 0x7f;
-	pad_len = (index < 112) ? (112 - index) : ((128+112) - index);
-	crypto_sha512_update(desc, padding, pad_len);
-
-	/* Append length (before padding) */
-	crypto_sha512_update(desc, (const u8 *)bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be64(sctx->state[i]);
-
-	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(struct sha512_state));
-
-	return 0;
-}
-
-static int sha384_final(struct shash_desc *desc, u8 *hash)
-{
-	u8 D[64];
-
-	sha512_final(desc, D);
-
-	memcpy(hash, D, 48);
-	memzero_explicit(D, 64);
-
-	return 0;
+	sha512_base_do_finalize(desc, sha512_generic_block_fn, NULL);
+	return sha512_base_finish(desc, hash);
 }
 
 static struct shash_alg sha512_algs[2] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
-	.init		=	sha512_init,
+	.init		=	sha512_base_init,
 	.update		=	crypto_sha512_update,
 	.final		=	sha512_final,
 	.descsize	=	sizeof(struct sha512_state),
@@ -259,9 +172,9 @@ static struct shash_alg sha512_algs[2] = { {
 	}
 }, {
 	.digestsize	=	SHA384_DIGEST_SIZE,
-	.init		=	sha384_init,
+	.init		=	sha384_base_init,
 	.update		=	crypto_sha512_update,
-	.final		=	sha384_final,
+	.final		=	sha512_final,
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha384",
-- 
1.8.3.2
