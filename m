From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] [CRYPTO] null: Add null blkcipher algorithm
Date: Fri, 14 Dec 2007 16:39:42 +0800
Message-ID: <E1J3658-00046r-00@gondolin.me.apana.org.au>
References: <20071214083909.GA15726@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4696 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756416AbXLNIjp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 03:39:45 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J3659-00008v-Fc
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 19:39:43 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] null: Add null blkcipher algorithm

This patch adds a null blkcipher algorithm called ecb(cipher_null) for
backwards compatibility.  Previously the null algorithm when used by
IPsec copied the data byte by byte.  This new algorithm optimises that
to a straight memcpy which lets us better measure inherent overheads in
our IPsec code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_null.c               |   69 +++++++++++++++++++++++++++++++------
 include/crypto/internal/skcipher.h |    5 ++
 2 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 29f7747..fc2d2a4 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -16,15 +16,17 @@
  * (at your option) any later version.
  *
  */
+
+#include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/crypto.h>
 #include <linux/string.h>
 
 #define NULL_KEY_SIZE		0
 #define NULL_BLOCK_SIZE		1
 #define NULL_DIGEST_SIZE	0
+#define NULL_IV_SIZE		0
 
 static int null_compress(struct crypto_tfm *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen)
@@ -55,6 +57,26 @@ static void null_crypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	memcpy(dst, src, NULL_BLOCK_SIZE);
 }
 
+static int skcipher_null_crypt(struct blkcipher_desc *desc,
+			       struct scatterlist *dst,
+			       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while (walk.nbytes) {
+		if (walk.src.virt.addr != walk.dst.virt.addr)
+			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       walk.nbytes);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
 static struct crypto_alg compress_null = {
 	.cra_name		=	"compress_null",
 	.cra_flags		=	CRYPTO_ALG_TYPE_COMPRESS,
@@ -96,6 +118,25 @@ static struct crypto_alg cipher_null = {
 	.cia_decrypt		=	null_crypt } }
 };
 
+static struct crypto_alg skcipher_null = {
+	.cra_name		=	"ecb(cipher_null)",
+	.cra_driver_name	=	"ecb-cipher_null",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	NULL_BLOCK_SIZE,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_ctxsize		=	0,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(skcipher_null.cra_list),
+	.cra_u			=	{ .blkcipher = {
+	.min_keysize		=	NULL_KEY_SIZE,
+	.max_keysize		=	NULL_KEY_SIZE,
+	.ivsize			=	NULL_IV_SIZE,
+	.setkey			= 	null_setkey,
+	.encrypt		=	skcipher_null_crypt,
+	.decrypt		=	skcipher_null_crypt } }
+};
+
 MODULE_ALIAS("compress_null");
 MODULE_ALIAS("digest_null");
 MODULE_ALIAS("cipher_null");
@@ -108,27 +149,35 @@ static int __init init(void)
 	if (ret < 0)
 		goto out;
 
+	ret = crypto_register_alg(&skcipher_null);
+	if (ret < 0)
+		goto out_unregister_cipher;
+
 	ret = crypto_register_alg(&digest_null);
-	if (ret < 0) {
-		crypto_unregister_alg(&cipher_null);
-		goto out;
-	}
+	if (ret < 0)
+		goto out_unregister_skcipher;
 
 	ret = crypto_register_alg(&compress_null);
-	if (ret < 0) {
-		crypto_unregister_alg(&digest_null);
-		crypto_unregister_alg(&cipher_null);
-		goto out;
-	}
+	if (ret < 0)
+		goto out_unregister_digest;
 
 out:	
 	return ret;
+
+out_unregister_digest:
+	crypto_unregister_alg(&digest_null);
+out_unregister_skcipher:
+	crypto_unregister_alg(&skcipher_null);
+out_unregister_cipher:
+	crypto_unregister_alg(&cipher_null);
+	goto out;
 }
 
 static void __exit fini(void)
 {
 	crypto_unregister_alg(&compress_null);
 	crypto_unregister_alg(&digest_null);
+	crypto_unregister_alg(&skcipher_null);
 	crypto_unregister_alg(&cipher_null);
 }
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 80c5bfb..ecf2c8d 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -86,5 +86,10 @@ static inline void skcipher_givcrypt_complete(
 	ablkcipher_request_complete(&req->creq, err);
 }
 
+static inline u32 ablkcipher_request_flags(struct ablkcipher_request *req)
+{
+	return req->base.flags;
+}
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
