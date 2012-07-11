From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/14] crypto: crypto_null - use crypto_[un]register_algs
Date: Wed, 11 Jul 2012 14:20:00 +0300
Message-ID: <20120711112000.6875.40518.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:40525 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2GKLUD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:03 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/crypto_null.c |   57 ++++++++++++++++----------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 07a8a96..fee7265 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -94,18 +94,6 @@ static int skcipher_null_crypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static struct crypto_alg compress_null = {
-	.cra_name		=	"compress_null",
-	.cra_flags		=	CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_blocksize		=	NULL_BLOCK_SIZE,
-	.cra_ctxsize		=	0,
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=       LIST_HEAD_INIT(compress_null.cra_list),
-	.cra_u			=	{ .compress = {
-	.coa_compress 		=	null_compress,
-	.coa_decompress		=	null_compress } }
-};
-
 static struct shash_alg digest_null = {
 	.digestsize		=	NULL_DIGEST_SIZE,
 	.setkey   		=	null_hash_setkey,
@@ -122,22 +110,19 @@ static struct shash_alg digest_null = {
 	}
 };
 
-static struct crypto_alg cipher_null = {
+static struct crypto_alg null_algs[3] = { {
 	.cra_name		=	"cipher_null",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	NULL_BLOCK_SIZE,
 	.cra_ctxsize		=	0,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(cipher_null.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	NULL_KEY_SIZE,
 	.cia_max_keysize	=	NULL_KEY_SIZE,
 	.cia_setkey		= 	null_setkey,
 	.cia_encrypt		=	null_crypt,
 	.cia_decrypt		=	null_crypt } }
-};
-
-static struct crypto_alg skcipher_null = {
+}, {
 	.cra_name		=	"ecb(cipher_null)",
 	.cra_driver_name	=	"ecb-cipher_null",
 	.cra_priority		=	100,
@@ -146,7 +131,6 @@ static struct crypto_alg skcipher_null = {
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_ctxsize		=	0,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(skcipher_null.cra_list),
 	.cra_u			=	{ .blkcipher = {
 	.min_keysize		=	NULL_KEY_SIZE,
 	.max_keysize		=	NULL_KEY_SIZE,
@@ -154,7 +138,16 @@ static struct crypto_alg skcipher_null = {
 	.setkey			= 	null_setkey,
 	.encrypt		=	skcipher_null_crypt,
 	.decrypt		=	skcipher_null_crypt } }
-};
+}, {
+	.cra_name		=	"compress_null",
+	.cra_flags		=	CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_blocksize		=	NULL_BLOCK_SIZE,
+	.cra_ctxsize		=	0,
+	.cra_module		=	THIS_MODULE,
+	.cra_u			=	{ .compress = {
+	.coa_compress		=	null_compress,
+	.coa_decompress		=	null_compress } }
+} };
 
 MODULE_ALIAS("compress_null");
 MODULE_ALIAS("digest_null");
@@ -164,40 +157,26 @@ static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
 
-	ret = crypto_register_alg(&cipher_null);
+	ret = crypto_register_algs(null_algs, ARRAY_SIZE(null_algs));
 	if (ret < 0)
 		goto out;
 
-	ret = crypto_register_alg(&skcipher_null);
-	if (ret < 0)
-		goto out_unregister_cipher;
-
 	ret = crypto_register_shash(&digest_null);
 	if (ret < 0)
-		goto out_unregister_skcipher;
+		goto out_unregister_algs;
 
-	ret = crypto_register_alg(&compress_null);
-	if (ret < 0)
-		goto out_unregister_digest;
+	return 0;
 
+out_unregister_algs:
+	crypto_unregister_algs(null_algs, ARRAY_SIZE(null_algs));
 out:
 	return ret;
-
-out_unregister_digest:
-	crypto_unregister_shash(&digest_null);
-out_unregister_skcipher:
-	crypto_unregister_alg(&skcipher_null);
-out_unregister_cipher:
-	crypto_unregister_alg(&cipher_null);
-	goto out;
 }
 
 static void __exit crypto_null_mod_fini(void)
 {
-	crypto_unregister_alg(&compress_null);
 	crypto_unregister_shash(&digest_null);
-	crypto_unregister_alg(&skcipher_null);
-	crypto_unregister_alg(&cipher_null);
+	crypto_unregister_algs(null_algs, ARRAY_SIZE(null_algs));
 }
 
 module_init(crypto_null_mod_init);
