Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfADEU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:58 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/16] crypto: arc4 - convert to skcipher API
Date: Thu,  3 Jan 2019 20:16:23 -0800
Message-Id: <20190104041625.3259-15-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert the "ecb(arc4)" algorithm from the deprecated "blkcipher" API to
the "skcipher" API.

(Note that this is really a stream cipher and not a block cipher in ECB
mode as the name implies, but that's a problem for another day...)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/arc4.c | 82 +++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index f1a81925558fa..652d24399afa6 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -12,10 +12,10 @@
  *
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/crypto.h>
 #include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/init.h>
+#include <linux/module.h>
 
 #define ARC4_MIN_KEY_SIZE	1
 #define ARC4_MAX_KEY_SIZE	256
@@ -50,6 +50,12 @@ static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
+static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
+				 unsigned int key_len)
+{
+	return arc4_set_key(&tfm->base, in_key, key_len);
+}
+
 static void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in,
 		       unsigned int len)
 {
@@ -92,30 +98,25 @@ static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
 }
 
-static int ecb_arc4_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-			  struct scatterlist *src, unsigned int nbytes)
+static int ecb_arc4_crypt(struct skcipher_request *req)
 {
-	struct arc4_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
-		u8 *wsrc = walk.src.virt.addr;
-		u8 *wdst = walk.dst.virt.addr;
-
-		arc4_crypt(ctx, wdst, wsrc, walk.nbytes);
-
-		err = blkcipher_walk_done(desc, &walk, 0);
+		arc4_crypt(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			   walk.nbytes);
+		err = skcipher_walk_done(&walk, 0);
 	}
 
 	return err;
 }
 
-static struct crypto_alg arc4_algs[2] = { {
+static struct crypto_alg arc4_cipher = {
 	.cra_name		=	"arc4",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ARC4_BLOCK_SIZE,
@@ -130,34 +131,39 @@ static struct crypto_alg arc4_algs[2] = { {
 			.cia_decrypt		=	arc4_crypt_one,
 		},
 	},
-}, {
-	.cra_name		=	"ecb(arc4)",
-	.cra_priority		=	100,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	ARC4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct arc4_ctx),
-	.cra_alignmask		=	0,
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize	=	ARC4_MIN_KEY_SIZE,
-			.max_keysize	=	ARC4_MAX_KEY_SIZE,
-			.setkey		=	arc4_set_key,
-			.encrypt	=	ecb_arc4_crypt,
-			.decrypt	=	ecb_arc4_crypt,
-		},
-	},
-} };
+};
+
+static struct skcipher_alg arc4_skcipher = {
+	.base.cra_name		=	"ecb(arc4)",
+	.base.cra_priority	=	100,
+	.base.cra_blocksize	=	ARC4_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct arc4_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.min_keysize		=	ARC4_MIN_KEY_SIZE,
+	.max_keysize		=	ARC4_MAX_KEY_SIZE,
+	.setkey			=	arc4_set_key_skcipher,
+	.encrypt		=	ecb_arc4_crypt,
+	.decrypt		=	ecb_arc4_crypt,
+};
 
 static int __init arc4_init(void)
 {
-	return crypto_register_algs(arc4_algs, ARRAY_SIZE(arc4_algs));
+	int err;
+
+	err = crypto_register_alg(&arc4_cipher);
+	if (err)
+		return err;
+
+	err = crypto_register_skcipher(&arc4_skcipher);
+	if (err)
+		crypto_unregister_alg(&arc4_cipher);
+	return err;
 }
 
 static void __exit arc4_exit(void)
 {
-	crypto_unregister_algs(arc4_algs, ARRAY_SIZE(arc4_algs));
+	crypto_unregister_alg(&arc4_cipher);
+	crypto_unregister_skcipher(&arc4_skcipher);
 }
 
 module_init(arc4_init);
-- 
2.20.1
