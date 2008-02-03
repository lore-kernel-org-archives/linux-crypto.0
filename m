From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [patch 1/3] tcrypt: change the usage of the test vectors.
Date: Sun, 03 Feb 2008 13:55:25 +0100
Message-ID: <20080203130750.038420101@breakoint.cc>
References: <20080203125524.339000971@breakoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34768 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763817AbYBCNRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Feb 2008 08:17:30 -0500
Content-Disposition: inline; filename=0001-crypto-tcrypt-change-the-usage-of-the-test-vector.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The test routines (test_{cipher,hash,aead}) are makeing a copy
of the test template and are processing the encryption process
in place. This patch changes the creation of the copy so it will
work even if the source address of the input data isn't an array
inside of the template but a pointer.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/tcrypt.c |  346 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 181 insertions(+), 165 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6b8315b..92ce78b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -113,23 +113,11 @@ static void test_hash(char *algo, struct hash_testvec *template,
 	char result[64];
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
-	struct hash_testvec *hash_tv;
-	unsigned int tsize;
 	int ret;
+	void *hash_buff;
 
 	printk("\ntesting %s\n", algo);
 
-	tsize = sizeof(struct hash_testvec);
-	tsize *= tcount;
-
-	if (tsize > TVMEMSIZE) {
-		printk("template (%u) too big for tvmem (%u)\n", tsize, TVMEMSIZE);
-		return;
-	}
-
-	memcpy(tvmem, template, tsize);
-	hash_tv = (void *)tvmem;
-
 	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		printk("failed to load transform for %s: %ld\n", algo,
@@ -144,28 +132,36 @@ static void test_hash(char *algo, struct hash_testvec *template,
 		printk("test %u:\n", i + 1);
 		memset(result, 0, 64);
 
-		sg_init_one(&sg[0], hash_tv[i].plaintext, hash_tv[i].psize);
+		hash_buff = kzalloc(template[i].psize, GFP_KERNEL);
+		if (!hash_buff)
+			continue;
 
-		if (hash_tv[i].ksize) {
-			ret = crypto_hash_setkey(tfm, hash_tv[i].key,
-						 hash_tv[i].ksize);
+		memcpy(hash_buff, template[i].plaintext, template[i].psize);
+		sg_init_one(&sg[0], hash_buff, template[i].psize);
+
+		if (template[i].ksize) {
+			ret = crypto_hash_setkey(tfm, template[i].key,
+						 template[i].ksize);
 			if (ret) {
 				printk("setkey() failed ret=%d\n", ret);
+				kfree(hash_buff);
 				goto out;
 			}
 		}
 
-		ret = crypto_hash_digest(&desc, sg, hash_tv[i].psize, result);
+		ret = crypto_hash_digest(&desc, sg, template[i].psize, result);
 		if (ret) {
 			printk("digest () failed ret=%d\n", ret);
+			kfree(hash_buff);
 			goto out;
 		}
 
 		hexdump(result, crypto_hash_digestsize(tfm));
 		printk("%s\n",
-		       memcmp(result, hash_tv[i].digest,
+		       memcmp(result, template[i].digest,
 			      crypto_hash_digestsize(tfm)) ?
 		       "fail" : "pass");
+		kfree(hash_buff);
 	}
 
 	printk("testing %s across pages\n", algo);
@@ -175,25 +171,25 @@ static void test_hash(char *algo, struct hash_testvec *template,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
-		if (hash_tv[i].np) {
+		if (template[i].np) {
 			j++;
 			printk("test %u:\n", j);
 			memset(result, 0, 64);
 
 			temp = 0;
-			sg_init_table(sg, hash_tv[i].np);
-			for (k = 0; k < hash_tv[i].np; k++) {
+			sg_init_table(sg, template[i].np);
+			for (k = 0; k < template[i].np; k++) {
 				memcpy(&xbuf[IDX[k]],
-				       hash_tv[i].plaintext + temp,
-				       hash_tv[i].tap[k]);
-				temp += hash_tv[i].tap[k];
+				       template[i].plaintext + temp,
+				       template[i].tap[k]);
+				temp += template[i].tap[k];
 				sg_set_buf(&sg[k], &xbuf[IDX[k]],
-					    hash_tv[i].tap[k]);
+					    template[i].tap[k]);
 			}
 
-			if (hash_tv[i].ksize) {
-				ret = crypto_hash_setkey(tfm, hash_tv[i].key,
-							 hash_tv[i].ksize);
+			if (template[i].ksize) {
+				ret = crypto_hash_setkey(tfm, template[i].key,
+							 template[i].ksize);
 
 				if (ret) {
 					printk("setkey() failed ret=%d\n", ret);
@@ -201,7 +197,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
 				}
 			}
 
-			ret = crypto_hash_digest(&desc, sg, hash_tv[i].psize,
+			ret = crypto_hash_digest(&desc, sg, template[i].psize,
 						 result);
 			if (ret) {
 				printk("digest () failed ret=%d\n", ret);
@@ -210,7 +206,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
 
 			hexdump(result, crypto_hash_digestsize(tfm));
 			printk("%s\n",
-			       memcmp(result, hash_tv[i].digest,
+			       memcmp(result, template[i].digest,
 				      crypto_hash_digestsize(tfm)) ?
 			       "fail" : "pass");
 		}
@@ -224,17 +220,18 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 		      unsigned int tcount)
 {
 	unsigned int ret, i, j, k, temp;
-	unsigned int tsize;
 	char *q;
 	struct crypto_aead *tfm;
 	char *key;
-	struct aead_testvec *aead_tv;
 	struct aead_request *req;
 	struct scatterlist sg[8];
 	struct scatterlist asg[8];
 	const char *e;
 	struct tcrypt_result result;
 	unsigned int authsize;
+	void *input;
+	void *assoc;
+	char iv[MAX_IVLEN];
 
 	if (enc == ENCRYPT)
 		e = "encryption";
@@ -243,18 +240,6 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 
 	printk(KERN_INFO "\ntesting %s %s\n", algo, e);
 
-	tsize = sizeof(struct aead_testvec);
-	tsize *= tcount;
-
-	if (tsize > TVMEMSIZE) {
-		printk(KERN_INFO "template (%u) too big for tvmem (%u)\n",
-		       tsize, TVMEMSIZE);
-		return;
-	}
-
-	memcpy(tvmem, template, tsize);
-	aead_tv = (void *)tvmem;
-
 	init_completion(&result.completion);
 
 	tfm = crypto_alloc_aead(algo, 0, 0);
@@ -275,46 +260,68 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 				  tcrypt_complete, &result);
 
 	for (i = 0, j = 0; i < tcount; i++) {
-		if (!aead_tv[i].np) {
+		if (!template[i].np) {
 			printk(KERN_INFO "test %u (%d bit key):\n",
-			       ++j, aead_tv[i].klen * 8);
+			       ++j, template[i].klen * 8);
+
+			/* some tepmplates have no input data but they will
+			 * touch input
+			 */
+			input = kzalloc(template[i].ilen + template[i].rlen, GFP_KERNEL);
+			if (!input)
+				continue;
+
+			assoc = kzalloc(template[i].alen, GFP_KERNEL);
+			if (!assoc) {
+				kfree(input);
+				continue;
+			}
 
+			memcpy(input, template[i].input, template[i].ilen);
+			memcpy(assoc, template[i].assoc, template[i].alen);
+			if (template[i].iv)
+				memcpy(iv, template[i].iv, MAX_IVLEN);
+			else
+				memset(iv, 0, MAX_IVLEN);
+			
 			crypto_aead_clear_flags(tfm, ~0);
-			if (aead_tv[i].wk)
+			if (template[i].wk)
 				crypto_aead_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-			key = aead_tv[i].key;
+
+			if (template[i].key)
+				key = template[i].key;
+			else
+				key = kzalloc(template[i].klen, GFP_KERNEL);
 
 			ret = crypto_aead_setkey(tfm, key,
-						 aead_tv[i].klen);
+						 template[i].klen);
 			if (ret) {
 				printk(KERN_INFO "setkey() failed flags=%x\n",
 				       crypto_aead_get_flags(tfm));
 
-				if (!aead_tv[i].fail)
-					goto out;
+				if (!template[i].fail)
+					goto next_one;
 			}
 
-			authsize = abs(aead_tv[i].rlen - aead_tv[i].ilen);
+			authsize = abs(template[i].rlen - template[i].ilen);
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
 				printk(KERN_INFO
 				       "failed to set authsize = %u\n",
 				       authsize);
-				goto out;
+				goto next_one;
 			}
 
-			sg_init_one(&sg[0], aead_tv[i].input,
-				    aead_tv[i].ilen + (enc ? authsize : 0));
+			sg_init_one(&sg[0], input,
+				    template[i].ilen + (enc ? authsize : 0));
 
-			sg_init_one(&asg[0], aead_tv[i].assoc,
-				    aead_tv[i].alen);
+			sg_init_one(&asg[0], assoc, template[i].alen);
 
 			aead_request_set_crypt(req, sg, sg,
-					       aead_tv[i].ilen,
-					       aead_tv[i].iv);
+					       template[i].ilen, iv);
 
-			aead_request_set_assoc(req, asg, aead_tv[i].alen);
+			aead_request_set_assoc(req, asg, template[i].alen);
 
 			ret = enc ?
 				crypto_aead_encrypt(req) :
@@ -335,15 +342,21 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 			default:
 				printk(KERN_INFO "%s () failed err=%d\n",
 				       e, -ret);
-				goto out;
+				goto next_one;
 			}
 
 			q = kmap(sg_page(&sg[0])) + sg[0].offset;
-			hexdump(q, aead_tv[i].rlen);
+			hexdump(q, template[i].rlen);
 
 			printk(KERN_INFO "enc/dec: %s\n",
-			       memcmp(q, aead_tv[i].result,
-				      aead_tv[i].rlen) ? "fail" : "pass");
+			       memcmp(q, template[i].result,
+				      template[i].rlen) ? "fail" : "pass");
+			kunmap(sg_page(&sg[0]));
+next_one:
+			if (!template[i].key)
+				kfree(key);
+			kfree(assoc);
+			kfree(input);
 		}
 	}
 
@@ -352,36 +365,41 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 	memset(axbuf, 0, XBUFSIZE);
 
 	for (i = 0, j = 0; i < tcount; i++) {
-		if (aead_tv[i].np) {
+		if (template[i].np) {
 			printk(KERN_INFO "test %u (%d bit key):\n",
-			       ++j, aead_tv[i].klen * 8);
+			       ++j, template[i].klen * 8);
+
+			if (template[i].iv)
+				memcpy(iv, template[i].iv, MAX_IVLEN);
+			else
+				memset(iv, 0, MAX_IVLEN);
 
 			crypto_aead_clear_flags(tfm, ~0);
-			if (aead_tv[i].wk)
+			if (template[i].wk)
 				crypto_aead_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-			key = aead_tv[i].key;
+			key = template[i].key;
 
-			ret = crypto_aead_setkey(tfm, key, aead_tv[i].klen);
+			ret = crypto_aead_setkey(tfm, key, template[i].klen);
 			if (ret) {
 				printk(KERN_INFO "setkey() failed flags=%x\n",
 				       crypto_aead_get_flags(tfm));
 
-				if (!aead_tv[i].fail)
+				if (!template[i].fail)
 					goto out;
 			}
 
-			sg_init_table(sg, aead_tv[i].np);
-			for (k = 0, temp = 0; k < aead_tv[i].np; k++) {
+			sg_init_table(sg, template[i].np);
+			for (k = 0, temp = 0; k < template[i].np; k++) {
 				memcpy(&xbuf[IDX[k]],
-				       aead_tv[i].input + temp,
-				       aead_tv[i].tap[k]);
-				temp += aead_tv[i].tap[k];
+				       template[i].input + temp,
+				       template[i].tap[k]);
+				temp += template[i].tap[k];
 				sg_set_buf(&sg[k], &xbuf[IDX[k]],
-					   aead_tv[i].tap[k]);
+					   template[i].tap[k]);
 			}
 
-			authsize = abs(aead_tv[i].rlen - aead_tv[i].ilen);
+			authsize = abs(template[i].rlen - template[i].ilen);
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
 				printk(KERN_INFO
@@ -393,21 +411,21 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 			if (enc)
 				sg[k - 1].length += authsize;
 
-			sg_init_table(asg, aead_tv[i].anp);
-			for (k = 0, temp = 0; k < aead_tv[i].anp; k++) {
+			sg_init_table(asg, template[i].anp);
+			for (k = 0, temp = 0; k < template[i].anp; k++) {
 				memcpy(&axbuf[IDX[k]],
-				       aead_tv[i].assoc + temp,
-				       aead_tv[i].atap[k]);
-				temp += aead_tv[i].atap[k];
+				       template[i].assoc + temp,
+				       template[i].atap[k]);
+				temp += template[i].atap[k];
 				sg_set_buf(&asg[k], &axbuf[IDX[k]],
-					   aead_tv[i].atap[k]);
+					   template[i].atap[k]);
 			}
 
 			aead_request_set_crypt(req, sg, sg,
-					       aead_tv[i].ilen,
-					       aead_tv[i].iv);
+					       template[i].ilen,
+					       iv);
 
-			aead_request_set_assoc(req, asg, aead_tv[i].alen);
+			aead_request_set_assoc(req, asg, template[i].alen);
 
 			ret = enc ?
 				crypto_aead_encrypt(req) :
@@ -431,18 +449,19 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 				goto out;
 			}
 
-			for (k = 0, temp = 0; k < aead_tv[i].np; k++) {
+			for (k = 0, temp = 0; k < template[i].np; k++) {
 				printk(KERN_INFO "page %u\n", k);
 				q = kmap(sg_page(&sg[k])) + sg[k].offset;
-				hexdump(q, aead_tv[i].tap[k]);
+				hexdump(q, template[i].tap[k]);
 				printk(KERN_INFO "%s\n",
-				       memcmp(q, aead_tv[i].result + temp,
-					      aead_tv[i].tap[k] -
-					      (k < aead_tv[i].np - 1 || enc ?
+				       memcmp(q, template[i].result + temp,
+					      template[i].tap[k] -
+					      (k < template[i].np - 1 || enc ?
 					       0 : authsize)) ?
 				       "fail" : "pass");
 
-				temp += aead_tv[i].tap[k];
+				temp += template[i].tap[k];
+				kunmap(sg_page(&sg[k]));
 			}
 		}
 	}
@@ -456,15 +475,14 @@ static void test_cipher(char *algo, int enc,
 			struct cipher_testvec *template, unsigned int tcount)
 {
 	unsigned int ret, i, j, k, temp;
-	unsigned int tsize;
 	char *q;
 	struct crypto_ablkcipher *tfm;
-	char *key;
-	struct cipher_testvec *cipher_tv;
 	struct ablkcipher_request *req;
 	struct scatterlist sg[8];
 	const char *e;
 	struct tcrypt_result result;
+	void *data;
+	char iv[MAX_IVLEN];
 
 	if (enc == ENCRYPT)
 	        e = "encryption";
@@ -473,16 +491,7 @@ static void test_cipher(char *algo, int enc,
 
 	printk("\ntesting %s %s\n", algo, e);
 
-	tsize = sizeof (struct cipher_testvec);
-	if (tsize > TVMEMSIZE) {
-		printk("template (%u) too big for tvmem (%u)\n", tsize,
-		       TVMEMSIZE);
-		return;
-	}
-	cipher_tv = (void *)tvmem;
-
 	init_completion(&result.completion);
-
 	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
 
 	if (IS_ERR(tfm)) {
@@ -502,35 +511,43 @@ static void test_cipher(char *algo, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
-		memcpy(cipher_tv, &template[i], tsize);
-		if (!(cipher_tv->np)) {
+
+		data = kzalloc(template[i].ilen, GFP_KERNEL);
+		if (!data)
+			continue;
+
+		memcpy(data, template[i].input, template[i].ilen);
+		if (template[i].iv)
+			memcpy(iv, template[i].iv, MAX_IVLEN);
+		else
+			memset(iv, 0, MAX_IVLEN);
+
+		if (!(template[i].np)) {
 			j++;
 			printk("test %u (%d bit key):\n",
-			j, cipher_tv->klen * 8);
+			j, template[i].klen * 8);
 
 			crypto_ablkcipher_clear_flags(tfm, ~0);
-			if (cipher_tv->wk)
+			if (template[i].wk)
 				crypto_ablkcipher_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-			key = cipher_tv->key;
 
-			ret = crypto_ablkcipher_setkey(tfm, key,
-						       cipher_tv->klen);
+			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
+						       template[i].klen);
 			if (ret) {
 				printk("setkey() failed flags=%x\n",
 				       crypto_ablkcipher_get_flags(tfm));
 
-				if (!cipher_tv->fail)
+				if (!template[i].fail) {
+					kfree(data);
 					goto out;
+				}
 			}
 
-			sg_init_one(&sg[0], cipher_tv->input,
-				    cipher_tv->ilen);
+			sg_init_one(&sg[0], data, template[i].ilen);
 
 			ablkcipher_request_set_crypt(req, sg, sg,
-						     cipher_tv->ilen,
-						     cipher_tv->iv);
-
+						     template[i].ilen, iv);
 			ret = enc ?
 				crypto_ablkcipher_encrypt(req) :
 				crypto_ablkcipher_decrypt(req);
@@ -549,16 +566,19 @@ static void test_cipher(char *algo, int enc,
 				/* fall through */
 			default:
 				printk("%s () failed err=%d\n", e, -ret);
+				kfree(data);
 				goto out;
 			}
 
 			q = kmap(sg_page(&sg[0])) + sg[0].offset;
-			hexdump(q, cipher_tv->rlen);
+			hexdump(q, template[i].rlen);
 
 			printk("%s\n",
-			       memcmp(q, cipher_tv->result,
-				      cipher_tv->rlen) ? "fail" : "pass");
+			       memcmp(q, template[i].result,
+				      template[i].rlen) ? "fail" : "pass");
+			kunmap(sg_page(&sg[0]));
 		}
+		kfree(data);
 	}
 
 	printk("\ntesting %s %s across pages (chunking)\n", algo, e);
@@ -566,42 +586,53 @@ static void test_cipher(char *algo, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
-		memcpy(cipher_tv, &template[i], tsize);
-		if (cipher_tv->np) {
+
+		data = kzalloc(template[i].ilen, GFP_KERNEL);
+		if (!data)
+			continue;
+
+		memcpy(data, template[i].input, template[i].ilen);
+
+		if (template[i].iv)
+			memcpy(iv, template[i].iv, MAX_IVLEN);
+		else
+			memset(iv, 0, MAX_IVLEN);
+
+		if (template[i].np) {
 			j++;
 			printk("test %u (%d bit key):\n",
-			j, cipher_tv->klen * 8);
+			j, template[i].klen * 8);
 
 			crypto_ablkcipher_clear_flags(tfm, ~0);
-			if (cipher_tv->wk)
+			if (template[i].wk)
 				crypto_ablkcipher_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-			key = cipher_tv->key;
 
-			ret = crypto_ablkcipher_setkey(tfm, key,
-						       cipher_tv->klen);
+			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
+						       template[i].klen);
 			if (ret) {
 				printk("setkey() failed flags=%x\n",
-				       crypto_ablkcipher_get_flags(tfm));
+						crypto_ablkcipher_get_flags(tfm));
 
-				if (!cipher_tv->fail)
+				if (!template[i].fail) {
+					kfree(data);
 					goto out;
+				}
 			}
 
 			temp = 0;
-			sg_init_table(sg, cipher_tv->np);
-			for (k = 0; k < cipher_tv->np; k++) {
+			sg_init_table(sg, template[i].np);
+			for (k = 0; k < template[i].np; k++) {
 				memcpy(&xbuf[IDX[k]],
-				       cipher_tv->input + temp,
-				       cipher_tv->tap[k]);
-				temp += cipher_tv->tap[k];
+						template[i].input + temp,
+						template[i].tap[k]);
+				temp += template[i].tap[k];
 				sg_set_buf(&sg[k], &xbuf[IDX[k]],
-					   cipher_tv->tap[k]);
+						template[i].tap[k]);
 			}
 
 			ablkcipher_request_set_crypt(req, sg, sg,
-						     cipher_tv->ilen,
-						     cipher_tv->iv);
+					template[i].ilen, iv);
 
 			ret = enc ?
 				crypto_ablkcipher_encrypt(req) :
@@ -625,19 +656,19 @@ static void test_cipher(char *algo, int enc,
 			}
 
 			temp = 0;
-			for (k = 0; k < cipher_tv->np; k++) {
+			for (k = 0; k < template[i].np; k++) {
 				printk("page %u\n", k);
 				q = kmap(sg_page(&sg[k])) + sg[k].offset;
-				hexdump(q, cipher_tv->tap[k]);
+				hexdump(q, template[i].tap[k]);
 				printk("%s\n",
-					memcmp(q, cipher_tv->result + temp,
-						cipher_tv->tap[k]) ? "fail" :
+					memcmp(q, template[i].result + temp,
+						template[i].tap[k]) ? "fail" :
 					"pass");
-				temp += cipher_tv->tap[k];
+				temp += template[i].tap[k];
+				kunmap(sg_page(&sg[k]));
 			}
 		}
 	}
