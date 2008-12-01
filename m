From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH] crypto: sha1 - Switch to shash
Date: Tue,  2 Dec 2008 00:56:53 +0100
Message-ID: <1228175813937-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:41293 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYLAX46 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2008 18:56:58 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes sha1 to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/sha1_generic.c |   56 +++++++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index c7c6899..9efef20 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -16,10 +16,10 @@
  * any later version.
  *
  */
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/crypto.h>
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
@@ -31,9 +31,10 @@ struct sha1_ctx {
         u8 buffer[64];
 };
 
-static void sha1_init(struct crypto_tfm *tfm)
+static int sha1_init(struct shash_desc *desc)
 {
-	struct sha1_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha1_ctx *sctx = shash_desc_ctx(desc);
+
 	static const struct sha1_ctx initstate = {
 	  0,
 	  { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
@@ -41,12 +42,14 @@ static void sha1_init(struct crypto_tfm *tfm)
 	};
 
 	*sctx = initstate;
+
+	return 0;
 }
 
-static void sha1_update(struct crypto_tfm *tfm, const u8 *data,
+static int sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct sha1_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha1_ctx *sctx = shash_desc_ctx(desc);
 	unsigned int partial, done;
 	const u8 *src;
 
@@ -74,13 +77,15 @@ static void sha1_update(struct crypto_tfm *tfm, const u8 *data,
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
+
+	return 0;
 }
 
 
 /* Add padding and return the message digest. */
-static void sha1_final(struct crypto_tfm *tfm, u8 *out)
+static int sha1_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_ctx *sctx = crypto_tfm_ctx(tfm);
+	struct sha1_ctx *sctx = shash_desc_ctx(desc);
 	__be32 *dst = (__be32 *)out;
 	u32 i, index, padlen;
 	__be64 bits;
@@ -91,10 +96,10 @@ static void sha1_final(struct crypto_tfm *tfm, u8 *out)
 	/* Pad out to 56 mod 64 */
 	index = sctx->count & 0x3f;
 	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-	sha1_update(tfm, padding, padlen);
+	sha1_update(desc, padding, padlen);
 
 	/* Append length */
-	sha1_update(tfm, (const u8 *)&bits, sizeof(bits));
+	sha1_update(desc, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 5; i++)
@@ -102,32 +107,33 @@ static void sha1_final(struct crypto_tfm *tfm, u8 *out)
 
 	/* Wipe context */
 	memset(sctx, 0, sizeof *sctx);
+
+	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name	=	"sha1",
-	.cra_driver_name=	"sha1-generic",
-	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA1_BLOCK_SIZE,
-	.cra_ctxsize	=	sizeof(struct sha1_ctx),
-	.cra_module	=	THIS_MODULE,
-	.cra_alignmask	=	3,
-	.cra_list       =       LIST_HEAD_INIT(alg.cra_list),
-	.cra_u		=	{ .digest = {
-	.dia_digestsize	=	SHA1_DIGEST_SIZE,
-	.dia_init   	= 	sha1_init,
-	.dia_update 	=	sha1_update,
-	.dia_final  	=	sha1_final } }
+static struct shash_alg alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_init,
+	.update		=	sha1_update,
+	.final		=	sha1_final,
+	.descsize	=	sizeof(struct sha1_ctx),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name=	"sha1-generic",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
 };
 
 static int __init sha1_generic_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit sha1_generic_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(sha1_generic_mod_init);
-- 
1.5.2.5

