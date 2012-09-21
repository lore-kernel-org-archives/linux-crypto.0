From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] crypto: testmgr - make test_skcipher also test 'dst !=
 src' code paths
Date: Fri, 21 Sep 2012 10:26:47 +0300
Message-ID: <20120921072647.11790.19493.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:41367 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2IUH0v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2012 03:26:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currrently test_skcipher uses same buffer for destination and source. However
in any places, 'dst != src' take different path than 'dst == src' case.

Therefore make test_skcipher also run tests with destination buffer being
different than source buffer.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.c |  107 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 31 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8183777..00f54d5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -761,8 +761,9 @@ out_nobuf:
 	return ret;
 }
 
-static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
-			 struct cipher_testvec *template, unsigned int tcount)
+static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
+			   struct cipher_testvec *template, unsigned int tcount,
+			   const bool diff_dst)
 {
 	const char *algo =
 		crypto_tfm_alg_driver_name(crypto_ablkcipher_tfm(tfm));
@@ -770,16 +771,26 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 	char *q;
 	struct ablkcipher_request *req;
 	struct scatterlist sg[8];
-	const char *e;
+	struct scatterlist sgout[8];
+	const char *e, *d;
 	struct tcrypt_result result;
 	void *data;
 	char iv[MAX_IVLEN];
 	char *xbuf[XBUFSIZE];
+	char *xoutbuf[XBUFSIZE];
 	int ret = -ENOMEM;
 
 	if (testmgr_alloc_buf(xbuf))
 		goto out_nobuf;
 
+	if (diff_dst && testmgr_alloc_buf(xoutbuf))
+		goto out_nooutbuf;
+
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
 	if (enc == ENCRYPT)
 	        e = "encryption";
 	else
@@ -789,8 +800,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		printk(KERN_ERR "alg: skcipher: Failed to allocate request "
-		       "for %s\n", algo);
+		pr_err("alg: skcipher%s: Failed to allocate request for %s\n",
+		       d, algo);
 		goto out;
 	}
 
@@ -822,16 +833,21 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: skcipher: setkey failed "
-				       "on test %d for %s: flags=%x\n", j,
-				       algo, crypto_ablkcipher_get_flags(tfm));
+				pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
+				       d, j, algo,
+				       crypto_ablkcipher_get_flags(tfm));
 				goto out;
 			} else if (ret)
 				continue;
 
 			sg_init_one(&sg[0], data, template[i].ilen);
+			if (diff_dst) {
+				data = xoutbuf[0];
+				sg_init_one(&sgout[0], data, template[i].ilen);
+			}
 
-			ablkcipher_request_set_crypt(req, sg, sg,
+			ablkcipher_request_set_crypt(req, sg,
+						     (diff_dst) ? sgout : sg,
 						     template[i].ilen, iv);
 			ret = enc ?
 				crypto_ablkcipher_encrypt(req) :
@@ -850,16 +866,15 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: skcipher: %s failed on "
-				       "test %d for %s: ret=%d\n", e, j, algo,
-				       -ret);
+				pr_err("alg: skcipher%s: %s failed on test %d for %s: ret=%d\n",
+				       d, e, j, algo, -ret);
 				goto out;
 			}
 
 			q = data;
 			if (memcmp(q, template[i].result, template[i].rlen)) {
-				printk(KERN_ERR "alg: skcipher: Test %d "
-				       "failed on %s for %s\n", j, e, algo);
+				pr_err("alg: skcipher%s: Test %d failed on %s for %s\n",
+				       d, j, e, algo);
 				hexdump(q, template[i].rlen);
 				ret = -EINVAL;
 				goto out;
@@ -886,9 +901,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: skcipher: setkey failed "
-				       "on chunk test %d for %s: flags=%x\n",
-				       j, algo,
+				pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
+				       d, j, algo,
 				       crypto_ablkcipher_get_flags(tfm));
 				goto out;
 			} else if (ret)
@@ -897,6 +911,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			temp = 0;
 			ret = -EINVAL;
 			sg_init_table(sg, template[i].np);
+			if (diff_dst)
+				sg_init_table(sgout, template[i].np);
 			for (k = 0; k < template[i].np; k++) {
 				if (WARN_ON(offset_in_page(IDX[k]) +
 					    template[i].tap[k] > PAGE_SIZE))
@@ -913,11 +929,24 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 					q[template[i].tap[k]] = 0;
 
 				sg_set_buf(&sg[k], q, template[i].tap[k]);
+				if (diff_dst) {
+					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+					    offset_in_page(IDX[k]);
+
+					sg_set_buf(&sgout[k], q,
+						   template[i].tap[k]);
+
+					memset(q, 0, template[i].tap[k]);
+					if (offset_in_page(q) +
+					    template[i].tap[k] < PAGE_SIZE)
+						q[template[i].tap[k]] = 0;
+				}
 
 				temp += template[i].tap[k];
 			}
 
-			ablkcipher_request_set_crypt(req, sg, sg,
+			ablkcipher_request_set_crypt(req, sg,
+					(diff_dst) ? sgout : sg,
 					template[i].ilen, iv);
 
 			ret = enc ?
@@ -937,23 +966,25 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: skcipher: %s failed on "
-				       "chunk test %d for %s: ret=%d\n", e, j,
-				       algo, -ret);
+				pr_err("alg: skcipher%s: %s failed on chunk test %d for %s: ret=%d\n",
+				       d, e, j, algo, -ret);
 				goto out;
 			}
 
 			temp = 0;
 			ret = -EINVAL;
 			for (k = 0; k < template[i].np; k++) {
-				q = xbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
+				if (diff_dst)
+					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+					    offset_in_page(IDX[k]);
+				else
+					q = xbuf[IDX[k] >> PAGE_SHIFT] +
+					    offset_in_page(IDX[k]);
 
 				if (memcmp(q, template[i].result + temp,
 					   template[i].tap[k])) {
-					printk(KERN_ERR "alg: skcipher: Chunk "
-					       "test %d failed on %s at page "
-					       "%u for %s\n", j, e, k, algo);
+					pr_err("alg: skcipher%s: Chunk test %d failed on %s at page %u for %s\n",
+					       d, j, e, k, algo);
 					hexdump(q, template[i].tap[k]);
 					goto out;
 				}
@@ -962,11 +993,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				for (n = 0; offset_in_page(q + n) && q[n]; n++)
 					;
 				if (n) {
-					printk(KERN_ERR "alg: skcipher: "
-					       "Result buffer corruption in "
-					       "chunk test %d on %s at page "
-					       "%u for %s: %u bytes:\n", j, e,
-					       k, algo, n);
+					pr_err("alg: skcipher%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
+					       d, j, e, k, algo, n);
 					hexdump(q, n);
 					goto out;
 				}
@@ -979,11 +1007,28 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 out:
 	ablkcipher_request_free(req);
+	if (diff_dst)
+		testmgr_free_buf(xoutbuf);
+out_nooutbuf:
 	testmgr_free_buf(xbuf);
 out_nobuf:
 	return ret;
 }
 
+static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
+			 struct cipher_testvec *template, unsigned int tcount)
+{
+	int ret;
+
+	/* test 'dst == src' case */
+	ret = __test_skcipher(tfm, enc, template, tcount, false);
+	if (ret)
+		return ret;
+
+	/* test 'dst != src' case */
+	return __test_skcipher(tfm, enc, template, tcount, true);
+}
+
 static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		     struct comp_testvec *dtemplate, int ctcount, int dtcount)
 {
