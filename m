From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend 06/14] crypto: sha1-generic: move to generic glue implementation
Date: Mon, 30 Mar 2015 11:48:25 +0200
Message-ID: <1427708913-29678-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33917 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbbC3JtJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:49:09 -0400
Received: by wgbdm7 with SMTP id dm7so61134464wgb.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:49:08 -0700 (PDT)
In-Reply-To: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updated the generic SHA-1 implementation to use the generic
shared SHA-1 glue code.

It also implements a .finup hook crypto_sha1_finup() and exports
it to other modules.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig        |   1 +
 crypto/sha1_generic.c | 105 ++++++++++++--------------------------------------
 include/crypto/sha.h  |   3 ++
 3 files changed, 29 insertions(+), 80 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 72bf5af7240d..8f16d90f7c55 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -522,6 +522,7 @@ config CRYPTO_SHA1_BASE
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
 	select CRYPTO_HASH
+	select CRYPTO_SHA1_BASE
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index a3e50c37eb6f..3975f63ea6f9 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -25,107 +25,52 @@
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
 
-static int sha1_init(struct shash_desc *desc)
+static void sha1_generic_block_fn(int blocks, u8 const *src, u32 *state,
+				  const u8 *head, void *p)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
+	u32 temp[SHA_WORKSPACE_WORDS];
 
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
+	if (head)
+		sha_transform(state, head, temp);
 
-	return 0;
+	while (blocks--) {
+		sha_transform(state, src, temp);
+		src += SHA1_BLOCK_SIZE;
+	}
 }
 
 int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
-
-	partial = sctx->count % SHA1_BLOCK_SIZE;
-	sctx->count += len;
-	done = 0;
-	src = data;
-
-	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		u32 temp[SHA_WORKSPACE_WORDS];
-
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buffer + partial, data,
-			       done + SHA1_BLOCK_SIZE);
-			src = sctx->buffer;
-		}
-
-		do {
-			sha_transform(sctx->state, src, temp);
-			done += SHA1_BLOCK_SIZE;
-			src = data + done;
-		} while (done + SHA1_BLOCK_SIZE <= len);
-
-		memzero_explicit(temp, sizeof(temp));
-		partial = 0;
-	}
-	memcpy(sctx->buffer + partial, src, len - done);
-
-	return 0;
+	return crypto_sha1_base_do_update(desc, data, len,
+					  sha1_generic_block_fn, NULL);
 }
 EXPORT_SYMBOL(crypto_sha1_update);
 
-
-/* Add padding and return the message digest. */
-static int sha1_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	u32 i, index, padlen;
-	__be64 bits;
-	static const u8 padding[64] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 */
-	index = sctx->count & 0x3f;
-	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-	crypto_sha1_update(desc, padding, padlen);
-
-	/* Append length */
-	crypto_sha1_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof *sctx);
-
-	return 0;
-}
-
-static int sha1_export(struct shash_desc *desc, void *out)
+int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
+	if (len)
+		crypto_sha1_base_do_update(desc, data, len,
+					   sha1_generic_block_fn, NULL);
+	crypto_sha1_base_do_finalize(desc, sha1_generic_block_fn, NULL);
+	return crypto_sha1_base_finish(desc, out);
 }
+EXPORT_SYMBOL(crypto_sha1_finup);
 
-static int sha1_import(struct shash_desc *desc, const void *in)
+/* Add padding and return the message digest. */
+static int sha1_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	return crypto_sha1_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	sha1_init,
+	.init		=	crypto_sha1_base_init,
 	.update		=	crypto_sha1_update,
 	.final		=	sha1_final,
-	.export		=	sha1_export,
-	.import		=	sha1_import,
+	.export		=	crypto_sha1_base_export,
+	.import		=	crypto_sha1_base_import,
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 1b4d9a87c2a4..7bb3140d2d8a 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -94,6 +94,9 @@ struct shash_desc;
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
+extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *hash);
+
 extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
-- 
1.8.3.2
