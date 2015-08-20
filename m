From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: testmgr - Use new skcipher interface
Date: Thu, 20 Aug 2015 15:21:46 +0800
Message-ID: <E1ZSKAU-000766-RY@gondolin.me.apana.org.au>
References: <20150820072055.GA27176@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53057 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbHTHVt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:21:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZSKAV-0000WP-0L
	for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2015 17:21:47 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces uses of blkcipher and ablkcipher with the
new skcipher interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |   61 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0a42bd..e6ed04b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -22,6 +22,7 @@
 
 #include <crypto/aead.h>
 #include <crypto/hash.h>
+#include <crypto/skcipher.h>
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/module.h>
@@ -921,15 +922,15 @@ out_nobuf:
 	return ret;
 }
 
-static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
+static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 			   struct cipher_testvec *template, unsigned int tcount,
 			   const bool diff_dst, const int align_offset)
 {
 	const char *algo =
-		crypto_tfm_alg_driver_name(crypto_ablkcipher_tfm(tfm));
+		crypto_tfm_alg_driver_name(crypto_skcipher_tfm(tfm));
 	unsigned int i, j, k, n, temp;
 	char *q;
-	struct ablkcipher_request *req;
+	struct skcipher_request *req;
 	struct scatterlist sg[8];
 	struct scatterlist sgout[8];
 	const char *e, *d;
@@ -958,15 +959,15 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 	init_completion(&result.completion);
 
-	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		pr_err("alg: skcipher%s: Failed to allocate request for %s\n",
 		       d, algo);
 		goto out;
 	}
 
-	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					tcrypt_complete, &result);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &result);
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
@@ -987,15 +988,16 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		data += align_offset;
 		memcpy(data, template[i].input, template[i].ilen);
 
-		crypto_ablkcipher_clear_flags(tfm, ~0);
+		crypto_skcipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_skcipher_set_flags(tfm,
+						  CRYPTO_TFM_REQ_WEAK_KEY);
 
-		ret = crypto_ablkcipher_setkey(tfm, template[i].key,
-					       template[i].klen);
+		ret = crypto_skcipher_setkey(tfm, template[i].key,
+					     template[i].klen);
 		if (!ret == template[i].fail) {
 			pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
-			       d, j, algo, crypto_ablkcipher_get_flags(tfm));
+			       d, j, algo, crypto_skcipher_get_flags(tfm));
 			goto out;
 		} else if (ret)
 			continue;
@@ -1007,10 +1009,10 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			sg_init_one(&sgout[0], data, template[i].ilen);
 		}
 
-		ablkcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-					     template[i].ilen, iv);
-		ret = enc ? crypto_ablkcipher_encrypt(req) :
-			    crypto_ablkcipher_decrypt(req);
+		skcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
+					   template[i].ilen, iv);
+		ret = enc ? crypto_skcipher_encrypt(req) :
+			    crypto_skcipher_decrypt(req);
 
 		switch (ret) {
 		case 0:
@@ -1054,15 +1056,16 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			memset(iv, 0, MAX_IVLEN);
 
 		j++;
-		crypto_ablkcipher_clear_flags(tfm, ~0);
+		crypto_skcipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_skcipher_set_flags(tfm,
+						  CRYPTO_TFM_REQ_WEAK_KEY);
 
-		ret = crypto_ablkcipher_setkey(tfm, template[i].key,
-					       template[i].klen);
+		ret = crypto_skcipher_setkey(tfm, template[i].key,
+					     template[i].klen);
 		if (!ret == template[i].fail) {
 			pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
-			       d, j, algo, crypto_ablkcipher_get_flags(tfm));
+			       d, j, algo, crypto_skcipher_get_flags(tfm));
 			goto out;
 		} else if (ret)
 			continue;
@@ -1100,11 +1103,11 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			temp += template[i].tap[k];
 		}
 
-		ablkcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-					     template[i].ilen, iv);
+		skcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
+					   template[i].ilen, iv);
 
-		ret = enc ? crypto_ablkcipher_encrypt(req) :
-			    crypto_ablkcipher_decrypt(req);
+		ret = enc ? crypto_skcipher_encrypt(req) :
+			    crypto_skcipher_decrypt(req);
 
 		switch (ret) {
 		case 0:
@@ -1157,7 +1160,7 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 	ret = 0;
 
 out:
-	ablkcipher_request_free(req);
+	skcipher_request_free(req);
 	if (diff_dst)
 		testmgr_free_buf(xoutbuf);
 out_nooutbuf:
@@ -1166,7 +1169,7 @@ out_nobuf:
 	return ret;
 }
 
-static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
+static int test_skcipher(struct crypto_skcipher *tfm, int enc,
 			 struct cipher_testvec *template, unsigned int tcount)
 {
 	unsigned int alignmask;
@@ -1578,10 +1581,10 @@ out:
 static int alg_test_skcipher(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
-	struct crypto_ablkcipher *tfm;
+	struct crypto_skcipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_ablkcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_skcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1600,7 +1603,7 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 				    desc->suite.cipher.dec.count);
 
 out:
-	crypto_free_ablkcipher(tfm);
+	crypto_free_skcipher(tfm);
 	return err;
 }
 
