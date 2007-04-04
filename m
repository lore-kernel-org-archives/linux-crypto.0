From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [2/2] [CRYPTO] tcrypt: Use async blkcipher interface
Date: Wed, 4 Apr 2007 17:42:04 +1000
Message-ID: <20070404074204.GA31429@gondor.apana.org.au>
References: <20070404051525.GA31361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3247 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992716AbXDDHmI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Apr 2007 03:42:08 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HZ084-00028A-QH
	for <linux-crypto@vger.kernel.org>; Wed, 04 Apr 2007 17:42:04 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HZ084-0008UH-00
	for <linux-crypto@vger.kernel.org>; Wed, 04 Apr 2007 17:42:04 +1000
Content-Disposition: inline
In-Reply-To: <20070404051525.GA31361@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

[CRYPTO] tcrypt: Use async blkcipher interface

This patch converts the tcrypt module to use the asynchronous block cipher
interface.  As all synchronous block ciphers can be used through the async
interface, tcrypt is still able to test them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
1aeb72d6abedc918ff068da88c98136f7ab96c65
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8eaa5aa..f0aed01 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -57,6 +57,11 @@
 #define ENCRYPT 1
 #define DECRYPT 0
 
+struct tcrypt_result {
+	struct completion completion;
+	int err;
+};
+
 static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 
 /*
@@ -84,6 +89,17 @@ static void hexdump(unsigned char *buf, unsigned int len)
 	printk("\n");
 }
 
+static void tcrypt_complete(struct crypto_async_request *req, int err)
+{
+	struct tcrypt_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
 static void test_hash(char *algo, struct hash_testvec *template,
 		      unsigned int tcount)
 {
@@ -203,15 +219,14 @@ static void test_cipher(char *algo, int enc,
 {
 	unsigned int ret, i, j, k, temp;
 	unsigned int tsize;
-	unsigned int iv_len;
-	unsigned int len;
 	char *q;
-	struct crypto_blkcipher *tfm;
+	struct crypto_ablkcipher *tfm;
 	char *key;
 	struct cipher_testvec *cipher_tv;
-	struct blkcipher_desc desc;
+	struct ablkcipher_request *req;
 	struct scatterlist sg[8];
 	const char *e;
+	struct tcrypt_result result;
 
 	if (enc == ENCRYPT)
 	        e = "encryption";
@@ -232,15 +247,24 @@ static void test_cipher(char *algo, int enc,
 	memcpy(tvmem, template, tsize);
 	cipher_tv = (void *)tvmem;
 
-	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
+	init_completion(&result.completion);
+
+	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
 
 	if (IS_ERR(tfm)) {
 		printk("failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		return;
 	}
-	desc.tfm = tfm;
-	desc.flags = 0;
+
+	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		printk("failed to allocate request for %s\n", algo);
+		goto out;
+	}
+
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					tcrypt_complete, &result);
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
@@ -249,17 +273,17 @@ static void test_cipher(char *algo, int enc,
 			printk("test %u (%d bit key):\n",
 			j, cipher_tv[i].klen * 8);
 
-			crypto_blkcipher_clear_flags(tfm, ~0);
+			crypto_ablkcipher_clear_flags(tfm, ~0);
 			if (cipher_tv[i].wk)
-				crypto_blkcipher_set_flags(
+				crypto_ablkcipher_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 			key = cipher_tv[i].key;
 
-			ret = crypto_blkcipher_setkey(tfm, key,
-						      cipher_tv[i].klen);
+			ret = crypto_ablkcipher_setkey(tfm, key,
+						       cipher_tv[i].klen);
 			if (ret) {
 				printk("setkey() failed flags=%x\n",
-				       crypto_blkcipher_get_flags(tfm));
+				       crypto_ablkcipher_get_flags(tfm));
 
 				if (!cipher_tv[i].fail)
 					goto out;
@@ -268,19 +292,28 @@ static void test_cipher(char *algo, int enc,
 			sg_set_buf(&sg[0], cipher_tv[i].input,
 				   cipher_tv[i].ilen);
 
-			iv_len = crypto_blkcipher_ivsize(tfm);
-			if (iv_len)
-				crypto_blkcipher_set_iv(tfm, cipher_tv[i].iv,
-							iv_len);
+			ablkcipher_request_set_crypt(req, sg, sg,
+						     cipher_tv[i].ilen,
+						     cipher_tv[i].iv);
 
-			len = cipher_tv[i].ilen;
 			ret = enc ?
-				crypto_blkcipher_encrypt(&desc, sg, sg, len) :
-				crypto_blkcipher_decrypt(&desc, sg, sg, len);
+				crypto_ablkcipher_encrypt(req) :
+				crypto_ablkcipher_decrypt(req);
 
-			if (ret) {
-				printk("%s () failed flags=%x\n", e,
-				       desc.flags);
+			switch (ret) {
+			case 0:
+				break;
+			case -EINPROGRESS:
+			case -EBUSY:
+				ret = wait_for_completion_interruptible(
+					&result.completion);
+				if (!ret && !((ret = result.err))) {
+					INIT_COMPLETION(result.completion);
+					break;
+				}
+				/* fall through */
+			default:
+				printk("%s () failed err=%d\n", e, -ret);
 				goto out;
 			}
 
