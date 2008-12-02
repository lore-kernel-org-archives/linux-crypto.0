From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 4/5] crypto: tgr192 - Switch to shash
Date: Tue,  2 Dec 2008 23:38:33 +0100
Message-ID: <122825751834-git-send-email-ken@codelabs.ch>
References: <12282575141051-git-send-email-ken@codelabs.ch>
 <12282575163307-git-send-email-ken@codelabs.ch>
 <12282575173222-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:54071 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYLBWin (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 17:38:43 -0500
In-Reply-To: <12282575173222-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes tgr192, tgr160 and tgr128 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/tgr192.c |  135 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 71 insertions(+), 64 deletions(-)

diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index a92414f..cbca4f2 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -21,11 +21,11 @@
  * (at your option) any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/byteorder.h>
-#include <linux/crypto.h>
 #include <linux/types.h>
 
 #define TGR192_DIGEST_SIZE 24
@@ -495,24 +495,26 @@ static void tgr192_transform(struct tgr192_ctx *tctx, const u8 * data)
 	tctx->c = c;
 }
 
-static void tgr192_init(struct crypto_tfm *tfm)
+static int tgr192_init(struct shash_desc *desc)
 {
-	struct tgr192_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct tgr192_ctx *tctx = shash_desc_ctx(desc);
 
 	tctx->a = 0x0123456789abcdefULL;
 	tctx->b = 0xfedcba9876543210ULL;
 	tctx->c = 0xf096a5b4c3b2e187ULL;
 	tctx->nblocks = 0;
 	tctx->count = 0;
+
+	return 0;
 }
 
 
 /* Update the message digest with the contents
  * of INBUF with length INLEN. */
