From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 1/5] crypto: md4 - Switch to shash
Date: Tue,  2 Dec 2008 23:38:30 +0100
Message-ID: <12282575141051-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:54053 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYLBWii (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 17:38:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes md4 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/md4.c |   52 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/crypto/md4.c b/crypto/md4.c
index a143c4a..7fca1f5 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -20,8 +20,8 @@
  * (at your option) any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
-#include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -58,7 +58,7 @@ static inline u32 H(u32 x, u32 y, u32 z)
 {
 	return x ^ y ^ z;
 }
-                        
+
 #define ROUND1(a,b,c,d,k,s) (a = lshift(a + F(b,c,d) + k, s))
 #define ROUND2(a,b,c,d,k,s) (a = lshift(a + G(b,c,d) + k + (u32)0x5A827999,s))
 #define ROUND3(a,b,c,d,k,s) (a = lshift(a + H(b,c,d) + k + (u32)0x6ED9EBA1,s))
@@ -152,20 +152,22 @@ static inline void md4_transform_helper(struct md4_ctx *ctx)
 	md4_transform(ctx->hash, ctx->block);
 }
 
-static void md4_init(struct crypto_tfm *tfm)
+static int md4_init(struct shash_desc *desc)
 {
-	struct md4_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct md4_ctx *mctx = shash_desc_ctx(desc);
 
 	mctx->hash[0] = 0x67452301;
 	mctx->hash[1] = 0xefcdab89;
 	mctx->hash[2] = 0x98badcfe;
 	mctx->hash[3] = 0x10325476;
 	mctx->byte_count = 0;
+
+	return 0;
 }
 
-static void md4_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+static int md4_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
-	struct md4_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct md4_ctx *mctx = shash_desc_ctx(desc);
 	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
 
 	mctx->byte_count += len;
@@ -173,7 +175,7 @@ static void md4_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 	if (avail > len) {
 		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
 		       data, len);
-		return;
+		return 0;
 	}
 
 	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
@@ -191,11 +193,13 @@ static void md4_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 	}
 
 	memcpy(mctx->block, data, len);
+
+	return 0;
 }
 
-static void md4_final(struct crypto_tfm *tfm, u8 *out)
+static int md4_final(struct shash_desc *desc, u8 *out)
 {
-	struct md4_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct md4_ctx *mctx = shash_desc_ctx(desc);
 	const unsigned int offset = mctx->byte_count & 0x3f;
 	char *p = (char *)mctx->block + offset;
 	int padding = 56 - (offset + 1);
@@ -217,30 +221,32 @@ static void md4_final(struct crypto_tfm *tfm, u8 *out)
 	cpu_to_le32_array(mctx->hash, ARRAY_SIZE(mctx->hash));
 	memcpy(out, mctx->hash, sizeof(mctx->hash));
 	memset(mctx, 0, sizeof(*mctx));
+
+	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name	=	"md4",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	MD4_HMAC_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct md4_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list       =       LIST_HEAD_INIT(alg.cra_list),	
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	MD4_DIGEST_SIZE,
-	.dia_init   	= 	md4_init,
-	.dia_update 	=	md4_update,
-	.dia_final  	=	md4_final } }
+static struct shash_alg alg = {
+	.digestsize	=	MD4_DIGEST_SIZE,
+	.init		=	md4_init,
+	.update		=	md4_update,
+	.final		=	md4_final,
+	.descsize	=	sizeof(struct md4_ctx),
+	.base		=	{
+		.cra_name	=	"md4",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	MD4_HMAC_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init md4_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit md4_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(md4_mod_init);
-- 
1.5.2.5

