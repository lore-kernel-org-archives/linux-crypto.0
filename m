From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 3/7] crypto/testmgr: add testing for arc4 based on ecb(arc4)
Date: Sat,  3 Apr 2010 09:49:25 +0200
Message-ID: <1270280969-11357-4-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53099 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab0DCHtk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Apr 2010 03:49:40 -0400
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 crypto/testmgr.c |   60 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7620bfc..c471e04 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <crypto/rng.h>
+#include <crypto/arc4.h>
 
 #include "internal.h"
 #include "testmgr.h"
@@ -44,6 +45,7 @@
 /*
 * Used by test_cipher()
 */
+#define CRYPT_ARC4 2
 #define ENCRYPT 1
 #define DECRYPT 0
 
@@ -717,7 +719,7 @@ out_nobuf:
 	return ret;
 }
 
-static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
+static int test_skcipher(struct crypto_ablkcipher *tfm, int mode,
 			 struct cipher_testvec *template, unsigned int tcount)
 {
 	const char *algo =
@@ -736,7 +738,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 	if (testmgr_alloc_buf(xbuf))
 		goto out_nobuf;
 
-	if (enc == ENCRYPT)
+	if (mode == ENCRYPT)
 	        e = "encryption";
 	else
 		e = "decryption";
@@ -775,7 +777,11 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				crypto_ablkcipher_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
+			if (mode == CRYPT_ARC4)
+				arc4_setup_iv((struct arc4_iv *)iv,
+					template[i].key, template[i].klen);
+			else
+				ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
 				printk(KERN_ERR "alg: skcipher: setkey failed "
@@ -789,7 +795,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 			ablkcipher_request_set_crypt(req, sg, sg,
 						     template[i].ilen, iv);
-			ret = enc ?
+			ret = mode ?
 				crypto_ablkcipher_encrypt(req) :
 				crypto_ablkcipher_decrypt(req);
 
@@ -839,7 +845,11 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				crypto_ablkcipher_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
+			if (mode == CRYPT_ARC4)
+				arc4_setup_iv((struct arc4_iv *)iv,
+					template[i].key, template[i].klen);
+			else
+				ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
 				printk(KERN_ERR "alg: skcipher: setkey failed "
@@ -876,7 +886,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			ablkcipher_request_set_crypt(req, sg, sg,
 					template[i].ilen, iv);
 
-			ret = enc ?
+			ret = mode ?
 				crypto_ablkcipher_encrypt(req) :
 				crypto_ablkcipher_decrypt(req);
 
@@ -1316,11 +1326,12 @@ out:
 	return err;
 }
 
-static int alg_test_skcipher(const struct alg_test_desc *desc,
-			     const char *driver, u32 type, u32 mask)
+static int _alg_test_skcipher(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask, u32 arc4)
 {
 	struct crypto_ablkcipher *tfm;
 	int err = 0;
+	int mode;
 
 	tfm = crypto_alloc_ablkcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
@@ -1329,15 +1340,17 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 		return PTR_ERR(tfm);
 	}
 
+	mode = arc4 ? CRYPT_ARC4 : ENCRYPT;
 	if (desc->suite.cipher.enc.vecs) {
-		err = test_skcipher(tfm, ENCRYPT, desc->suite.cipher.enc.vecs,
+		err = test_skcipher(tfm, mode , desc->suite.cipher.enc.vecs,
 				    desc->suite.cipher.enc.count);
 		if (err)
 			goto out;
 	}
 
+	mode = arc4 ? CRYPT_ARC4 : DECRYPT;
 	if (desc->suite.cipher.dec.vecs)
-		err = test_skcipher(tfm, DECRYPT, desc->suite.cipher.dec.vecs,
+		err = test_skcipher(tfm, mode, desc->suite.cipher.dec.vecs,
 				    desc->suite.cipher.dec.count);
 
 out:
@@ -1345,6 +1358,18 @@ out:
 	return err;
 }
 
+static int alg_test_skcipher(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	return _alg_test_skcipher(desc, driver, type, mask, 0);
+}
+
+static int alg_test_arc4_skcipher(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	return _alg_test_skcipher(desc, driver, type, mask, 1);
+}
+
 static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -1490,6 +1515,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "arc4",
+		.test = alg_test_arc4_skcipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = arc4_enc_tv_template,
+					.count = ARC4_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = arc4_dec_tv_template,
+					.count = ARC4_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
-- 
1.6.6

