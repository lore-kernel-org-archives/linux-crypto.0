From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 05/16] crypto: sha256-generic: move to generic glue implementation
Date: Thu,  9 Apr 2015 12:55:37 +0200
Message-ID: <1428576948-23863-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38795 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbDIK4R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:17 -0400
Received: by wiun10 with SMTP id n10so92961892wiu.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:15 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updates the generic SHA-256 implementation to use the
new shared SHA-256 glue code.

It also implements a .finup hook crypto_sha256_finup() and exports
it to other modules. The import and export() functions and the
.statesize member are dropped, since the default implementation
is perfectly suitable for this module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha256_generic.c | 133 ++++++++----------------------------------------
 include/crypto/sha.h    |   3 ++
 2 files changed, 23 insertions(+), 113 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index b001ff5c2efc..78431163ed3c 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
+#include <crypto/sha256_base.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
@@ -214,138 +215,43 @@ static void sha256_transform(u32 *state, const u8 *input)
 	memzero_explicit(W, 64 * sizeof(u32));
 }
 
-static int sha224_init(struct shash_desc *desc)
+static void sha256_generic_block_fn(struct sha256_state *sst, u8 const *src,
+				    int blocks)
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
-
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
+		sha256_transform(sst->state, src);
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
+	return sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
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
+	sha256_base_do_finalize(desc, sha256_generic_block_fn);
+	return sha256_base_finish(desc, out);
 }
 
-static int sha224_final(struct shash_desc *desc, u8 *hash)
+int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *hash)
 {
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
+	sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
+	return sha256_final(desc, hash);
 }
+EXPORT_SYMBOL(crypto_sha256_finup);
 
 static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_init,
+	.init		=	sha256_base_init,
 	.update		=	crypto_sha256_update,
 	.final		=	sha256_final,
-	.export		=	sha256_export,
-	.import		=	sha256_import,
+	.finup		=	crypto_sha256_finup,
 	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-generic",
@@ -355,9 +261,10 @@ static struct shash_alg sha256_algs[2] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_init,
+	.init		=	sha224_base_init,
 	.update		=	crypto_sha256_update,
-	.final		=	sha224_final,
+	.final		=	sha256_final,
+	.finup		=	crypto_sha256_finup,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index a754cdd749c6..e28c4b5e805d 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -93,6 +93,9 @@ extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
 extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
+extern int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *hash);
+
 extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 #endif
-- 
1.8.3.2
