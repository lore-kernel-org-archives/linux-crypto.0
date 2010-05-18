From: David Miller <davem@davemloft.net>
Subject: [PATCH 4/6] crypto: Add testing for async hashing and update/final.
Date: Mon, 17 May 2010 22:22:46 -0700 (PDT)
Message-ID: <20100517.222246.220069902.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50954
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab0ERFWh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 01:22:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Extend testmgr such that it tests async hash algorithms,
and that for both sync and async hashes it tests both
->digest() and ->update()/->final() sequences.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 crypto/testmgr.c |   66 +++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c494d76..5c8aaa0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -153,8 +153,21 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 		free_page((unsigned long)buf[i]);
 }
 
+static int do_one_async_hash_op(struct ahash_request *req,
+				struct tcrypt_result *tr,
+				int ret)
+{
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		ret = wait_for_completion_interruptible(&tr->completion);
+		if (!ret)
+			ret = tr->err;
+		INIT_COMPLETION(tr->completion);
+	}
+	return ret;
+}
+
 static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
-		     unsigned int tcount)
+		     unsigned int tcount, bool use_digest)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 	unsigned int i, j, k, temp;
@@ -206,23 +219,36 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		}
 
 		ahash_request_set_crypt(req, sg, result, template[i].psize);
-		ret = crypto_ahash_digest(req);
-		switch (ret) {
-		case 0:
-			break;
-		case -EINPROGRESS:
-		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&tresult.completion);
-			if (!ret && !(ret = tresult.err)) {
-				INIT_COMPLETION(tresult.completion);
-				break;
+		if (use_digest) {
+			ret = do_one_async_hash_op(req, &tresult,
+						   crypto_ahash_digest(req));
+			if (ret) {
+				pr_err("alg: hash: digest failed on test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
+				goto out;
+			}
+		} else {
+			ret = do_one_async_hash_op(req, &tresult,
+						   crypto_ahash_init(req));
+			if (ret) {
+				pr_err("alt: hash: init failed on test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
+				goto out;
+			}
+			ret = do_one_async_hash_op(req, &tresult,
+						   crypto_ahash_update(req));
+			if (ret) {
+				pr_err("alt: hash: update failed on test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
+				goto out;
+			}
+			ret = do_one_async_hash_op(req, &tresult,
+						   crypto_ahash_final(req));
+			if (ret) {
+				pr_err("alt: hash: final failed on test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
+				goto out;
 			}
-			/* fall through */
-		default:
-			printk(KERN_ERR "alg: hash: digest failed on test %d "
-			       "for %s: ret=%d\n", j, algo, -ret);
-			goto out;
 		}
 
 		if (memcmp(result, template[i].digest,
@@ -1402,7 +1428,11 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 		return PTR_ERR(tfm);
 	}
 
-	err = test_hash(tfm, desc->suite.hash.vecs, desc->suite.hash.count);
+	err = test_hash(tfm, desc->suite.hash.vecs,
+			desc->suite.hash.count, true);
+	if (!err)
+		err = test_hash(tfm, desc->suite.hash.vecs,
+				desc->suite.hash.count, false);
 
 	crypto_free_ahash(tfm);
 	return err;
-- 
1.7.0.4