-static void tgr192_update(struct crypto_tfm *tfm, const u8 *inbuf,
+static int tgr192_update(struct shash_desc *desc, const u8 *inbuf,
 			  unsigned int len)
 {
-	struct tgr192_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct tgr192_ctx *tctx = shash_desc_ctx(desc);
 
 	if (tctx->count == 64) {	/* flush the buffer */
 		tgr192_transform(tctx, tctx->hash);
@@ -520,15 +522,15 @@ static void tgr192_update(struct crypto_tfm *tfm, const u8 *inbuf,
 		tctx->nblocks++;
 	}
 	if (!inbuf) {
-		return;
+		return 0;
 	}
 	if (tctx->count) {
 		for (; len && tctx->count < 64; len--) {
 			tctx->hash[tctx->count++] = *inbuf++;
 		}
-		tgr192_update(tfm, NULL, 0);
+		tgr192_update(desc, NULL, 0);
 		if (!len) {
-			return;
+			return 0;
 		}
 
 	}
@@ -543,20 +545,22 @@ static void tgr192_update(struct crypto_tfm *tfm, const u8 *inbuf,
 	for (; len && tctx->count < 64; len--) {
 		tctx->hash[tctx->count++] = *inbuf++;
 	}
+
+	return 0;
 }
 
 
 
 /* The routine terminates the computation */
-static void tgr192_final(struct crypto_tfm *tfm, u8 * out)
+static int tgr192_final(struct shash_desc *desc, u8 * out)
 {
-	struct tgr192_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct tgr192_ctx *tctx = shash_desc_ctx(desc);
 	__be64 *dst = (__be64 *)out;
 	__be64 *be64p;
 	__le32 *le32p;
 	u32 t, msb, lsb;
 
-	tgr192_update(tfm, NULL, 0); /* flush */ ;
+	tgr192_update(desc, NULL, 0); /* flush */ ;
 
 	msb = 0;
 	t = tctx->nblocks;
@@ -584,7 +588,7 @@ static void tgr192_final(struct crypto_tfm *tfm, u8 * out)
 		while (tctx->count < 64) {
 			tctx->hash[tctx->count++] = 0;
 		}
-		tgr192_update(tfm, NULL, 0); /* flush */ ;
+		tgr192_update(desc, NULL, 0); /* flush */ ;
 		memset(tctx->hash, 0, 56);    /* fill next block with zeroes */
 	}
 	/* append the 64 bit count */
@@ -598,91 +602,94 @@ static void tgr192_final(struct crypto_tfm *tfm, u8 * out)
 	dst[0] = be64p[0] = cpu_to_be64(tctx->a);
 	dst[1] = be64p[1] = cpu_to_be64(tctx->b);
 	dst[2] = be64p[2] = cpu_to_be64(tctx->c);
+
+	return 0;
 }
 
-static void tgr160_final(struct crypto_tfm *tfm, u8 * out)
+static int tgr160_final(struct shash_desc *desc, u8 * out)
 {
 	u8 D[64];
 
-	tgr192_final(tfm, D);
+	tgr192_final(desc, D);
 	memcpy(out, D, TGR160_DIGEST_SIZE);
 	memset(D, 0, TGR192_DIGEST_SIZE);
+
+	return 0;
 }
 
-static void tgr128_final(struct crypto_tfm *tfm, u8 * out)
+static int tgr128_final(struct shash_desc *desc, u8 * out)
 {
 	u8 D[64];
 
-	tgr192_final(tfm, D);
+	tgr192_final(desc, D);
 	memcpy(out, D, TGR128_DIGEST_SIZE);
 	memset(D, 0, TGR192_DIGEST_SIZE);
+
+	return 0;
 }
 
-static struct crypto_alg tgr192 = {
-	.cra_name = "tgr192",
-	.cra_flags = CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize = TGR192_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct tgr192_ctx),
-	.cra_module = THIS_MODULE,
-	.cra_alignmask = 7,
-	.cra_list = LIST_HEAD_INIT(tgr192.cra_list),
-	.cra_u = {.digest = {
-			     .dia_digestsize = TGR192_DIGEST_SIZE,
-			     .dia_init = tgr192_init,
-			     .dia_update = tgr192_update,
-			     .dia_final = tgr192_final}}
+static struct shash_alg tgr192 = {
+	.digestsize	=	TGR192_DIGEST_SIZE,
+	.init		=	tgr192_init,
+	.update		=	tgr192_update,
+	.final		=	tgr192_final,
+	.descsize	=	sizeof(struct tgr192_ctx),
+	.base		=	{
+		.cra_name	=	"tgr192",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	TGR192_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
-static struct crypto_alg tgr160 = {
-	.cra_name = "tgr160",
-	.cra_flags = CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize = TGR192_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct tgr192_ctx),
-	.cra_module = THIS_MODULE,
-	.cra_alignmask = 7,
-	.cra_list = LIST_HEAD_INIT(tgr160.cra_list),
-	.cra_u = {.digest = {
-			     .dia_digestsize = TGR160_DIGEST_SIZE,
-			     .dia_init = tgr192_init,
-			     .dia_update = tgr192_update,
-			     .dia_final = tgr160_final}}
+static struct shash_alg tgr160 = {
+	.digestsize	=	TGR160_DIGEST_SIZE,
+	.init		=	tgr192_init,
+	.update		=	tgr192_update,
+	.final		=	tgr160_final,
+	.descsize	=	sizeof(struct tgr192_ctx),
+	.base		=	{
+		.cra_name	=	"tgr160",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	TGR192_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
-static struct crypto_alg tgr128 = {
-	.cra_name = "tgr128",
-	.cra_flags = CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize = TGR192_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct tgr192_ctx),
-	.cra_module = THIS_MODULE,
-	.cra_alignmask = 7,
-	.cra_list = LIST_HEAD_INIT(tgr128.cra_list),
-	.cra_u = {.digest = {
-			     .dia_digestsize = TGR128_DIGEST_SIZE,
-			     .dia_init = tgr192_init,
-			     .dia_update = tgr192_update,
-			     .dia_final = tgr128_final}}
+static struct shash_alg tgr128 = {
+	.digestsize	=	TGR128_DIGEST_SIZE,
+	.init		=	tgr192_init,
+	.update		=	tgr192_update,
+	.final		=	tgr128_final,
+	.descsize	=	sizeof(struct tgr192_ctx),
+	.base		=	{
+		.cra_name	=	"tgr128",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	TGR192_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init tgr192_mod_init(void)
 {
 	int ret = 0;
 
-	ret = crypto_register_alg(&tgr192);
+	ret = crypto_register_shash(&tgr192);
 
 	if (ret < 0) {
 		goto out;
 	}
 
-	ret = crypto_register_alg(&tgr160);
+	ret = crypto_register_shash(&tgr160);
 	if (ret < 0) {
-		crypto_unregister_alg(&tgr192);
+		crypto_unregister_shash(&tgr192);
 		goto out;
 	}
 
-	ret = crypto_register_alg(&tgr128);
+	ret = crypto_register_shash(&tgr128);
 	if (ret < 0) {
-		crypto_unregister_alg(&tgr192);
-		crypto_unregister_alg(&tgr160);
+		crypto_unregister_shash(&tgr192);
+		crypto_unregister_shash(&tgr160);
 	}
       out:
 	return ret;
@@ -690,9 +697,9 @@ static int __init tgr192_mod_init(void)
 
 static void __exit tgr192_mod_fini(void)
 {
-	crypto_unregister_alg(&tgr192);
-	crypto_unregister_alg(&tgr160);
-	crypto_unregister_alg(&tgr128);
+	crypto_unregister_shash(&tgr192);
+	crypto_unregister_shash(&tgr160);
+	crypto_unregister_shash(&tgr128);
 }
 
 MODULE_ALIAS("tgr160");
-- 
1.5.2.5

