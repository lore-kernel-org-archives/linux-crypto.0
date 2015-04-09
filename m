From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 06/16] crypto: sha512-generic: move to generic glue implementation
Date: Thu,  9 Apr 2015 12:55:38 +0200
Message-ID: <1428576948-23863-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35663 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260AbbDIK4T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:19 -0400
Received: by widdi4 with SMTP id di4so87415594wid.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:17 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updated the generic SHA-512 implementation to use the
generic shared SHA-512 glue code.

It also implements a .finup hook crypto_sha512_finup() and exports
it to other modules. The import and export() functions and the
.statesize member are dropped, since the default implementation
is perfectly suitable for this module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha512_generic.c | 123 +++++++++---------------------------------------
 include/crypto/sha.h    |   3 ++
 2 files changed, 24 insertions(+), 102 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 1c3c3767e079..eba965d18bfc 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -18,6 +18,7 @@
 #include <linux/crypto.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
+#include <crypto/sha512_base.h>
 #include <linux/percpu.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
@@ -130,125 +131,42 @@ sha512_transform(u64 *state, const u8 *input)
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
 }
 
-static int
-sha512_init(struct shash_desc *desc)
+static void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
+				    int blocks)
 {
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
-{
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
-
-	return 0;
+	while (blocks--) {
+		sha512_transform(sst->state, src);
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
+	return sha512_base_do_update(desc, data, len, sha512_generic_block_fn);
 }
 EXPORT_SYMBOL(crypto_sha512_update);
 
-static int
-sha512_final(struct shash_desc *desc, u8 *hash)
+static int sha512_final(struct shash_desc *desc, u8 *hash)
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
+	sha512_base_do_finalize(desc, sha512_generic_block_fn);
+	return sha512_base_finish(desc, hash);
 }
 
-static int sha384_final(struct shash_desc *desc, u8 *hash)
+int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *hash)
 {
-	u8 D[64];
-
-	sha512_final(desc, D);
-
-	memcpy(hash, D, 48);
-	memzero_explicit(D, 64);
-
-	return 0;
+	sha512_base_do_update(desc, data, len, sha512_generic_block_fn);
+	return sha512_final(desc, hash);
 }
+EXPORT_SYMBOL(crypto_sha512_finup);
 
 static struct shash_alg sha512_algs[2] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
-	.init		=	sha512_init,
+	.init		=	sha512_base_init,
 	.update		=	crypto_sha512_update,
 	.final		=	sha512_final,
+	.finup		=	crypto_sha512_finup,
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha512",
@@ -259,9 +177,10 @@ static struct shash_alg sha512_algs[2] = { {
 	}
 }, {
 	.digestsize	=	SHA384_DIGEST_SIZE,
-	.init		=	sha384_init,
+	.init		=	sha384_base_init,
 	.update		=	crypto_sha512_update,
-	.final		=	sha384_final,
+	.final		=	sha512_final,
+	.finup		=	crypto_sha512_finup,
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha384",
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index e28c4b5e805d..dd7905a3c22e 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -98,4 +98,7 @@ extern int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
 
 extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
+
+extern int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *hash);
 #endif
-- 
1.8.3.2
