From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/4] crypto: testmgr: add hash finup tests
Date: Thu, 28 Jun 2018 08:32:52 +0100
Message-ID: <1530171175-31960-3-git-send-email-gilad@benyossef.com>
References: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The testmgr hash tests were testing init, digest, update and final
methods but not the finup method. Add a test for this one too.

While doing this, make sure we only run the partial tests once with
the digest tests and skip them with the final and finup tests since
they are the same.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 11e4535..ca475f6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -259,9 +259,15 @@ static int ahash_partial_update(struct ahash_request **preq,
 	return ret;
 }
 
+enum hash_test {
+	HASH_TEST_DIGEST,
+	HASH_TEST_FINAL,
+	HASH_TEST_FINUP
+};
+
 static int __test_hash(struct crypto_ahash *tfm,
 		       const struct hash_testvec *template, unsigned int tcount,
-		       bool use_digest, const int align_offset)
+		       enum hash_test test_type, const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 	size_t digest_size = crypto_ahash_digestsize(tfm);
@@ -332,14 +338,17 @@ static int __test_hash(struct crypto_ahash *tfm,
 		}
 
 		ahash_request_set_crypt(req, sg, result, template[i].psize);
-		if (use_digest) {
+		switch (test_type) {
+		case HASH_TEST_DIGEST:
 			ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
 			if (ret) {
 				pr_err("alg: hash: digest failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
-		} else {
+			break;
+
+		case HASH_TEST_FINAL:
 			memset(result, 1, digest_size);
 			ret = crypto_wait_req(crypto_ahash_init(req), &wait);
 			if (ret) {
@@ -371,6 +380,29 @@ static int __test_hash(struct crypto_ahash *tfm,
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
+			break;
+
+		case HASH_TEST_FINUP:
+			memset(result, 1, digest_size);
+			ret = crypto_wait_req(crypto_ahash_init(req), &wait);
+			if (ret) {
+				pr_err("alg: hash: init failed on test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
+				goto out;
+			}
+			ret = ahash_guard_result(result, 1, digest_size);
+			if (ret) {
+				pr_err("alg: hash: init failed on test %d "
+				       "for %s: used req->result\n", j, algo);
+				goto out;
+			}
+			ret = crypto_wait_req(crypto_ahash_finup(req), &wait);
+			if (ret) {
+				pr_err("alg: hash: final failed on test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
+				goto out;
+			}
+			break;
 		}
 
 		if (memcmp(result, template[i].digest,
@@ -383,6 +415,9 @@ static int __test_hash(struct crypto_ahash *tfm,
 		}
 	}
 
+	if (test_type)
+		goto out;
+
 	j = 0;
 	for (i = 0; i < tcount; i++) {
 		/* alignment tests are only done with continuous buffers */
@@ -540,24 +575,24 @@ static int __test_hash(struct crypto_ahash *tfm,
 
 static int test_hash(struct crypto_ahash *tfm,
 		     const struct hash_testvec *template,
-		     unsigned int tcount, bool use_digest)
+		     unsigned int tcount, enum hash_test test_type)
 {
 	unsigned int alignmask;
 	int ret;
 
-	ret = __test_hash(tfm, template, tcount, use_digest, 0);
+	ret = __test_hash(tfm, template, tcount, test_type, 0);
 	if (ret)
 		return ret;
 
 	/* test unaligned buffers, check with one byte offset */
-	ret = __test_hash(tfm, template, tcount, use_digest, 1);
+	ret = __test_hash(tfm, template, tcount, test_type, 1);
 	if (ret)
 		return ret;
 
 	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
 	if (alignmask) {
 		/* Check if alignment mask for tfm is correctly set. */
-		ret = __test_hash(tfm, template, tcount, use_digest,
+		ret = __test_hash(tfm, template, tcount, test_type,
 				  alignmask + 1);
 		if (ret)
 			return ret;
@@ -1803,9 +1838,11 @@ static int __alg_test_hash(const struct hash_testvec *template,
 		return PTR_ERR(tfm);
 	}
 
-	err = test_hash(tfm, template, tcount, true);
+	err = test_hash(tfm, template, tcount, HASH_TEST_DIGEST);
+	if (!err)
+		err = test_hash(tfm, template, tcount, HASH_TEST_FINAL);
 	if (!err)
-		err = test_hash(tfm, template, tcount, false);
+		err = test_hash(tfm, template, tcount, HASH_TEST_FINUP);
 	crypto_free_ahash(tfm);
 	return err;
 }
-- 
2.7.4
