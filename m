From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 3/5] crypto: sha256 - Switch to shash
Date: Tue,  2 Dec 2008 23:38:32 +0100
Message-ID: <12282575173222-git-send-email-ken@codelabs.ch>
References: <12282575141051-git-send-email-ken@codelabs.ch>
 <12282575163307-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:54065 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYLBWil (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 17:38:41 -0500
In-Reply-To: <12282575163307-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes sha256 and sha224 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/sha256_generic.c |  104 +++++++++++++++++++++++++---------------------
 1 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 5a8dd47..caa3542 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -17,10 +17,10 @@
  * any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/crypto.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
@@ -69,7 +69,7 @@ static void sha256_transform(u32 *state, const u8 *input)
 	/* now blend */
 	for (i = 16; i < 64; i++)
 		BLEND_OP(i, W);
-    
+
 	/* load the state into our registers */
 	a=state[0];  b=state[1];  c=state[2];  d=state[3];
 	e=state[4];  f=state[5];  g=state[6];  h=state[7];
@@ -220,9 +220,9 @@ static void sha256_transform(u32 *state, const u8 *input)
 }
 
 
-static void sha224_init(struct crypto_tfm *tfm)
+static int sha224_init(struct shash_desc *desc)
 {
-	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha256_ctx *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA224_H0;
 	sctx->state[1] = SHA224_H1;
 	sctx->state[2] = SHA224_H2;
@@ -233,11 +233,13 @@ static void sha224_init(struct crypto_tfm *tfm)
 	sctx->state[7] = SHA224_H7;
 	sctx->count[0] = 0;
 	sctx->count[1] = 0;
+
+	return 0;
 }
 
-static void sha256_init(struct crypto_tfm *tfm)
+static int sha256_init(struct shash_desc *desc)
 {
-	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha256_ctx *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
 	sctx->state[2] = SHA256_H2;
@@ -247,12 +249,14 @@ static void sha256_init(struct crypto_tfm *tfm)
 	sctx->state[6] = SHA256_H6;
 	sctx->state[7] = SHA256_H7;
 	sctx->count[0] = sctx->count[1] = 0;
+
+	return 0;
 }
 
-static void sha256_update(struct crypto_tfm *tfm, const u8 *data,
+static int sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha256_ctx *sctx = shash_desc_ctx(desc);
 	unsigned int i, index, part_len;
 
 	/* Compute number of bytes mod 128 */
@@ -277,14 +281,16 @@ static void sha256_update(struct crypto_tfm *tfm, const u8 *data,
 	} else {
 		i = 0;
 	}
-	
+
 	/* Buffer remaining input */
 	memcpy(&sctx->buf[index], &data[i], len-i);
+
+	return 0;
 }
 
-static void sha256_final(struct crypto_tfm *tfm, u8 *out)
+static int sha256_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha256_ctx *sctx = shash_desc_ctx(desc);
 	__be32 *dst = (__be32 *)out;
 	__be32 bits[2];
 	unsigned int index, pad_len;
@@ -298,10 +304,10 @@ static void sha256_final(struct crypto_tfm *tfm, u8 *out)
 	/* Pad out to 56 mod 64. */
 	index = (sctx->count[0] >> 3) & 0x3f;
 	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
-	sha256_update(tfm, padding, pad_len);
+	sha256_update(desc, padding, pad_len);
 
 	/* Append length (before padding) */
-	sha256_update(tfm, (const u8 *)bits, sizeof(bits));
+	sha256_update(desc, (const u8 *)bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
@@ -309,71 +315,73 @@ static void sha256_final(struct crypto_tfm *tfm, u8 *out)
 
 	/* Zeroize sensitive information. */
 	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
 }
 
-static void sha224_final(struct crypto_tfm *tfm, u8 *hash)
+static int sha224_final(struct shash_desc *desc, u8 *hash)
 {
 	u8 D[SHA256_DIGEST_SIZE];
 
-	sha256_final(tfm, D);
+	sha256_final(desc, D);
 
 	memcpy(hash, D, SHA224_DIGEST_SIZE);
 	memset(D, 0, SHA256_DIGEST_SIZE);
+
+	return 0;
 }
 
-static struct crypto_alg sha256 = {
-	.cra_name	=	"sha256",
-	.cra_driver_name=	"sha256-generic",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA256_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct sha256_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_alignmask	=	3,
-	.cra_list	=	LIST_HEAD_INIT(sha256.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	SHA256_DIGEST_SIZE,
-	.dia_init	=	sha256_init,
-	.dia_update	=	sha256_update,
-	.dia_final	=	sha256_final } }
+static struct shash_alg sha256 = {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_init,
+	.update		=	sha256_update,
+	.final		=	sha256_final,
+	.descsize	=	sizeof(struct sha256_ctx),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name=	"sha256-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
-static struct crypto_alg sha224 = {
-	.cra_name	= "sha224",
-	.cra_driver_name = "sha224-generic",
-	.cra_flags	= CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	= SHA224_BLOCK_SIZE,
-	.cra_ctxsize	= sizeof(struct sha256_ctx),
-	.cra_module	= THIS_MODULE,
-	.cra_alignmask	= 3,
-	.cra_list	= LIST_HEAD_INIT(sha224.cra_list),
-	.cra_u		= { .digest = {
-	.dia_digestsize = SHA224_DIGEST_SIZE,
-	.dia_init	= sha224_init,
-	.dia_update	= sha256_update,
-	.dia_final	= sha224_final } }
+static struct shash_alg sha224 = {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_init,
+	.update		=	sha256_update,
+	.final		=	sha224_final,
+	.descsize	=	sizeof(struct sha256_ctx),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name=	"sha224-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init sha256_generic_mod_init(void)
 {
 	int ret = 0;
 
-	ret = crypto_register_alg(&sha224);
+	ret = crypto_register_shash(&sha224);
 
 	if (ret < 0)
 		return ret;
 
-	ret = crypto_register_alg(&sha256);
+	ret = crypto_register_shash(&sha256);
 
 	if (ret < 0)
-		crypto_unregister_alg(&sha224);
+		crypto_unregister_shash(&sha224);
 
 	return ret;
 }
 
 static void __exit sha256_generic_mod_fini(void)
 {
-	crypto_unregister_alg(&sha224);
-	crypto_unregister_alg(&sha256);
+	crypto_unregister_shash(&sha224);
+	crypto_unregister_shash(&sha256);
 }
 
 module_init(sha256_generic_mod_init);
-- 
1.5.2.5

