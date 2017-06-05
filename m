From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: testmgr: use consistent format for errors
Date: Mon,  5 Jun 2017 08:33:43 +0300
Message-ID: <1496640823-30421-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:57458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdFEFdw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Jun 2017 01:33:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix inconsistent format and spelling in hash tests error messages.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6f5f3ed..8c68c99 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -218,14 +218,14 @@ static int ahash_partial_update(struct ahash_request **preq,
 			crypto_ahash_reqtfm(req));
 	state = kmalloc(statesize + sizeof(guard), GFP_KERNEL);
 	if (!state) {
-		pr_err("alt: hash: Failed to alloc state for %s\n", algo);
+		pr_err("alg: hash: Failed to alloc state for %s\n", algo);
 		goto out_nostate;
 	}
 	memcpy(state + statesize, guard, sizeof(guard));
 	ret = crypto_ahash_export(req, state);
 	WARN_ON(memcmp(state + statesize, guard, sizeof(guard)));
 	if (ret) {
-		pr_err("alt: hash: Failed to export() for %s\n", algo);
+		pr_err("alg: hash: Failed to export() for %s\n", algo);
 		goto out;
 	}
 	ahash_request_free(req);
@@ -344,19 +344,19 @@ static int __test_hash(struct crypto_ahash *tfm,
 		} else {
 			ret = wait_async_op(&tresult, crypto_ahash_init(req));
 			if (ret) {
-				pr_err("alt: hash: init failed on test %d "
+				pr_err("alg: hash: init failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
 			ret = wait_async_op(&tresult, crypto_ahash_update(req));
 			if (ret) {
-				pr_err("alt: hash: update failed on test %d "
+				pr_err("alg: hash: update failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
 			ret = wait_async_op(&tresult, crypto_ahash_final(req));
 			if (ret) {
-				pr_err("alt: hash: final failed on test %d "
+				pr_err("alg: hash: final failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
@@ -488,13 +488,13 @@ static int __test_hash(struct crypto_ahash *tfm,
 		ahash_request_set_crypt(req, sg, result, template[i].tap[0]);
 		ret = wait_async_op(&tresult, crypto_ahash_init(req));
 		if (ret) {
-			pr_err("alt: hash: init failed on test %d for %s: ret=%d\n",
+			pr_err("alg: hash: init failed on test %d for %s: ret=%d\n",
 				j, algo, -ret);
 			goto out;
 		}
 		ret = wait_async_op(&tresult, crypto_ahash_update(req));
 		if (ret) {
-			pr_err("alt: hash: update failed on test %d for %s: ret=%d\n",
+			pr_err("alg: hash: update failed on test %d for %s: ret=%d\n",
 				j, algo, -ret);
 			goto out;
 		}
@@ -505,7 +505,7 @@ static int __test_hash(struct crypto_ahash *tfm,
 				hash_buff, k, temp, &sg[0], algo, result,
 				&tresult);
 			if (ret) {
-				pr_err("hash: partial update failed on test %d for %s: ret=%d\n",
+				pr_err("alg: hash: partial update failed on test %d for %s: ret=%d\n",
 					j, algo, -ret);
 				goto out_noreq;
 			}
@@ -513,7 +513,7 @@ static int __test_hash(struct crypto_ahash *tfm,
 		}
 		ret = wait_async_op(&tresult, crypto_ahash_final(req));
 		if (ret) {
-			pr_err("alt: hash: final failed on test %d for %s: ret=%d\n",
+			pr_err("alg: hash: final failed on test %d for %s: ret=%d\n",
 				j, algo, -ret);
 			goto out;
 		}
-- 
2.1.4
