From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 3/4] crypto: wp512 - Switch to shash
Date: Thu,  4 Dec 2008 01:18:11 +0100
Message-ID: <12283498953450-git-send-email-ken@codelabs.ch>
References: <12283498922490-git-send-email-ken@codelabs.ch>
 <12283498932360-git-send-email-ken@codelabs.ch>
 <12283498942104-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:40700 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYLDASS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 19:18:18 -0500
In-Reply-To: <12283498942104-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes wp512, wp384 and wp256 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/wp512.c |  121 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 65 insertions(+), 56 deletions(-)

diff --git a/crypto/wp512.c b/crypto/wp512.c
index bff2856..7234272 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -19,11 +19,11 @@
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
 
 #define WP512_DIGEST_SIZE 64
@@ -980,8 +980,8 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 
 }
 
-static void wp512_init(struct crypto_tfm *tfm) {
-	struct wp512_ctx *wctx = crypto_tfm_ctx(tfm);
+static int wp512_init(struct shash_desc *desc) {
+	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int i;
 
 	memset(wctx->bitLength, 0, 32);
@@ -990,12 +990,14 @@ static void wp512_init(struct crypto_tfm *tfm) {
 	for (i = 0; i < 8; i++) {
 		wctx->hash[i] = 0L;
 	}
+
+	return 0;
 }
 
-static void wp512_update(struct crypto_tfm *tfm, const u8 *source,
+static int wp512_update(struct shash_desc *desc, const u8 *source,
 			 unsigned int len)
 {
-	struct wp512_ctx *wctx = crypto_tfm_ctx(tfm);
+	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int sourcePos    = 0;
 	unsigned int bits_len = len * 8; // convert to number of bits
 	int sourceGap    = (8 - ((int)bits_len & 7)) & 7;
@@ -1051,11 +1053,12 @@ static void wp512_update(struct crypto_tfm *tfm, const u8 *source,
 	wctx->bufferBits   = bufferBits;
 	wctx->bufferPos    = bufferPos;
 
+	return 0;
 }
 
-static void wp512_final(struct crypto_tfm *tfm, u8 *out)
+static int wp512_final(struct shash_desc *desc, u8 *out)
 {
-	struct wp512_ctx *wctx = crypto_tfm_ctx(tfm);
+	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int i;
    	u8 *buffer      = wctx->buffer;
    	u8 *bitLength   = wctx->bitLength;
@@ -1084,89 +1087,95 @@ static void wp512_final(struct crypto_tfm *tfm, u8 *out)
 		digest[i] = cpu_to_be64(wctx->hash[i]);
    	wctx->bufferBits   = bufferBits;
    	wctx->bufferPos    = bufferPos;
+
+	return 0;
 }
 
-static void wp384_final(struct crypto_tfm *tfm, u8 *out)
+static int wp384_final(struct shash_desc *desc, u8 *out)
 {
 	u8 D[64];
 
-	wp512_final(tfm, D);
+	wp512_final(desc, D);
 	memcpy (out, D, WP384_DIGEST_SIZE);
 	memset (D, 0, WP512_DIGEST_SIZE);
+
+	return 0;
 }
 
-static void wp256_final(struct crypto_tfm *tfm, u8 *out)
+static int wp256_final(struct shash_desc *desc, u8 *out)
 {
 	u8 D[64];
 
-	wp512_final(tfm, D);
+	wp512_final(desc, D);
 	memcpy (out, D, WP256_DIGEST_SIZE);
 	memset (D, 0, WP512_DIGEST_SIZE);
+
+	return 0;
 }
 
-static struct crypto_alg wp512 = {
-	.cra_name	=	"wp512",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	WP512_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct wp512_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list       =       LIST_HEAD_INIT(wp512.cra_list),	
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	WP512_DIGEST_SIZE,
-	.dia_init   	= 	wp512_init,
-	.dia_update 	=	wp512_update,
-	.dia_final  	=	wp512_final } }
+static struct shash_alg wp512 = {
+	.digestsize	=	WP512_DIGEST_SIZE,
+	.init		=	wp512_init,
+	.update		=	wp512_update,
+	.final		=	wp512_final,
+	.descsize	=	sizeof(struct wp512_ctx),
+	.base		=	{
+		.cra_name	=	"wp512",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	WP512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
-static struct crypto_alg wp384 = {
-	.cra_name	=	"wp384",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	WP512_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct wp512_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list       =       LIST_HEAD_INIT(wp384.cra_list),	
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	WP384_DIGEST_SIZE,
-	.dia_init   	= 	wp512_init,
-	.dia_update 	=	wp512_update,
-	.dia_final  	=	wp384_final } }
+static struct shash_alg wp384 = {
+	.digestsize	=	WP384_DIGEST_SIZE,
+	.init		=	wp512_init,
+	.update		=	wp512_update,
+	.final		=	wp384_final,
+	.descsize	=	sizeof(struct wp512_ctx),
+	.base		=	{
+		.cra_name	=	"wp384",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	WP512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
-static struct crypto_alg wp256 = {
-	.cra_name	=	"wp256",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	WP512_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct wp512_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_list       =       LIST_HEAD_INIT(wp256.cra_list),	
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	WP256_DIGEST_SIZE,
-	.dia_init   	= 	wp512_init,
-	.dia_update 	=	wp512_update,
-	.dia_final  	=	wp256_final } }
+static struct shash_alg wp256 = {
+	.digestsize	=	WP256_DIGEST_SIZE,
+	.init		=	wp512_init,
+	.update		=	wp512_update,
+	.final		=	wp256_final,
+	.descsize	=	sizeof(struct wp512_ctx),
+	.base		=	{
+		.cra_name	=	"wp256",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	WP512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init wp512_mod_init(void)
 {
 	int ret = 0;
 
-	ret = crypto_register_alg(&wp512);
+	ret = crypto_register_shash(&wp512);
 
 	if (ret < 0)
 		goto out;
 
-	ret = crypto_register_alg(&wp384);
+	ret = crypto_register_shash(&wp384);
 	if (ret < 0)
 	{
-		crypto_unregister_alg(&wp512);
+		crypto_unregister_shash(&wp512);
 		goto out;
 	}
 
-	ret = crypto_register_alg(&wp256);
+	ret = crypto_register_shash(&wp256);
 	if (ret < 0)
 	{
-		crypto_unregister_alg(&wp512);
-		crypto_unregister_alg(&wp384);
+		crypto_unregister_shash(&wp512);
+		crypto_unregister_shash(&wp384);
 	}
 out:
 	return ret;
@@ -1174,9 +1183,9 @@ out:
 
 static void __exit wp512_mod_fini(void)
 {
-	crypto_unregister_alg(&wp512);
-	crypto_unregister_alg(&wp384);
-	crypto_unregister_alg(&wp256);
+	crypto_unregister_shash(&wp512);
+	crypto_unregister_shash(&wp384);
+	crypto_unregister_shash(&wp256);
 }
 
 MODULE_ALIAS("wp384");
-- 
1.5.2.5

