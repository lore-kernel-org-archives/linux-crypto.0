From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 01/10] crypto: testmgr - avoid DMA mapping from text, rodata, stack
Date: Wed, 23 Jul 2014 11:59:38 +0300
Message-ID: <1406105978-16279-1-git-send-email-horia.geanta@freescale.com>
References: <1405082095-30146-2-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:25381
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756428AbaGWJAj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 05:00:39 -0400
In-Reply-To: <1405082095-30146-2-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With DMA_API_DEBUG set, following warnings are emitted
(tested on CAAM accelerator):
DMA-API: device driver maps memory from kernel text or rodata
DMA-API: device driver maps memory from stack
and the culprits are:
-key in __test_aead and __test_hash
-result in __test_hash

MAX_KEYLEN is changed to accommodate maximum key length from
existing test vectors in crypto/testmgr.h (131 bytes) and rounded.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
v2: Addressed Kim's comments.

 crypto/testmgr.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 crypto/testmgr.h |  2 +-
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f90612a00b9..81818b9a1b83 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -198,13 +198,20 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 	unsigned int i, j, k, temp;
 	struct scatterlist sg[8];
-	char result[64];
+	char *result;
+	char *key;
 	struct ahash_request *req;
 	struct tcrypt_result tresult;
 	void *hash_buff;
 	char *xbuf[XBUFSIZE];
 	int ret = -ENOMEM;
 
+	result = kmalloc(MAX_DIGEST_SIZE, GFP_KERNEL);
+	if (!result)
+		return ret;
+	key = kmalloc(MAX_KEYLEN, GFP_KERNEL);
+	if (!key)
+		goto out_nobuf;
 	if (testmgr_alloc_buf(xbuf))
 		goto out_nobuf;
 
@@ -229,7 +236,7 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 			goto out;
 
 		j++;
-		memset(result, 0, 64);
+		memset(result, 0, MAX_DIGEST_SIZE);
 
 		hash_buff = xbuf[0];
 		hash_buff += align_offset;
@@ -239,8 +246,14 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 		if (template[i].ksize) {
 			crypto_ahash_clear_flags(tfm, ~0);
-			ret = crypto_ahash_setkey(tfm, template[i].key,
-						  template[i].ksize);
+			if (template[i].ksize > MAX_KEYLEN) {
+				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
+				       j, algo, template[i].ksize, MAX_KEYLEN);
+				ret = -EINVAL;
+				goto out;
+			}
+			memcpy(key, template[i].key, template[i].ksize);
+			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
 			if (ret) {
 				printk(KERN_ERR "alg: hash: setkey failed on "
 				       "test %d for %s: ret=%d\n", j, algo,
@@ -300,7 +313,7 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 		if (template[i].np) {
 			j++;
-			memset(result, 0, 64);
+			memset(result, 0, MAX_DIGEST_SIZE);
 
 			temp = 0;
 			sg_init_table(sg, template[i].np);
@@ -319,8 +332,16 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 			}
 
 			if (template[i].ksize) {
+				if (template[i].ksize > MAX_KEYLEN) {
+					pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
+					       j, algo, template[i].ksize,
+					       MAX_KEYLEN);
+					ret = -EINVAL;
+					goto out;
+				}
 				crypto_ahash_clear_flags(tfm, ~0);
-				ret = crypto_ahash_setkey(tfm, template[i].key,
+				memcpy(key, template[i].key, template[i].ksize);
+				ret = crypto_ahash_setkey(tfm, key,
 							  template[i].ksize);
 
 				if (ret) {
@@ -372,6 +393,8 @@ out:
 out_noreq:
 	testmgr_free_buf(xbuf);
 out_nobuf:
+	kfree(key);
+	kfree(result);
 	return ret;
 }
 
@@ -429,6 +452,9 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
 	if (!iv)
 		return ret;
+	key = kmalloc(MAX_KEYLEN, GFP_KERNEL);
+	if (!key)
+		goto out_noxbuf;
 	if (testmgr_alloc_buf(xbuf))
 		goto out_noxbuf;
 	if (testmgr_alloc_buf(axbuf))
@@ -493,7 +519,14 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				crypto_aead_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			key = template[i].key;
+			if (template[i].klen > MAX_KEYLEN) {
+				pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
+				       d, j, algo, template[i].klen,
+				       MAX_KEYLEN);
+				ret = -EINVAL;
+				goto out;
+			}
+			memcpy(key, template[i].key, template[i].klen);
 
 			ret = crypto_aead_setkey(tfm, key,
 						 template[i].klen);
@@ -594,7 +627,14 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 			if (template[i].wk)
 				crypto_aead_set_flags(
 					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-			key = template[i].key;
+			if (template[i].klen > MAX_KEYLEN) {
+				pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
+				       d, j, algo, template[i].klen,
+				       MAX_KEYLEN);
+				ret = -EINVAL;
+				goto out;
+			}
+			memcpy(key, template[i].key, template[i].klen);
 
 			ret = crypto_aead_setkey(tfm, key, template[i].klen);
 			if (!ret == template[i].fail) {
@@ -776,6 +816,7 @@ out_nooutbuf:
 out_noaxbuf:
 	testmgr_free_buf(xbuf);
 out_noxbuf:
+	kfree(key);
 	kfree(iv);
 	return ret;
 }
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4bb607189b8d..46df9e88bbf3 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -32,7 +32,7 @@
 #define MAX_DIGEST_SIZE		64
 #define MAX_TAP			8
 
-#define MAX_KEYLEN		56
+#define MAX_KEYLEN		160
 #define MAX_IVLEN		32
 
 struct hash_testvec {
-- 
1.8.3.1
