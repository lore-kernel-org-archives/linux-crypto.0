From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 1/3] crypto: testmgr.c: white space removal on __test_hash
Date: Fri, 8 Aug 2014 14:27:50 +0300
Message-ID: <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
References: <53E496E4.9070207@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:43980
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756008AbaHHL2e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Aug 2014 07:28:34 -0400
In-Reply-To: <53E496E4.9070207@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch inverts one if condition to remove code block indentation.
Several white space clean-ups follow.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 123 +++++++++++++++++++++++++++----------------------------
 1 file changed, 60 insertions(+), 63 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ca70ae8..51f47f2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -305,78 +305,75 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		if (align_offset != 0)
 			break;
 
-		if (template[i].np) {
-			j++;
-			memset(result, 0, MAX_DIGEST_SIZE);
+		if (!template[i].np)
+			continue;
 
-			temp = 0;
-			sg_init_table(sg, template[i].np);
-			ret = -EINVAL;
-			for (k = 0; k < template[i].np; k++) {
-				if (WARN_ON(offset_in_page(IDX[k]) +
-					    template[i].tap[k] > PAGE_SIZE))
-					goto out;
-				sg_set_buf(&sg[k],
-					   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
-						  offset_in_page(IDX[k]),
-						  template[i].plaintext + temp,
-						  template[i].tap[k]),
-					   template[i].tap[k]);
-				temp += template[i].tap[k];
-			}
+		j++;
+		memset(result, 0, MAX_DIGEST_SIZE);
 
-			if (template[i].ksize) {
-				if (template[i].ksize > MAX_KEYLEN) {
-					pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
-					       j, algo, template[i].ksize,
-					       MAX_KEYLEN);
-					ret = -EINVAL;
-					goto out;
-				}
-				crypto_ahash_clear_flags(tfm, ~0);
-				memcpy(key, template[i].key, template[i].ksize);
-				ret = crypto_ahash_setkey(tfm, key,
-							  template[i].ksize);
+		temp = 0;
+		sg_init_table(sg, template[i].np);
+		ret = -EINVAL;
+		for (k = 0; k < template[i].np; k++) {
+			if (WARN_ON(offset_in_page(IDX[k]) +
+				    template[i].tap[k] > PAGE_SIZE))
+				goto out;
+			sg_set_buf(&sg[k],
+				   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
+					  offset_in_page(IDX[k]),
+					  template[i].plaintext + temp,
+					  template[i].tap[k]),
+				   template[i].tap[k]);
+			temp += template[i].tap[k];
+		}
 
-				if (ret) {
-					printk(KERN_ERR "alg: hash: setkey "
-					       "failed on chunking test %d "
-					       "for %s: ret=%d\n", j, algo,
-					       -ret);
-					goto out;
-				}
+		if (template[i].ksize) {
+			if (template[i].ksize > MAX_KEYLEN) {
+				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
+				       j, algo, template[i].ksize, MAX_KEYLEN);
+				ret = -EINVAL;
+				goto out;
 			}
+			crypto_ahash_clear_flags(tfm, ~0);
+			memcpy(key, template[i].key, template[i].ksize);
+			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
 
-			ahash_request_set_crypt(req, sg, result,
-						template[i].psize);
-			ret = crypto_ahash_digest(req);
-			switch (ret) {
-			case 0:
-				break;
-			case -EINPROGRESS:
-			case -EBUSY:
-				ret = wait_for_completion_interruptible(
-					&tresult.completion);
-				if (!ret && !(ret = tresult.err)) {
-					reinit_completion(&tresult.completion);
-					break;
-				}
-				/* fall through */
-			default:
-				printk(KERN_ERR "alg: hash: digest failed "
-				       "on chunking test %d for %s: "
-				       "ret=%d\n", j, algo, -ret);
+			if (ret) {
+				printk(KERN_ERR "alg: hash: setkey "
+				       "failed on chunking test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
+		}
 
-			if (memcmp(result, template[i].digest,
-				   crypto_ahash_digestsize(tfm))) {
-				printk(KERN_ERR "alg: hash: Chunking test %d "
-				       "failed for %s\n", j, algo);
-				hexdump(result, crypto_ahash_digestsize(tfm));
-				ret = -EINVAL;
-				goto out;
+		ahash_request_set_crypt(req, sg, result, template[i].psize);
+		ret = crypto_ahash_digest(req);
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&tresult.completion);
+			if (!ret && !(ret = tresult.err)) {
+				reinit_completion(&tresult.completion);
+				break;
 			}
+			/* fall through */
+		default:
+			printk(KERN_ERR "alg: hash: digest failed "
+			       "on chunking test %d for %s: "
+			       "ret=%d\n", j, algo, -ret);
+			goto out;
+		}
+
+		if (memcmp(result, template[i].digest,
+			   crypto_ahash_digestsize(tfm))) {
+			printk(KERN_ERR "alg: hash: Chunking test %d "
+			       "failed for %s\n", j, algo);
+			hexdump(result, crypto_ahash_digestsize(tfm));
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
-- 
1.8.3.1
