From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 4/6] crypto: sha256-generic: move to generic glue implementation
Date: Sat, 28 Mar 2015 23:10:26 +0100
Message-ID: <1427580628-7128-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35192 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbC1WKy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Mar 2015 18:10:54 -0400
Received: by wgdm6 with SMTP id m6so133597806wgd.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2015 15:10:52 -0700 (PDT)
In-Reply-To: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updates the generic SHA-256 implementation to use the
new shared SHA-256 glue code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig          |   1 +
 crypto/sha256_generic.c | 131 +++++++-----------------------------------------
 2 files changed, 18 insertions(+), 114 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 551bbf2e2ab5..59243df4ea13 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -608,6 +608,7 @@ config CRYPTO_SHA256_BASE
 
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
+	select CRYPTO_SHA256_BASE
 	select CRYPTO_HASH
 	help
 	  SHA256 secure hash standard (DFIPS 180-2).
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index b001ff5c2efc..7119346c2f41 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -214,136 +214,39 @@ static void sha256_transform(u32 *state, const u8 *input)
 	memzero_explicit(W, 64 * sizeof(u32));
 }
 
-static int sha224_init(struct shash_desc *desc)
+static void sha256_generic_block_fn(int blocks, u8 const *src, u32 *state,
+				    const u8 *head, void *p)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	sctx->state[0] = SHA224_H0;
-	sctx->state[1] = SHA224_H1;
-	sctx->state[2] = SHA224_H2;
-	sctx->state[3] = SHA224_H3;
-	sctx->state[4] = SHA224_H4;
-	sctx->state[5] = SHA224_H5;
-	sctx->state[6] = SHA224_H6;
-	sctx->state[7] = SHA224_H7;
-	sctx->count = 0;
+	if (head)
+		sha256_transform(state, head);
 
-	return 0;
-}
-
-static int sha256_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	sctx->state[0] = SHA256_H0;
-	sctx->state[1] = SHA256_H1;
-	sctx->state[2] = SHA256_H2;
-	sctx->state[3] = SHA256_H3;
-	sctx->state[4] = SHA256_H4;
-	sctx->state[5] = SHA256_H5;
-	sctx->state[6] = SHA256_H6;
-	sctx->state[7] = SHA256_H7;
-	sctx->count = 0;
-
-	return 0;
+	while (blocks--) {
+		sha256_transform(state, src);
+		src += SHA256_BLOCK_SIZE;
+	}
 }
 
 int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
-
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
-
-		do {
-			sha256_transform(sctx->state, src);
-			done += 64;
-			src = data + done;
-		} while (done + 63 < len);
-
-		partial = 0;
-	}
-	memcpy(sctx->buf + partial, src, len - done);
-
-	return 0;
+	return sha256_base_do_update(desc, data, len, sha256_generic_block_fn,
+				     NULL);
 }
 EXPORT_SYMBOL(crypto_sha256_update);
 
 static int sha256_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
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
-	crypto_sha256_update(desc, padding, pad_len);
-
-	/* Append length (before padding) */
-	crypto_sha256_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha224_final(struct shash_desc *desc, u8 *hash)
-{
-	u8 D[SHA256_DIGEST_SIZE];
-
-	sha256_final(desc, D);
-
-	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
-}
-
-static int sha256_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int sha256_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	sha256_base_do_finalize(desc, sha256_generic_block_fn, NULL);
+	return sha256_base_finish(desc, out);
 }
 
 static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_init,
+	.init		=	sha256_base_init,
 	.update		=	crypto_sha256_update,
 	.final		=	sha256_final,
-	.export		=	sha256_export,
-	.import		=	sha256_import,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
@@ -355,9 +258,9 @@ static struct shash_alg sha256_algs[2] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_init,
+	.init		=	sha224_base_init,
 	.update		=	crypto_sha256_update,
-	.final		=	sha224_final,
+	.final		=	sha256_final,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
-- 
1.8.3.2
