From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] crypto: testmgr - make test_aead also test 'dst != src'
 code paths
Date: Fri, 21 Sep 2012 10:26:52 +0300
Message-ID: <20120921072652.11790.31387.stgit@localhost6.localdomain6>
References: <20120921072647.11790.19493.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43948 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2IUH0z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2012 03:26:55 -0400
In-Reply-To: <20120921072647.11790.19493.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currrently test_aead uses same buffer for destination and source. However
in any places, 'dst != src' take different path than 'dst == src' case.

Therefore make test_aead also run tests with destination buffer being
different than source buffer.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.c |  153 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 105 insertions(+), 48 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 00f54d5..941d75c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -358,8 +358,9 @@ out_nobuf:
 	return ret;
 }
 
-static int test_aead(struct crypto_aead *tfm, int enc,
-		     struct aead_testvec *template, unsigned int tcount)
+static int __test_aead(struct crypto_aead *tfm, int enc,
+		       struct aead_testvec *template, unsigned int tcount,
+		       const bool diff_dst)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
 	unsigned int i, j, k, n, temp;
@@ -367,15 +368,18 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 	char *q;
 	char *key;
 	struct aead_request *req;
-	struct scatterlist sg[8];
-	struct scatterlist asg[8];
-	const char *e;
+	struct scatterlist *sg;
+	struct scatterlist *asg;
+	struct scatterlist *sgout;
+	const char *e, *d;
 	struct tcrypt_result result;
 	unsigned int authsize;
 	void *input;
+	void *output;
 	void *assoc;
 	char iv[MAX_IVLEN];
 	char *xbuf[XBUFSIZE];
+	char *xoutbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
 
 	if (testmgr_alloc_buf(xbuf))
@@ -383,6 +387,21 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 	if (testmgr_alloc_buf(axbuf))
 		goto out_noaxbuf;
 
+	if (diff_dst && testmgr_alloc_buf(xoutbuf))
+		goto out_nooutbuf;
+
+	/* avoid "the frame size is larger than 1024 bytes" compiler warning */
+	sg = kmalloc(sizeof(*sg) * 8 * (diff_dst ? 3 : 2), GFP_KERNEL);
+	if (!sg)
+		goto out_nosg;
+	asg = &sg[8];
+	sgout = &asg[8];
+
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
 	if (enc == ENCRYPT)
 		e = "encryption";
 	else
@@ -392,8 +411,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		printk(KERN_ERR "alg: aead: Failed to allocate request for "
-		       "%s\n", algo);
+		pr_err("alg: aead%s: Failed to allocate request for %s\n",
+		       d, algo);
 		goto out;
 	}
 
@@ -432,9 +451,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			ret = crypto_aead_setkey(tfm, key,
 						 template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: aead: setkey failed on "
-				       "test %d for %s: flags=%x\n", j, algo,
-				       crypto_aead_get_flags(tfm));
+				pr_err("alg: aead%s: setkey failed on test %d for %s: flags=%x\n",
+				       d, j, algo, crypto_aead_get_flags(tfm));
 				goto out;
 			} else if (ret)
 				continue;
@@ -442,18 +460,26 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			authsize = abs(template[i].rlen - template[i].ilen);
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
-				printk(KERN_ERR "alg: aead: Failed to set "
-				       "authsize to %u on test %d for %s\n",
-				       authsize, j, algo);
+				pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
+				       d, authsize, j, algo);
 				goto out;
 			}
 
 			sg_init_one(&sg[0], input,
 				    template[i].ilen + (enc ? authsize : 0));
 
+			if (diff_dst) {
+				output = xoutbuf[0];
+				sg_init_one(&sgout[0], output,
+					    template[i].ilen +
+						(enc ? authsize : 0));
+			} else {
+				output = input;
+			}
+
 			sg_init_one(&asg[0], assoc, template[i].alen);
 
-			aead_request_set_crypt(req, sg, sg,
+			aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
 					       template[i].ilen, iv);
 
 			aead_request_set_assoc(req, asg, template[i].alen);
@@ -466,10 +492,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			case 0:
 				if (template[i].novrfy) {
 					/* verification was supposed to fail */
-					printk(KERN_ERR "alg: aead: %s failed "
-					       "on test %d for %s: ret was 0, "
-					       "expected -EBADMSG\n",
-					       e, j, algo);
+					pr_err("alg: aead%s: %s failed on test %d for %s: ret was 0, expected -EBADMSG\n",
+					       d, e, j, algo);
 					/* so really, we got a bad message */
 					ret = -EBADMSG;
 					goto out;
@@ -489,15 +513,15 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					continue;
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: aead: %s failed on test "
-				       "%d for %s: ret=%d\n", e, j, algo, -ret);
+				pr_err("alg: aead%s: %s failed on test %d for %s: ret=%d\n",
+				       d, e, j, algo, -ret);
 				goto out;
 			}
 
-			q = input;
+			q = output;
 			if (memcmp(q, template[i].result, template[i].rlen)) {
-				printk(KERN_ERR "alg: aead: Test %d failed on "
-				       "%s for %s\n", j, e, algo);
+				pr_err("alg: aead%s: Test %d failed on %s for %s\n",
+				       d, j, e, algo);
 				hexdump(q, template[i].rlen);
 				ret = -EINVAL;
 				goto out;
@@ -522,9 +546,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			ret = crypto_aead_setkey(tfm, key, template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: aead: setkey failed on "
-				       "chunk test %d for %s: flags=%x\n", j,
-				       algo, crypto_aead_get_flags(tfm));
+				pr_err("alg: aead%s: setkey failed on chunk test %d for %s: flags=%x\n",
+				       d, j, algo, crypto_aead_get_flags(tfm));
 				goto out;
 			} else if (ret)
 				continue;
