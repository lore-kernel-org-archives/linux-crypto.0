From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 04/16] crypto: sha1-generic: move to generic glue implementation
Date: Tue,  7 Apr 2015 10:51:52 +0200
Message-ID: <1428396724-19962-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34243 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbDGIwd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:33 -0400
Received: by widjs5 with SMTP id js5so5689069wid.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:32 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updates the generic SHA-1 implementation to use the generic
shared SHA-1 glue code.

It also implements a .finup hook crypto_sha1_finup() and exports
it to other modules.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha1_generic.c | 108 +++++++++++++-------------------------------------
 include/crypto/sha.h  |   3 ++
 2 files changed, 31 insertions(+), 80 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index a3e50c37eb6f..322a2278d939 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -23,109 +23,57 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
+#include <crypto/sha1_base.h>
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
+	memzero_explicit(temp, sizeof(temp));
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
+	return sha1_base_do_update(desc, data, len, sha1_generic_block_fn,
+				   NULL);
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
+		sha1_base_do_update(desc, data, len, sha1_generic_block_fn,
+				    NULL);
+	sha1_base_do_finalize(desc, sha1_generic_block_fn, NULL);
+	return sha1_base_finish(desc, out);
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
+	.init		=	sha1_base_init,
 	.update		=	crypto_sha1_update,
 	.final		=	sha1_final,
-	.export		=	sha1_export,
-	.import		=	sha1_import,
+	.finup		=	crypto_sha1_finup,
+	.export		=	sha1_base_export,
+	.import		=	sha1_base_import,
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 190f8a0e0242..10e2009f5464 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -87,6 +87,9 @@ struct shash_desc;
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
+extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *hash);
+
 extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
-- 
1.8.3.2
