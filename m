From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: testmgr.c: remove unused function argument
Date: Fri, 8 Aug 2014 12:30:04 +0300
Message-ID: <1407490204-1438-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [207.46.163.210] ([207.46.163.210]:42844 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756005AbaHHJbO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Aug 2014 05:31:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The argument "req" of do_one_async_hash_op is not used by the
function. This patch removes this argument and renames the
function to match more closely its purpose.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ac2b631..ca70ae8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -178,9 +178,7 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 		free_page((unsigned long)buf[i]);
 }
 
-static int do_one_async_hash_op(struct ahash_request *req,
-				struct tcrypt_result *tr,
-				int ret)
+static int wait_async_op(struct tcrypt_result *tr, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
 		ret = wait_for_completion_interruptible(&tr->completion);
@@ -264,30 +262,26 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 		ahash_request_set_crypt(req, sg, result, template[i].psize);
 		if (use_digest) {
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_digest(req));
+			ret = wait_async_op(&tresult, crypto_ahash_digest(req));
 			if (ret) {
 				pr_err("alg: hash: digest failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
 		} else {
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_init(req));
+			ret = wait_async_op(&tresult, crypto_ahash_init(req));
 			if (ret) {
 				pr_err("alt: hash: init failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_update(req));
+			ret = wait_async_op(&tresult, crypto_ahash_update(req));
 			if (ret) {
 				pr_err("alt: hash: update failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_final(req));
+			ret = wait_async_op(&tresult, crypto_ahash_final(req));
 			if (ret) {
 				pr_err("alt: hash: final failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
-- 
1.8.3.1