@@ -533,6 +556,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			ret = -EINVAL;
 			sg_init_table(sg, template[i].np);
+			if (diff_dst)
+				sg_init_table(sgout, template[i].np);
 			for (k = 0, temp = 0; k < template[i].np; k++) {
 				if (WARN_ON(offset_in_page(IDX[k]) +
 					    template[i].tap[k] > PAGE_SIZE))
@@ -551,14 +576,26 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					q[n] = 0;
 
 				sg_set_buf(&sg[k], q, template[i].tap[k]);
+
+				if (diff_dst) {
+					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+					    offset_in_page(IDX[k]);
+
+					memset(q, 0, template[i].tap[k]);
+					if (offset_in_page(q) + n < PAGE_SIZE)
+						q[n] = 0;
+
+					sg_set_buf(&sgout[k], q,
+						   template[i].tap[k]);
+				}
+
 				temp += template[i].tap[k];
 			}
 
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
-				printk(KERN_ERR "alg: aead: Failed to set "
-				       "authsize to %u on chunk test %d for "
-				       "%s\n", authsize, j, algo);
+				pr_err("alg: aead%s: Failed to set authsize to %u on chunk test %d for %s\n",
+				       d, authsize, j, algo);
 				goto out;
 			}
 
@@ -571,6 +608,9 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 				}
 
 				sg[k - 1].length += authsize;
+
+				if (diff_dst)
+					sgout[k - 1].length += authsize;
 			}
 
 			sg_init_table(asg, template[i].anp);
@@ -588,7 +628,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 				temp += template[i].atap[k];
 			}
 
-			aead_request_set_crypt(req, sg, sg,
+			aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
 					       template[i].ilen,
 					       iv);
 
@@ -602,10 +642,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			case 0:
 				if (template[i].novrfy) {
 					/* verification was supposed to fail */
-					printk(KERN_ERR "alg: aead: %s failed "
-					       "on chunk test %d for %s: ret "
-					       "was 0, expected -EBADMSG\n",
-					       e, j, algo);
+					pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret was 0, expected -EBADMSG\n",
+					       d, e, j, algo);
 					/* so really, we got a bad message */
 					ret = -EBADMSG;
 					goto out;
@@ -625,32 +663,35 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					continue;
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: aead: %s failed on "
-				       "chunk test %d for %s: ret=%d\n", e, j,
-				       algo, -ret);
+				pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret=%d\n",
+				       d, e, j, algo, -ret);
 				goto out;
 			}
 
 			ret = -EINVAL;
 			for (k = 0, temp = 0; k < template[i].np; k++) {
-				q = xbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
+				if (diff_dst)
+					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+					    offset_in_page(IDX[k]);
+				else
+					q = xbuf[IDX[k] >> PAGE_SHIFT] +
+					    offset_in_page(IDX[k]);
 
 				n = template[i].tap[k];
 				if (k == template[i].np - 1)
 					n += enc ? authsize : -authsize;
 
 				if (memcmp(q, template[i].result + temp, n)) {
-					printk(KERN_ERR "alg: aead: Chunk "
-					       "test %d failed on %s at page "
-					       "%u for %s\n", j, e, k, algo);
+					pr_err("alg: aead%s: Chunk test %d failed on %s at page %u for %s\n",
+					       d, j, e, k, algo);
 					hexdump(q, n);
 					goto out;
 				}
 
 				q += n;
 				if (k == template[i].np - 1 && !enc) {
-					if (memcmp(q, template[i].input +
+					if (!diff_dst &&
+						memcmp(q, template[i].input +
 						      temp + n, authsize))
 						n = authsize;
 					else
@@ -661,11 +702,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 						;
 				}
 				if (n) {
-					printk(KERN_ERR "alg: aead: Result "
-					       "buffer corruption in chunk "
-					       "test %d on %s at page %u for "
-					       "%s: %u bytes:\n", j, e, k,
-					       algo, n);
+					pr_err("alg: aead%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
+					       d, j, e, k, algo, n);
 					hexdump(q, n);
 					goto out;
 				}
@@ -679,6 +717,11 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 out:
 	aead_request_free(req);
+	kfree(sg);
+out_nosg:
+	if (diff_dst)
+		testmgr_free_buf(xoutbuf);
+out_nooutbuf:
 	testmgr_free_buf(axbuf);
 out_noaxbuf:
 	testmgr_free_buf(xbuf);
@@ -686,6 +729,20 @@ out_noxbuf:
 	return ret;
 }
 
+static int test_aead(struct crypto_aead *tfm, int enc,
+		     struct aead_testvec *template, unsigned int tcount)
+{
+	int ret;
+
+	/* test 'dst == src' case */
+	ret = __test_aead(tfm, enc, template, tcount, false);
+	if (ret)
+		return ret;
+
+	/* test 'dst != src' case */
+	return __test_aead(tfm, enc, template, tcount, true);
+}
+
 static int test_cipher(struct crypto_cipher *tfm, int enc,
 		       struct cipher_testvec *template, unsigned int tcount)
 {
