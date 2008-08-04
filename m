From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/5] crypto: tcrypt - Avoid using contiguous pages
Date: Mon, 04 Aug 2008 15:02:36 +0800
Message-ID: <E1KPu5U-0002AS-00@gondolin.me.apana.org.au>
References: <20080804065958.GA8264@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44855 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932072AbYHDHCk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 03:02:40 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KPu5U-0001oj-OA
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 17:02:37 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: tcrypt - Avoid using contiguous pages

If tcrypt is to be used as a run-time integrity test, it needs to be
more resilient in a hostile environment.  For a start allocating 32K
of physically contiguous memory is definitely out.

This patch teaches it to use separate pages instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |  304 +++++++++++++++++++++++++++-----------------------------
 crypto/tcrypt.h |    8 +
 2 files changed, 157 insertions(+), 155 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6636802..2aa1aee 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -31,10 +31,10 @@
 #include "tcrypt.h"
 
 /*
- * Need to kmalloc() memory for testing.
+ * Need slab memory for testing (size in number of pages).
  */
-#define TVMEMSIZE	16384
-#define XBUFSIZE	32768
+#define TVMEMSIZE	4
+#define XBUFSIZE	8
 
 /*
  * Indexes into the xbuf to simulate cross-page access.
@@ -67,9 +67,9 @@ static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 static unsigned int sec;
 
 static int mode;
-static char *xbuf;
-static char *axbuf;
-static char *tvmem;
+static char *xbuf[XBUFSIZE];
+static char *axbuf[XBUFSIZE];
+static char *tvmem[TVMEMSIZE];
 
 static char *check[] = {
 	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256",
@@ -133,9 +133,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
 		printk("test %u:\n", i + 1);
 		memset(result, 0, 64);
 
-		hash_buff = kzalloc(template[i].psize, GFP_KERNEL);
-		if (!hash_buff)
-			continue;
+		hash_buff = xbuf[0];
 
 		memcpy(hash_buff, template[i].plaintext, template[i].psize);
 		sg_init_one(&sg[0], hash_buff, template[i].psize);
@@ -146,7 +144,6 @@ static void test_hash(char *algo, struct hash_testvec *template,
 						  template[i].ksize);
 			if (ret) {
 				printk("setkey() failed ret=%d\n", ret);
-				kfree(hash_buff);
 				goto out;
 			}
 		}
@@ -167,7 +164,6 @@ static void test_hash(char *algo, struct hash_testvec *template,
 			/* fall through */
 		default:
 			printk("digest () failed ret=%d\n", ret);
-			kfree(hash_buff);
 			goto out;
 		}
 
@@ -176,14 +172,10 @@ static void test_hash(char *algo, struct hash_testvec *template,
 		       memcmp(result, template[i].digest,
 			      crypto_ahash_digestsize(tfm)) ?
 		       "fail" : "pass");
-		kfree(hash_buff);
 	}
 
 	printk("testing %s across pages\n", algo);
 
-	/* setup the dummy buffer first */
-	memset(xbuf, 0, XBUFSIZE);
-
 	j = 0;
 	for (i = 0; i < tcount; i++) {
 		if (template[i].np) {
@@ -194,12 +186,13 @@ static void test_hash(char *algo, struct hash_testvec *template,
 			temp = 0;
 			sg_init_table(sg, template[i].np);
 			for (k = 0; k < template[i].np; k++) {
-				memcpy(&xbuf[IDX[k]],
-				       template[i].plaintext + temp,
-				       template[i].tap[k]);
+				sg_set_buf(&sg[k],
+					   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
+						  offset_in_page(IDX[k]),
+						  template[i].plaintext + temp,
+						  template[i].tap[k]),
+					   template[i].tap[k]);
 				temp += template[i].tap[k];
-				sg_set_buf(&sg[k], &xbuf[IDX[k]],
-					    template[i].tap[k]);
 			}
 
 			if (template[i].ksize) {
@@ -298,15 +291,8 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 			/* some tepmplates have no input data but they will
 			 * touch input
 			 */
-			input = kzalloc(template[i].ilen + template[i].rlen, GFP_KERNEL);
-			if (!input)
-				continue;
-
-			assoc = kzalloc(template[i].alen, GFP_KERNEL);
-			if (!assoc) {
-				kfree(input);
-				continue;
-			}
+			input = xbuf[0];
+			assoc = axbuf[0];
 
 			memcpy(input, template[i].input, template[i].ilen);
 			memcpy(assoc, template[i].assoc, template[i].alen);
@@ -320,10 +306,7 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 				crypto_aead_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			if (template[i].key)
-				key = template[i].key;
-			else
-				key = kzalloc(template[i].klen, GFP_KERNEL);
+			key = template[i].key;
 
 			ret = crypto_aead_setkey(tfm, key,
 						 template[i].klen);
@@ -332,7 +315,7 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 				       crypto_aead_get_flags(tfm));
 
 				if (!template[i].fail)
-					goto next_one;
+					continue;
 			}
 
 			authsize = abs(template[i].rlen - template[i].ilen);
@@ -341,7 +324,7 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 				printk(KERN_INFO
 				       "failed to set authsize = %u\n",
 				       authsize);
-				goto next_one;
+				continue;
 			}
 
 			sg_init_one(&sg[0], input,
@@ -373,7 +356,7 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 			default:
 				printk(KERN_INFO "%s () failed err=%d\n",
 				       e, -ret);
-				goto next_one;
+				continue;
 			}
 
 			q = input;
