From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/28] crypto: tcrypt - Use skcipher
Date: Wed, 29 Jun 2016 18:03:50 +0800
Message-ID: <E1bICLW-0006s2-IT@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54807 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbcF2KDy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:03:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLW-0005FS-Mo
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:50 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts tcrypt to use the new skcipher interface as
opposed to ablkcipher/blkcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |  241 ++++++++++----------------------------------------------
 1 file changed, 44 insertions(+), 197 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 4675459..9ca822c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -24,6 +24,7 @@
 
 #include <crypto/aead.h>
 #include <crypto/hash.h>
+#include <crypto/skcipher.h>
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/init.h>
@@ -92,76 +93,6 @@ static void tcrypt_complete(struct crypto_async_request *req, int err)
 	complete(&res->completion);
 }
 
-static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
-			       struct scatterlist *sg, int blen, int secs)
-{
-	unsigned long start, end;
-	int bcount;
-	int ret;
-
-	for (start = jiffies, end = start + secs * HZ, bcount = 0;
-	     time_before(jiffies, end); bcount++) {
-		if (enc)
-			ret = crypto_blkcipher_encrypt(desc, sg, sg, blen);
-		else
-			ret = crypto_blkcipher_decrypt(desc, sg, sg, blen);
-
-		if (ret)
-			return ret;
-	}
-
-	printk("%d operations in %d seconds (%ld bytes)\n",
-	       bcount, secs, (long)bcount * blen);
-	return 0;
-}
-
-static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
-			      struct scatterlist *sg, int blen)
-{
-	unsigned long cycles = 0;
-	int ret = 0;
-	int i;
-
-	local_irq_disable();
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		if (enc)
-			ret = crypto_blkcipher_encrypt(desc, sg, sg, blen);
-		else
-			ret = crypto_blkcipher_decrypt(desc, sg, sg, blen);
-
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-		if (enc)
-			ret = crypto_blkcipher_encrypt(desc, sg, sg, blen);
-		else
-			ret = crypto_blkcipher_decrypt(desc, sg, sg, blen);
-		end = get_cycles();
-
-		if (ret)
-			goto out;
-
-		cycles += end - start;
-	}
-
-out:
-	local_irq_enable();
-
-	if (ret == 0)
-		printk("1 operation in %lu cycles (%d bytes)\n",
-		       (cycles + 4) / 8, blen);
-
-	return ret;
-}
-
 static inline int do_one_aead_op(struct aead_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
@@ -455,106 +386,6 @@ out_noxbuf:
 	return;
 }
 
