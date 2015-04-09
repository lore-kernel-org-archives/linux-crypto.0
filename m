From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 04/16] crypto: sha1-generic: move to generic glue implementation
Date: Thu,  9 Apr 2015 12:55:36 +0200
Message-ID: <1428576948-23863-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35582 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbDIK4O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:14 -0400
Received: by widdi4 with SMTP id di4so87413728wid.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:13 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This updated the generic SHA-1 implementation to use the generic
shared SHA-1 glue code.

It also implements a .finup hook crypto_sha1_finup() and exports
it to other modules. The import and export() functions and the
.statesize member are dropped, since the default implementation
is perfectly suitable for this module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha1_generic.c | 102 ++++++++++----------------------------------------
 include/crypto/sha.h  |   3 ++
 2 files changed, 23 insertions(+), 82 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index a3e50c37eb6f..39e3acc438d9 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -23,111 +23,49 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
+#include <crypto/sha1_base.h>
 #include <asm/byteorder.h>
 
-static int sha1_init(struct shash_desc *desc)
+static void sha1_generic_block_fn(struct sha1_state *sst, u8 const *src,
+				  int blocks)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
+	u32 temp[SHA_WORKSPACE_WORDS];
 
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-
-	return 0;
+	while (blocks--) {
+		sha_transform(sst->state, src, temp);
+		src += SHA1_BLOCK_SIZE;
+	}
+	memzero_explicit(temp, sizeof(temp));
 }
 
 int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
-			unsigned int len)
+		       unsigned int len)
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
+	return sha1_base_do_update(desc, data, len, sha1_generic_block_fn);
 }
 EXPORT_SYMBOL(crypto_sha1_update);
 
-
-/* Add padding and return the message digest. */
 static int sha1_final(struct shash_desc *desc, u8 *out)
 {
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
+	sha1_base_do_finalize(desc, sha1_generic_block_fn);
+	return sha1_base_finish(desc, out);
 }
 
-static int sha1_export(struct shash_desc *desc, void *out)
+int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-	return 0;
-}
-
-static int sha1_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-	return 0;
+	sha1_base_do_update(desc, data, len, sha1_generic_block_fn);
+	return sha1_final(desc, out);
 }
+EXPORT_SYMBOL(crypto_sha1_finup);
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	sha1_init,
+	.init		=	sha1_base_init,
 	.update		=	crypto_sha1_update,
 	.final		=	sha1_final,
-	.export		=	sha1_export,
-	.import		=	sha1_import,
+	.finup		=	crypto_sha1_finup,
 	.descsize	=	sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-generic",
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 05e82cbc4d8f..a754cdd749c6 100644
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