-
 out:
 	crypto_free_ablkcipher(tfm);
 	ablkcipher_request_free(req);
@@ -1052,22 +1083,10 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
 	struct crypto_comp *tfm;
-	struct comp_testvec *tv;
 	unsigned int tsize;
 
 	printk("\ntesting %s compression\n", algo);
 
-	tsize = sizeof(struct comp_testvec);
-	tsize *= ctcount;
-	if (tsize > TVMEMSIZE) {
-		printk("template (%u) too big for tvmem (%u)\n", tsize,
-		       TVMEMSIZE);
-		return;
-	}
-
-	memcpy(tvmem, ctemplate, tsize);
-	tv = (void *)tvmem;
-
 	tfm = crypto_alloc_comp(algo, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		printk("failed to load transform for %s\n", algo);
@@ -1080,8 +1099,8 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 		printk("test %u:\n", i + 1);
 		memset(result, 0, sizeof (result));
 
-		ilen = tv[i].inlen;
-		ret = crypto_comp_compress(tfm, tv[i].input,
+		ilen = ctemplate[i].inlen;
+		ret = crypto_comp_compress(tfm, ctemplate[i].input,
 		                           ilen, result, &dlen);
 		if (ret) {
 			printk("fail: ret=%d\n", ret);
@@ -1089,7 +1108,7 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 		}
 		hexdump(result, dlen);
 		printk("%s (ratio %d:%d)\n",
-		       memcmp(result, tv[i].output, dlen) ? "fail" : "pass",
+		       memcmp(result, ctemplate[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
 	}
 
@@ -1103,17 +1122,14 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 		goto out;
 	}
 
-	memcpy(tvmem, dtemplate, tsize);
-	tv = (void *)tvmem;
-
 	for (i = 0; i < dtcount; i++) {
 		int ilen, ret, dlen = COMP_BUF_SIZE;
 
 		printk("test %u:\n", i + 1);
 		memset(result, 0, sizeof (result));
 
-		ilen = tv[i].inlen;
-		ret = crypto_comp_decompress(tfm, tv[i].input,
+		ilen = dtemplate[i].inlen;
+		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
 		                             ilen, result, &dlen);
 		if (ret) {
 			printk("fail: ret=%d\n", ret);
@@ -1121,7 +1137,7 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 		}
 		hexdump(result, dlen);
 		printk("%s (ratio %d:%d)\n",
-		       memcmp(result, tv[i].output, dlen) ? "fail" : "pass",
+		       memcmp(result, dtemplate[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
 	}
 out:
-- 
1.5.3.7

-- 