-static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
-			      struct cipher_speed_template *template,
-			      unsigned int tcount, u8 *keysize)
-{
-	unsigned int ret, i, j, iv_len;
-	const char *key;
-	char iv[128];
-	struct crypto_blkcipher *tfm;
-	struct blkcipher_desc desc;
-	const char *e;
-	u32 *b_size;
-
-	if (enc == ENCRYPT)
-	        e = "encryption";
-	else
-		e = "decryption";
-
-	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
-
-	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
-		return;
-	}
-	desc.tfm = tfm;
-	desc.flags = 0;
-
-	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
-			get_driver_name(crypto_blkcipher, tfm), e);
-
-	i = 0;
-	do {
-
-		b_size = block_sizes;
-		do {
-			struct scatterlist sg[TVMEMSIZE];
-
-			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
-				printk("template (%u) too big for "
-				       "tvmem (%lu)\n", *keysize + *b_size,
-				       TVMEMSIZE * PAGE_SIZE);
-				goto out;
-			}
-
-			printk("test %u (%d bit key, %d byte blocks): ", i,
-					*keysize * 8, *b_size);
-
-			memset(tvmem[0], 0xff, PAGE_SIZE);
-
-			/* set key, plain text and IV */
-			key = tvmem[0];
-			for (j = 0; j < tcount; j++) {
-				if (template[j].klen == *keysize) {
-					key = template[j].key;
-					break;
-				}
-			}
-
-			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
-			if (ret) {
-				printk("setkey() failed flags=%x\n",
-						crypto_blkcipher_get_flags(tfm));
-				goto out;
-			}
-
-			sg_init_table(sg, TVMEMSIZE);
-			sg_set_buf(sg, tvmem[0] + *keysize,
-				   PAGE_SIZE - *keysize);
-			for (j = 1; j < TVMEMSIZE; j++) {
-				sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
-				memset (tvmem[j], 0xff, PAGE_SIZE);
-			}
-
-			iv_len = crypto_blkcipher_ivsize(tfm);
-			if (iv_len) {
-				memset(&iv, 0xff, iv_len);
-				crypto_blkcipher_set_iv(tfm, iv, iv_len);
-			}
-
-			if (secs)
-				ret = test_cipher_jiffies(&desc, enc, sg,
-							  *b_size, secs);
-			else
-				ret = test_cipher_cycles(&desc, enc, sg,
-							 *b_size);
-
-			if (ret) {
-				printk("%s() failed flags=%x\n", e, desc.flags);
-				break;
-			}
-			b_size++;
-			i++;
-		} while (*b_size);
-		keysize++;
-	} while (*keysize);
-
-out:
-	crypto_free_blkcipher(tfm);
-}
-
 static void test_hash_sg_init(struct scatterlist *sg)
 {
 	int i;
@@ -813,7 +644,7 @@ static void test_hash_speed(const char *algo, unsigned int secs,
 	return test_ahash_speed_common(algo, secs, speed, CRYPTO_ALG_ASYNC);
 }
 
-static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
+static inline int do_one_acipher_op(struct skcipher_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
 		struct tcrypt_result *tr = req->base.data;
@@ -826,7 +657,7 @@ static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
 	return ret;
 }
 
-static int test_acipher_jiffies(struct ablkcipher_request *req, int enc,
+static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 				int blen, int secs)
 {
 	unsigned long start, end;
@@ -837,10 +668,10 @@ static int test_acipher_jiffies(struct ablkcipher_request *req, int enc,
 	     time_before(jiffies, end); bcount++) {
 		if (enc)
 			ret = do_one_acipher_op(req,
-						crypto_ablkcipher_encrypt(req));
+						crypto_skcipher_encrypt(req));
 		else
 			ret = do_one_acipher_op(req,
-						crypto_ablkcipher_decrypt(req));
+						crypto_skcipher_decrypt(req));
 
 		if (ret)
 			return ret;
@@ -851,7 +682,7 @@ static int test_acipher_jiffies(struct ablkcipher_request *req, int enc,
 	return 0;
 }
 
-static int test_acipher_cycles(struct ablkcipher_request *req, int enc,
+static int test_acipher_cycles(struct skcipher_request *req, int enc,
 			       int blen)
 {
 	unsigned long cycles = 0;
@@ -862,10 +693,10 @@ static int test_acipher_cycles(struct ablkcipher_request *req, int enc,
 	for (i = 0; i < 4; i++) {
 		if (enc)
 			ret = do_one_acipher_op(req,
-						crypto_ablkcipher_encrypt(req));
+						crypto_skcipher_encrypt(req));
 		else
 			ret = do_one_acipher_op(req,
-						crypto_ablkcipher_decrypt(req));
+						crypto_skcipher_decrypt(req));
 
 		if (ret)
 			goto out;
@@ -878,10 +709,10 @@ static int test_acipher_cycles(struct ablkcipher_request *req, int enc,
 		start = get_cycles();
 		if (enc)
 			ret = do_one_acipher_op(req,
-						crypto_ablkcipher_encrypt(req));
+						crypto_skcipher_encrypt(req));
 		else
 			ret = do_one_acipher_op(req,
-						crypto_ablkcipher_decrypt(req));
+						crypto_skcipher_decrypt(req));
 		end = get_cycles();
 
 		if (ret)
@@ -898,16 +729,16 @@ out:
 	return ret;
 }
 
-static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
-			       struct cipher_speed_template *template,
-			       unsigned int tcount, u8 *keysize)
+static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
+				struct cipher_speed_template *template,
+				unsigned int tcount, u8 *keysize, bool async)
 {
 	unsigned int ret, i, j, k, iv_len;
 	struct tcrypt_result tresult;
 	const char *key;
 	char iv[128];
-	struct ablkcipher_request *req;
-	struct crypto_ablkcipher *tfm;
+	struct skcipher_request *req;
+	struct crypto_skcipher *tfm;
 	const char *e;
 	u32 *b_size;
 
@@ -918,7 +749,7 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 
 	init_completion(&tresult.completion);
 
-	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
+	tfm = crypto_alloc_skcipher(algo, 0, async ? 0 : CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
 		pr_err("failed to load transform for %s: %ld\n", algo,
@@ -927,17 +758,17 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	pr_info("\ntesting speed of async %s (%s) %s\n", algo,
-			get_driver_name(crypto_ablkcipher, tfm), e);
+			get_driver_name(crypto_skcipher, tfm), e);
 
-	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
 		       algo);
 		goto out;
 	}
 
-	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					tcrypt_complete, &tresult);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &tresult);
 
 	i = 0;
 	do {
@@ -967,12 +798,12 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 				}
 			}
 
-			crypto_ablkcipher_clear_flags(tfm, ~0);
+			crypto_skcipher_clear_flags(tfm, ~0);
 
-			ret = crypto_ablkcipher_setkey(tfm, key, *keysize);
+			ret = crypto_skcipher_setkey(tfm, key, *keysize);
 			if (ret) {
 				pr_err("setkey() failed flags=%x\n",
-					crypto_ablkcipher_get_flags(tfm));
+					crypto_skcipher_get_flags(tfm));
 				goto out_free_req;
 			}
 
@@ -996,11 +827,11 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 				sg_set_buf(sg, tvmem[0] + *keysize, *b_size);
 			}
 
-			iv_len = crypto_ablkcipher_ivsize(tfm);
+			iv_len = crypto_skcipher_ivsize(tfm);
 			if (iv_len)
 				memset(&iv, 0xff, iv_len);
 
-			ablkcipher_request_set_crypt(req, sg, sg, *b_size, iv);
+			skcipher_request_set_crypt(req, sg, sg, *b_size, iv);
 
 			if (secs)
 				ret = test_acipher_jiffies(req, enc,
@@ -1011,7 +842,7 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 
 			if (ret) {
 				pr_err("%s() failed flags=%x\n", e,
-					crypto_ablkcipher_get_flags(tfm));
+				       crypto_skcipher_get_flags(tfm));
 				break;
 			}
 			b_size++;
@@ -1021,9 +852,25 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 	} while (*keysize);
 
 out_free_req:
-	ablkcipher_request_free(req);
+	skcipher_request_free(req);
 out:
-	crypto_free_ablkcipher(tfm);
+	crypto_free_skcipher(tfm);
+}
+
+static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
+			       struct cipher_speed_template *template,
+			       unsigned int tcount, u8 *keysize)
+{
+	return test_skcipher_speed(algo, enc, secs, template, tcount, keysize,
+				   true);
+}
+
+static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
+			      struct cipher_speed_template *template,
+			      unsigned int tcount, u8 *keysize)
+{
+	return test_skcipher_speed(algo, enc, secs, template, tcount, keysize,
+				   false);
 }
 
 static void test_available(void)
