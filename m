From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH] crypto: sha512 - Switch to shash
Date: Fri,  5 Dec 2008 01:29:56 +0100
Message-ID: <12284369963751-git-send-email-ken@codelabs.ch>
References: <12284306293090-git-send-email-ken@codelabs.ch>
 <12284369962234-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:43186 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYLEAaA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 19:30:00 -0500
In-Reply-To: <12284369962234-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes sha512 and sha384 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/Kconfig          |    2 +-
 crypto/sha512_generic.c |  112 +++++++++++++++++++++++++----------------------
 2 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c8fb468..6d2c5bf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -341,7 +341,7 @@ config CRYPTO_SHA256
 
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	help
 	  SHA512 secure hash standard (DFIPS 180-2).
 
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 660c5c3..ec9cef3 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -10,7 +10,7 @@
  * later version.
  *
  */
-
+#include <crypto/internal/hash.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -138,10 +138,10 @@ sha512_transform(u64 *state, const u8 *input)
 	put_cpu_var(msg_schedule);
 }
 
-static void
-sha512_init(struct crypto_tfm *tfm)
+static int
+sha512_init(struct shash_desc *desc)
 {
-	struct sha512_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha512_ctx *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA512_H0;
 	sctx->state[1] = SHA512_H1;
 	sctx->state[2] = SHA512_H2;
@@ -151,12 +151,14 @@ sha512_init(struct crypto_tfm *tfm)
 	sctx->state[6] = SHA512_H6;
 	sctx->state[7] = SHA512_H7;
 	sctx->count[0] = sctx->count[1] = sctx->count[2] = sctx->count[3] = 0;
+
+	return 0;
 }
 
-static void
-sha384_init(struct crypto_tfm *tfm)
+static int
+sha384_init(struct shash_desc *desc)
 {
-	struct sha512_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha512_ctx *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA384_H0;
 	sctx->state[1] = SHA384_H1;
 	sctx->state[2] = SHA384_H2;
@@ -166,12 +168,14 @@ sha384_init(struct crypto_tfm *tfm)
 	sctx->state[6] = SHA384_H6;
 	sctx->state[7] = SHA384_H7;
         sctx->count[0] = sctx->count[1] = sctx->count[2] = sctx->count[3] = 0;
+
+	return 0;
 }
 
-static void
-sha512_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+static int
+sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
-	struct sha512_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha512_ctx *sctx = shash_desc_ctx(desc);
 
 	unsigned int i, index, part_len;
 
@@ -203,12 +207,14 @@ sha512_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 
 	/* Buffer remaining input */
 	memcpy(&sctx->buf[index], &data[i], len - i);
+
+	return 0;
 }
 
-static void
-sha512_final(struct crypto_tfm *tfm, u8 *hash)
+static int
+sha512_final(struct shash_desc *desc, u8 *hash)
 {
-	struct sha512_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha512_ctx *sctx = shash_desc_ctx(desc);
         static u8 padding[128] = { 0x80, };
 	__be64 *dst = (__be64 *)hash;
 	__be32 bits[4];
@@ -224,10 +230,10 @@ sha512_final(struct crypto_tfm *tfm, u8 *hash)
 	/* Pad out to 112 mod 128. */
 	index = (sctx->count[0] >> 3) & 0x7f;
 	pad_len = (index < 112) ? (112 - index) : ((128+112) - index);
-	sha512_update(tfm, padding, pad_len);
+	sha512_update(desc, padding, pad_len);
 
 	/* Append length (before padding) */
-	sha512_update(tfm, (const u8 *)bits, sizeof(bits));
+	sha512_update(desc, (const u8 *)bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
@@ -235,66 +241,66 @@ sha512_final(struct crypto_tfm *tfm, u8 *hash)
 
 	/* Zeroize sensitive information. */
 	memset(sctx, 0, sizeof(struct sha512_ctx));
+
+	return 0;
 }
 
-static void sha384_final(struct crypto_tfm *tfm, u8 *hash)
+static int sha384_final(struct shash_desc *desc, u8 *hash)
 {
-        u8 D[64];
+	u8 D[64];
 
-	sha512_final(tfm, D);
+	sha512_final(desc, D);
 
-        memcpy(hash, D, 48);
-        memset(D, 0, 64);
+	memcpy(hash, D, 48);
+	memset(D, 0, 64);
+
+	return 0;
 }
 
-static struct crypto_alg sha512 = {
-        .cra_name       = "sha512",
-        .cra_flags      = CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize  = SHA512_BLOCK_SIZE,
-        .cra_ctxsize    = sizeof(struct sha512_ctx),
-        .cra_module     = THIS_MODULE,
-	.cra_alignmask	= 3,
-        .cra_list       = LIST_HEAD_INIT(sha512.cra_list),
-        .cra_u          = { .digest = {
-                                .dia_digestsize = SHA512_DIGEST_SIZE,
-                                .dia_init       = sha512_init,
-                                .dia_update     = sha512_update,
-                                .dia_final      = sha512_final }
-        }
+static struct shash_alg sha512 = {
+	.digestsize	=	SHA512_DIGEST_SIZE,
+	.init		=	sha512_init,
+	.update		=	sha512_update,
+	.final		=	sha512_final,
+	.descsize	=	sizeof(struct sha512_ctx),
+	.base		=	{
+		.cra_name	=	"sha512",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
-static struct crypto_alg sha384 = {
-        .cra_name       = "sha384",
-        .cra_flags      = CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize  = SHA384_BLOCK_SIZE,
-        .cra_ctxsize    = sizeof(struct sha512_ctx),
-	.cra_alignmask	= 3,
-        .cra_module     = THIS_MODULE,
-        .cra_list       = LIST_HEAD_INIT(sha384.cra_list),
-        .cra_u          = { .digest = {
-                                .dia_digestsize = SHA384_DIGEST_SIZE,
-                                .dia_init       = sha384_init,
-                                .dia_update     = sha512_update,
-                                .dia_final      = sha384_final }
-        }
+static struct shash_alg sha384 = {
+	.digestsize	=	SHA384_DIGEST_SIZE,
+	.init		=	sha384_init,
+	.update		=	sha512_update,
+	.final		=	sha384_final,
+	.descsize	=	sizeof(struct sha512_ctx),
+	.base		=	{
+		.cra_name	=	"sha384",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA384_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init sha512_generic_mod_init(void)
 {
         int ret = 0;
 
-        if ((ret = crypto_register_alg(&sha384)) < 0)
+        if ((ret = crypto_register_shash(&sha384)) < 0)
                 goto out;
-        if ((ret = crypto_register_alg(&sha512)) < 0)
-                crypto_unregister_alg(&sha384);
+        if ((ret = crypto_register_shash(&sha512)) < 0)
+                crypto_unregister_shash(&sha384);
 out:
         return ret;
 }
 
 static void __exit sha512_generic_mod_fini(void)
 {
-        crypto_unregister_alg(&sha384);
-        crypto_unregister_alg(&sha512);
+        crypto_unregister_shash(&sha384);
+        crypto_unregister_shash(&sha512);
 }
 
 module_init(sha512_generic_mod_init);
-- 
1.5.2.5