@@ -303,17 +336,17 @@ static void test_cipher(char *algo, int enc,
 			printk("test %u (%d bit key):\n",
 			j, cipher_tv[i].klen * 8);
 
-			crypto_blkcipher_clear_flags(tfm, ~0);
+			crypto_ablkcipher_clear_flags(tfm, ~0);
 			if (cipher_tv[i].wk)
-				crypto_blkcipher_set_flags(
+				crypto_ablkcipher_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 			key = cipher_tv[i].key;
 
-			ret = crypto_blkcipher_setkey(tfm, key,
-						      cipher_tv[i].klen);
+			ret = crypto_ablkcipher_setkey(tfm, key,
+						       cipher_tv[i].klen);
 			if (ret) {
 				printk("setkey() failed flags=%x\n",
-				       crypto_blkcipher_get_flags(tfm));
+				       crypto_ablkcipher_get_flags(tfm));
 
 				if (!cipher_tv[i].fail)
 					goto out;
@@ -329,19 +362,28 @@ static void test_cipher(char *algo, int enc,
 					   cipher_tv[i].tap[k]);
 			}
 
-			iv_len = crypto_blkcipher_ivsize(tfm);
-			if (iv_len)
-				crypto_blkcipher_set_iv(tfm, cipher_tv[i].iv,
-							iv_len);
+			ablkcipher_request_set_crypt(req, sg, sg,
+						     cipher_tv[i].ilen,
+						     cipher_tv[i].iv);
 
-			len = cipher_tv[i].ilen;
 			ret = enc ?
-				crypto_blkcipher_encrypt(&desc, sg, sg, len) :
-				crypto_blkcipher_decrypt(&desc, sg, sg, len);
+				crypto_ablkcipher_encrypt(req) :
+				crypto_ablkcipher_decrypt(req);
 
-			if (ret) {
-				printk("%s () failed flags=%x\n", e,
-				       desc.flags);
+			switch (ret) {
+			case 0:
+				break;
+			case -EINPROGRESS:
+			case -EBUSY:
+				ret = wait_for_completion_interruptible(
+					&result.completion);
+				if (!ret && !((ret = result.err))) {
+					INIT_COMPLETION(result.completion);
+					break;
+				}
+				/* fall through */
+			default:
+				printk("%s () failed err=%d\n", e, -ret);
 				goto out;
 			}
 
@@ -360,7 +402,8 @@ static void test_cipher(char *algo, int enc,
 	}
 
 out:
-	crypto_free_blkcipher(tfm);
+	crypto_free_ablkcipher(tfm);
+	ablkcipher_request_free(req);
 }
 
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc, char *p,
@@ -832,7 +875,7 @@ static void test_available(void)
 
 	while (*name) {
 		printk("alg %s ", *name);
-		printk(crypto_has_alg(*name, 0, CRYPTO_ALG_ASYNC) ?
+		printk(crypto_has_alg(*name, 0, 0) ?
 		       "found\n" : "not found\n");
 		name++;
 	}