@@ -382,16 +365,10 @@ static void test_aead(char *algo, int enc, struct aead_testvec *template,
 			printk(KERN_INFO "enc/dec: %s\n",
 			       memcmp(q, template[i].result,
 				      template[i].rlen) ? "fail" : "pass");
-next_one:
-			if (!template[i].key)
-				kfree(key);
-			kfree(assoc);
-			kfree(input);
 		}
 	}
 
 	printk(KERN_INFO "\ntesting %s %s across pages (chunking)\n", algo, e);
-	memset(axbuf, 0, XBUFSIZE);
 
 	for (i = 0, j = 0; i < tcount; i++) {
 		if (template[i].np) {
@@ -418,18 +395,30 @@ next_one:
 					goto out;
 			}
 
-			memset(xbuf, 0, XBUFSIZE);
+			authsize = abs(template[i].rlen - template[i].ilen);
+
 			sg_init_table(sg, template[i].np);
 			for (k = 0, temp = 0; k < template[i].np; k++) {
-				memcpy(&xbuf[IDX[k]],
-				       template[i].input + temp,
+				if (WARN_ON(offset_in_page(IDX[k]) + 
+					    template[i].tap[k] > PAGE_SIZE))
+					goto out;
+
+				q = xbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
+
+				memcpy(q, template[i].input + temp,
 				       template[i].tap[k]);
+
+				n = template[i].tap[k];
+				if (k == template[i].np - 1 && enc)
+					n += authsize;
+				if (offset_in_page(q) + n < PAGE_SIZE)
+					q[n] = 0;
+
+				sg_set_buf(&sg[k], q, template[i].tap[k]);
 				temp += template[i].tap[k];
-				sg_set_buf(&sg[k], &xbuf[IDX[k]],
-					   template[i].tap[k]);
 			}
 
-			authsize = abs(template[i].rlen - template[i].ilen);
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
 				printk(KERN_INFO
@@ -438,17 +427,24 @@ next_one:
 				goto out;
 			}
 
-			if (enc)
+			if (enc) {
+				if (WARN_ON(sg[k - 1].offset +
+					    sg[k - 1].length + authsize >
+					    PAGE_SIZE))
+					goto out;
+
 				sg[k - 1].length += authsize;
+			}
 
 			sg_init_table(asg, template[i].anp);
 			for (k = 0, temp = 0; k < template[i].anp; k++) {
-				memcpy(&axbuf[IDX[k]],
-				       template[i].assoc + temp,
-				       template[i].atap[k]);
-				temp += template[i].atap[k];
-				sg_set_buf(&asg[k], &axbuf[IDX[k]],
+				sg_set_buf(&asg[k],
+					   memcpy(axbuf[IDX[k] >> PAGE_SHIFT] +
+						  offset_in_page(IDX[k]),
+						  template[i].assoc + temp,
+						  template[i].atap[k]),
 					   template[i].atap[k]);
+				temp += template[i].atap[k];
 			}
 
 			aead_request_set_crypt(req, sg, sg,
@@ -481,7 +477,8 @@ next_one:
 
 			for (k = 0, temp = 0; k < template[i].np; k++) {
 				printk(KERN_INFO "page %u\n", k);
-				q = &xbuf[IDX[k]];
+				q = xbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
 
 				n = template[i].tap[k];
 				if (k == template[i].np - 1)
@@ -499,7 +496,8 @@ next_one:
 					else
 						n = 0;
 				} else {
-					for (n = 0; q[n]; n++)
+					for (n = 0; offset_in_page(q + n) &&
+						    q[n]; n++)
 						;
 				}
 				if (n) {
@@ -558,12 +556,6 @@ static void test_cipher(char *algo, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
-
-		data = kzalloc(template[i].ilen, GFP_KERNEL);
-		if (!data)
-			continue;
-
-		memcpy(data, template[i].input, template[i].ilen);
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
 		else
@@ -574,6 +566,9 @@ static void test_cipher(char *algo, int enc,
 			printk("test %u (%d bit key):\n",
 			j, template[i].klen * 8);
 
+			data = xbuf[0];
+			memcpy(data, template[i].input, template[i].ilen);
+
 			crypto_ablkcipher_clear_flags(tfm, ~0);
 			if (template[i].wk)
 				crypto_ablkcipher_set_flags(
@@ -585,10 +580,8 @@ static void test_cipher(char *algo, int enc,
 				printk("setkey() failed flags=%x\n",
 				       crypto_ablkcipher_get_flags(tfm));
 
-				if (!template[i].fail) {
-					kfree(data);
+				if (!template[i].fail)
 					goto out;
-				}
 			}
 
 			sg_init_one(&sg[0], data, template[i].ilen);
@@ -613,7 +606,6 @@ static void test_cipher(char *algo, int enc,
 				/* fall through */
 			default:
 				printk("%s () failed err=%d\n", e, -ret);
-				kfree(data);
 				goto out;
 			}
 
@@ -624,7 +616,6 @@ static void test_cipher(char *algo, int enc,
 			       memcmp(q, template[i].result,
 				      template[i].rlen) ? "fail" : "pass");
 		}
-		kfree(data);
 	}
 
 	printk("\ntesting %s %s across pages (chunking)\n", algo, e);
@@ -642,7 +633,6 @@ static void test_cipher(char *algo, int enc,
 			printk("test %u (%d bit key):\n",
 			j, template[i].klen * 8);
 
-			memset(xbuf, 0, XBUFSIZE);
 			crypto_ablkcipher_clear_flags(tfm, ~0);
 			if (template[i].wk)
 				crypto_ablkcipher_set_flags(
@@ -661,12 +651,23 @@ static void test_cipher(char *algo, int enc,
 			temp = 0;
 			sg_init_table(sg, template[i].np);
 			for (k = 0; k < template[i].np; k++) {
-				memcpy(&xbuf[IDX[k]],
-						template[i].input + temp,
-						template[i].tap[k]);
+				if (WARN_ON(offset_in_page(IDX[k]) + 
+					    template[i].tap[k] > PAGE_SIZE))
+					goto out;
+
+				q = xbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
+
+				memcpy(q, template[i].input + temp,
+				       template[i].tap[k]);
+
+				if (offset_in_page(q) + template[i].tap[k] <
+				    PAGE_SIZE)
+					q[template[i].tap[k]] = 0;
+
+				sg_set_buf(&sg[k], q, template[i].tap[k]);
+
 				temp += template[i].tap[k];
-				sg_set_buf(&sg[k], &xbuf[IDX[k]],
-						template[i].tap[k]);
 			}
 
 			ablkcipher_request_set_crypt(req, sg, sg,
@@ -696,19 +697,21 @@ static void test_cipher(char *algo, int enc,
 			temp = 0;
 			for (k = 0; k < template[i].np; k++) {
 				printk("page %u\n", k);
-				q = &xbuf[IDX[k]];
+				q = xbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
 				hexdump(q, template[i].tap[k]);
 				printk("%s\n",
 					memcmp(q, template[i].result + temp,
 						template[i].tap[k]) ? "fail" :
 					"pass");
 
-				for (n = 0; q[template[i].tap[k] + n]; n++)
+				q += template[i].tap[k];
+				for (n = 0; offset_in_page(q + n) && q[n]; n++)
 					;
 				if (n) {
 					printk("Result buffer corruption %u "
 					       "bytes:\n", n);
-					hexdump(&q[template[i].tap[k]], n);
+					hexdump(q, n);
 				}
 				temp += template[i].tap[k];
 			}
@@ -719,16 +722,13 @@ out:
 	ablkcipher_request_free(req);
 }
 
-static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc, char *p,
-			       int blen, int sec)
+static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
+			       struct scatterlist *sg, int blen, int sec)
 {
-	struct scatterlist sg[1];
 	unsigned long start, end;
 	int bcount;
 	int ret;
 
-	sg_init_one(sg, p, blen);
-
 	for (start = jiffies, end = start + sec * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
 		if (enc)
@@ -745,16 +745,13 @@ static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc, char *p,
 	return 0;
 }
 
-static int test_cipher_cycles(struct blkcipher_desc *desc, int enc, char *p,
-			      int blen)
+static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
+			      struct scatterlist *sg, int blen)
 {
-	struct scatterlist sg[1];
 	unsigned long cycles = 0;
 	int ret = 0;
 	int i;
 
-	sg_init_one(sg, p, blen);
-
 	local_bh_disable();
 	local_irq_disable();
 
@@ -804,7 +801,7 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 			      unsigned int tcount, u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
-	unsigned char *key, *p, iv[128];
+	unsigned char *key, iv[128];
 	struct crypto_blkcipher *tfm;
 	struct blkcipher_desc desc;
 	const char *e;
@@ -832,27 +829,28 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 
 		b_size = block_sizes;
 		do {
+			struct scatterlist sg[TVMEMSIZE];
 
-			if ((*keysize + *b_size) > TVMEMSIZE) {
-				printk("template (%u) too big for tvmem (%u)\n",
-						*keysize + *b_size, TVMEMSIZE);
+			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+				printk("template (%u) too big for "
+				       "tvmem (%lu)\n", *keysize + *b_size,
+				       TVMEMSIZE * PAGE_SIZE);
 				goto out;
 			}
 
 			printk("test %u (%d bit key, %d byte blocks): ", i,
 					*keysize * 8, *b_size);
 
-			memset(tvmem, 0xff, *keysize + *b_size);
+			memset(tvmem[0], 0xff, PAGE_SIZE);
 
 			/* set key, plain text and IV */
-			key = (unsigned char *)tvmem;
+			key = (unsigned char *)tvmem[0];
 			for (j = 0; j < tcount; j++) {
 				if (template[j].klen == *keysize) {
 					key = template[j].key;
 					break;
 				}
 			}
-			p = (unsigned char *)tvmem + *keysize;
 
 			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
 			if (ret) {
@@ -861,6 +859,14 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 				goto out;
 			}
 
+			sg_init_table(sg, TVMEMSIZE);
+			sg_set_buf(sg, tvmem[0] + *keysize,
+				   PAGE_SIZE - *keysize);
+			for (j = 1; j < TVMEMSIZE; j++) {
+				sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
+				memset (tvmem[j], 0xff, PAGE_SIZE);
+			}
+
 			iv_len = crypto_blkcipher_ivsize(tfm);
 			if (iv_len) {
 				memset(&iv, 0xff, iv_len);
@@ -868,9 +874,11 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 			}
 
 			if (sec)
-				ret = test_cipher_jiffies(&desc, enc, p, *b_size, sec);
+				ret = test_cipher_jiffies(&desc, enc, sg,
+							  *b_size, sec);
 			else
-				ret = test_cipher_cycles(&desc, enc, p, *b_size);
+				ret = test_cipher_cycles(&desc, enc, sg,
+							 *b_size);
 
 			if (ret) {
 				printk("%s() failed flags=%x\n", e, desc.flags);
@@ -886,19 +894,16 @@ out:
 	crypto_free_blkcipher(tfm);
 }
 
-static int test_hash_jiffies_digest(struct hash_desc *desc, char *p, int blen,
+static int test_hash_jiffies_digest(struct hash_desc *desc,
+				    struct scatterlist *sg, int blen,
 				    char *out, int sec)
 {
-	struct scatterlist sg[1];
 	unsigned long start, end;
 	int bcount;
 	int ret;
 
-	sg_init_table(sg, 1);
-
 	for (start = jiffies, end = start + sec * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		sg_set_buf(sg, p, blen);
 		ret = crypto_hash_digest(desc, sg, blen, out);
 		if (ret)
 			return ret;
@@ -910,18 +915,15 @@ static int test_hash_jiffies_digest(struct hash_desc *desc, char *p, int blen,
 	return 0;
 }
 
-static int test_hash_jiffies(struct hash_desc *desc, char *p, int blen,
-			     int plen, char *out, int sec)
+static int test_hash_jiffies(struct hash_desc *desc, struct scatterlist *sg,
+			     int blen, int plen, char *out, int sec)
 {
-	struct scatterlist sg[1];
 	unsigned long start, end;
 	int bcount, pcount;
 	int ret;
 
 	if (plen == blen)
-		return test_hash_jiffies_digest(desc, p, blen, out, sec);
-
-	sg_init_table(sg, 1);
+		return test_hash_jiffies_digest(desc, sg, blen, out, sec);
 
 	for (start = jiffies, end = start + sec * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
@@ -929,7 +931,6 @@ static int test_hash_jiffies(struct hash_desc *desc, char *p, int blen,
 		if (ret)
 			return ret;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-			sg_set_buf(sg, p + pcount, plen);
 			ret = crypto_hash_update(desc, sg, plen);
 			if (ret)
 				return ret;
@@ -946,22 +947,18 @@ static int test_hash_jiffies(struct hash_desc *desc, char *p, int blen,
 	return 0;
 }
 
-static int test_hash_cycles_digest(struct hash_desc *desc, char *p, int blen,
-				   char *out)
+static int test_hash_cycles_digest(struct hash_desc *desc,
+				   struct scatterlist *sg, int blen, char *out)
 {
-	struct scatterlist sg[1];
 	unsigned long cycles = 0;
 	int i;
 	int ret;
 
-	sg_init_table(sg, 1);
-
 	local_bh_disable();
 	local_irq_disable();
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		sg_set_buf(sg, p, blen);
 		ret = crypto_hash_digest(desc, sg, blen, out);
 		if (ret)
 			goto out;
@@ -973,7 +970,6 @@ static int test_hash_cycles_digest(struct hash_desc *desc, char *p, int blen,
 
 		start = get_cycles();
 
-		sg_set_buf(sg, p, blen);
 		ret = crypto_hash_digest(desc, sg, blen, out);
 		if (ret)
 			goto out;
@@ -996,18 +992,15 @@ out:
 	return 0;
 }
 
-static int test_hash_cycles(struct hash_desc *desc, char *p, int blen,
-			    int plen, char *out)
+static int test_hash_cycles(struct hash_desc *desc, struct scatterlist *sg,
+			    int blen, int plen, char *out)
 {
-	struct scatterlist sg[1];
 	unsigned long cycles = 0;
 	int i, pcount;
 	int ret;
 
 	if (plen == blen)
-		return test_hash_cycles_digest(desc, p, blen, out);
-
-	sg_init_table(sg, 1);
+		return test_hash_cycles_digest(desc, sg, blen, out);
 
 	local_bh_disable();
 	local_irq_disable();
@@ -1018,7 +1011,6 @@ static int test_hash_cycles(struct hash_desc *desc, char *p, int blen,
 		if (ret)
 			goto out;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-			sg_set_buf(sg, p + pcount, plen);
 			ret = crypto_hash_update(desc, sg, plen);
 			if (ret)
 				goto out;
@@ -1038,7 +1030,6 @@ static int test_hash_cycles(struct hash_desc *desc, char *p, int blen,
 		if (ret)
 			goto out;
 		for (pcount = 0; pcount < blen; pcount += plen) {
-			sg_set_buf(sg, p + pcount, plen);
 			ret = crypto_hash_update(desc, sg, plen);
 			if (ret)
 				goto out;
@@ -1068,6 +1059,7 @@ out:
 static void test_hash_speed(char *algo, unsigned int sec,
 			      struct hash_speed *speed)
 {
+	struct scatterlist sg[TVMEMSIZE];
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
 	char output[1024];
@@ -1093,23 +1085,27 @@ static void test_hash_speed(char *algo, unsigned int sec,
 		goto out;
 	}
 
+	sg_init_table(sg, TVMEMSIZE);
+	for (i = 0; i < TVMEMSIZE; i++) {
+		sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
+		memset(tvmem[i], 0xff, PAGE_SIZE);
+	}
+
 	for (i = 0; speed[i].blen != 0; i++) {
-		if (speed[i].blen > TVMEMSIZE) {
-			printk("template (%u) too big for tvmem (%u)\n",
-			       speed[i].blen, TVMEMSIZE);
+		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
+			printk("template (%u) too big for tvmem (%lu)\n",
+			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
 			goto out;
 		}
 
 		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
 		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
 
-		memset(tvmem, 0xff, speed[i].blen);
-
 		if (sec)
-			ret = test_hash_jiffies(&desc, tvmem, speed[i].blen,
+			ret = test_hash_jiffies(&desc, sg, speed[i].blen,
 						speed[i].plen, output, sec);
 		else
-			ret = test_hash_cycles(&desc, tvmem, speed[i].blen,
+			ret = test_hash_cycles(&desc, sg, speed[i].blen,
 					       speed[i].plen, output);
 
 		if (ret) {
@@ -1128,7 +1124,6 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
 	struct crypto_comp *tfm;
-	unsigned int tsize;
 
 	printk("\ntesting %s compression\n", algo);
 
@@ -1159,14 +1154,6 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 
 	printk("\ntesting %s decompression\n", algo);
 
-	tsize = sizeof(struct comp_testvec);
-	tsize *= dtcount;
-	if (tsize > TVMEMSIZE) {
-		printk("template (%u) too big for tvmem (%u)\n", tsize,
-		       TVMEMSIZE);
-		goto out;
-	}
-
 	for (i = 0; i < dtcount; i++) {
 		int ilen, ret, dlen = COMP_BUF_SIZE;
 
@@ -1185,7 +1172,7 @@ static void test_comp(char *algo, struct comp_testvec *ctemplate,
 		       memcmp(result, dtemplate[i].output, dlen) ? "fail" : "pass",
 		       ilen, dlen);
 	}
-out:
+
 	crypto_free_comp(tfm);
 }
 
@@ -1917,18 +1904,25 @@ static void do_test(void)
 static int __init tcrypt_mod_init(void)
 {
 	int err = -ENOMEM;
+	int i;
 
-	tvmem = kmalloc(TVMEMSIZE, GFP_KERNEL);
-	if (tvmem == NULL)
-		return err;
+	for (i = 0; i < TVMEMSIZE; i++) {
+		tvmem[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!tvmem[i])
+			goto err_free_tv;
+	}
 
-	xbuf = kmalloc(XBUFSIZE, GFP_KERNEL);
-	if (xbuf == NULL)
-		goto err_free_tv;
+	for (i = 0; i < XBUFSIZE; i++) {
+		xbuf[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!xbuf[i])
+			goto err_free_xbuf;
+	}
 
-	axbuf = kmalloc(XBUFSIZE, GFP_KERNEL);
-	if (axbuf == NULL)
-		goto err_free_xbuf;
+	for (i = 0; i < XBUFSIZE; i++) {
+		axbuf[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!axbuf[i])
+			goto err_free_axbuf;
+	}
 
 	do_test();
 
@@ -1940,11 +1934,15 @@ static int __init tcrypt_mod_init(void)
 	 */
 	err = -EAGAIN;
 
-	kfree(axbuf);
- err_free_xbuf:
-	kfree(xbuf);
- err_free_tv:
-	kfree(tvmem);
+err_free_axbuf:
+	for (i = 0; i < XBUFSIZE && axbuf[i]; i++)
+		free_page((unsigned long)axbuf[i]);
+err_free_xbuf:
+	for (i = 0; i < XBUFSIZE && xbuf[i]; i++)
+		free_page((unsigned long)xbuf[i]);
+err_free_tv:
+	for (i = 0; i < TVMEMSIZE && tvmem[i]; i++)
+		free_page((unsigned long)tvmem[i]);
 
 	return err;
 }
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 801e0c2..c6254a1 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -39,7 +39,7 @@ struct cipher_testvec {
 	char *iv;
 	char *input;
 	char *result;
-	unsigned char tap[MAX_TAP];
+	unsigned short tap[MAX_TAP];
 	int np;
 	unsigned char fail;
 	unsigned char wk; /* weak key flag */
@@ -5111,6 +5111,8 @@ static struct cipher_testvec aes_ctr_enc_tv_template[] = {
 			"\x4b\xef\x31\x18\xea\xac\xb1\x84"
 			"\x21\xed\xda\x86",
 		.rlen = 4100,
+		.np	= 2,
+		.tap	= { 4064, 36 },
 	},
 };
 
@@ -8126,7 +8128,9 @@ static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
 			"\xfc\x3f\x09\x7a\x0b\xdc\xc5\x1b"
 			"\x87\x13\xc6\x5b\x59\x8d\xf2\xc8"
 			"\xaf\xdf\x11\x95",
-		.rlen = 4100,
+		.rlen	= 4100,
+		.np	= 2,
+		.tap	= { 4064, 36 },
 	},
 };
 
