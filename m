Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbfADEU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:58 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/16] crypto: null - convert ecb-cipher_null to skcipher API
Date: Thu,  3 Jan 2019 20:16:24 -0800
Message-Id: <20190104041625.3259-16-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert the "ecb-cipher_null" algorithm from the deprecated "blkcipher"
API to the "skcipher" API.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_null.c | 57 +++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 0bae59922a805..01630a9c7e011 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -65,6 +65,10 @@ static int null_hash_setkey(struct crypto_shash *tfm, const u8 *key,
 			    unsigned int keylen)
 { return 0; }
 
+static int null_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				unsigned int keylen)
+{ return 0; }
+
 static int null_setkey(struct crypto_tfm *tfm, const u8 *key,
 		       unsigned int keylen)
 { return 0; }
@@ -74,21 +78,18 @@ static void null_crypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	memcpy(dst, src, NULL_BLOCK_SIZE);
 }
 
-static int skcipher_null_crypt(struct blkcipher_desc *desc,
-			       struct scatterlist *dst,
-			       struct scatterlist *src, unsigned int nbytes)
+static int null_skcipher_crypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
+	struct skcipher_walk walk;
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes) {
 		if (walk.src.virt.addr != walk.dst.virt.addr)
 			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
 			       walk.nbytes);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = skcipher_walk_done(&walk, 0);
 	}
 
 	return err;
@@ -109,7 +110,22 @@ static struct shash_alg digest_null = {
 	}
 };
 
-static struct crypto_alg null_algs[3] = { {
+static struct skcipher_alg skcipher_null = {
+	.base.cra_name		=	"ecb(cipher_null)",
+	.base.cra_driver_name	=	"ecb-cipher_null",
+	.base.cra_priority	=	100,
+	.base.cra_blocksize	=	NULL_BLOCK_SIZE,
+	.base.cra_ctxsize	=	0,
+	.base.cra_module	=	THIS_MODULE,
+	.min_keysize		=	NULL_KEY_SIZE,
+	.max_keysize		=	NULL_KEY_SIZE,
+	.ivsize			=	NULL_IV_SIZE,
+	.setkey			=	null_skcipher_setkey,
+	.encrypt		=	null_skcipher_crypt,
+	.decrypt		=	null_skcipher_crypt,
+};
+
+static struct crypto_alg null_algs[] = { {
 	.cra_name		=	"cipher_null",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	NULL_BLOCK_SIZE,
@@ -121,22 +137,6 @@ static struct crypto_alg null_algs[3] = { {
 	.cia_setkey		= 	null_setkey,
 	.cia_encrypt		=	null_crypt,
 	.cia_decrypt		=	null_crypt } }
-}, {
-	.cra_name		=	"ecb(cipher_null)",
-	.cra_driver_name	=	"ecb-cipher_null",
-	.cra_priority		=	100,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	NULL_BLOCK_SIZE,
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_ctxsize		=	0,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{ .blkcipher = {
-	.min_keysize		=	NULL_KEY_SIZE,
-	.max_keysize		=	NULL_KEY_SIZE,
-	.ivsize			=	NULL_IV_SIZE,
-	.setkey			= 	null_setkey,
-	.encrypt		=	skcipher_null_crypt,
-	.decrypt		=	skcipher_null_crypt } }
 }, {
 	.cra_name		=	"compress_null",
 	.cra_flags		=	CRYPTO_ALG_TYPE_COMPRESS,
@@ -199,8 +199,14 @@ static int __init crypto_null_mod_init(void)
 	if (ret < 0)
 		goto out_unregister_algs;
 
+	ret = crypto_register_skcipher(&skcipher_null);
+	if (ret < 0)
+		goto out_unregister_shash;
+
 	return 0;
 
+out_unregister_shash:
+	crypto_unregister_shash(&digest_null);
 out_unregister_algs:
 	crypto_unregister_algs(null_algs, ARRAY_SIZE(null_algs));
 out:
@@ -209,8 +215,9 @@ static int __init crypto_null_mod_init(void)
 
 static void __exit crypto_null_mod_fini(void)
 {
-	crypto_unregister_shash(&digest_null);
 	crypto_unregister_algs(null_algs, ARRAY_SIZE(null_algs));
+	crypto_unregister_shash(&digest_null);
+	crypto_unregister_skcipher(&skcipher_null);
 }
 
 module_init(crypto_null_mod_init);
-- 
2.20.1
