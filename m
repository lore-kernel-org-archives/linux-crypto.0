From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 2/5] crypto: md5 - Switch to shash
Date: Tue,  2 Dec 2008 23:38:31 +0100
Message-ID: <12282575163307-git-send-email-ken@codelabs.ch>
References: <12282575141051-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:54059 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYLBWik (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 17:38:40 -0500
In-Reply-To: <12282575141051-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes md5 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/md5.c |   50 ++++++++++++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/crypto/md5.c b/crypto/md5.c
index 39268f3..83eb529 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -15,10 +15,10 @@
  * any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
@@ -147,20 +147,22 @@ static inline void md5_transform_helper(struct md5_ctx *ctx)
 	md5_transform(ctx->hash, ctx->block);
 }
 
-static void md5_init(struct crypto_tfm *tfm)
+static int md5_init(struct shash_desc *desc)
 {
-	struct md5_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct md5_ctx *mctx = shash_desc_ctx(desc);
 
 	mctx->hash[0] = 0x67452301;
 	mctx->hash[1] = 0xefcdab89;
 	mctx->hash[2] = 0x98badcfe;
 	mctx->hash[3] = 0x10325476;
 	mctx->byte_count = 0;
+
+	return 0;
 }
 
-static void md5_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+static int md5_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
-	struct md5_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct md5_ctx *mctx = shash_desc_ctx(desc);
 	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
 
 	mctx->byte_count += len;
@@ -168,7 +170,7 @@ static void md5_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 	if (avail > len) {
 		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
 		       data, len);
-		return;
+		return 0;
 	}
 
 	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
@@ -186,11 +188,13 @@ static void md5_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 	}
 
 	memcpy(mctx->block, data, len);
+
+	return 0;
 }
 
-static void md5_final(struct crypto_tfm *tfm, u8 *out)
+static int md5_final(struct shash_desc *desc, u8 *out)
 {
-	struct md5_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct md5_ctx *mctx = shash_desc_ctx(desc);
 	const unsigned int offset = mctx->byte_count & 0x3f;
 	char *p = (char *)mctx->block + offset;
 	int padding = 56 - (offset + 1);
@@ -212,30 +216,32 @@ static void md5_final(struct crypto_tfm *tfm, u8 *out)
 	cpu_to_le32_array(mctx->hash, sizeof(mctx->hash) / sizeof(u32));
 	memcpy(out, mctx->hash, sizeof(mctx->hash));
 	memset(mctx, 0, sizeof(*mctx));
+
+	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name	=	"md5",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct md5_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	MD5_DIGEST_SIZE,
-	.dia_init   	= 	md5_init,
-	.dia_update 	=	md5_update,
-	.dia_final  	=	md5_final } }
+static struct shash_alg alg = {
+	.digestsize	=	MD5_DIGEST_SIZE,
+	.init		=	md5_init,
+	.update		=	md5_update,
+	.final		=	md5_final,
+	.descsize	=	sizeof(struct md5_ctx),
+	.base		=	{
+		.cra_name	=	"md5",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init md5_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit md5_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(md5_mod_init);
-- 
1.5.2.5

