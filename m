From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCH] crypto: don't use interruptible wait in tests
Date: Fri,  9 Jan 2015 16:25:28 +0100
Message-ID: <1420817129-28903-1-git-send-email-rabin.vincent@axis.com>
Cc: linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bes.se.axis.com ([195.60.68.10]:48827 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbbAIPZp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2015 10:25:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tcrypt/testmgr uses wait_for_completion_interruptible() everywhere when
it waits for a request to be completed.  If it's interrupted, then the
test is aborted and the request is freed.

However, if any of these calls actually do get interrupted, the result
will likely be a kernel crash, when the driver handles the now-freed
request.  Use wait_for_completion() instead.

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
---
 crypto/tcrypt.c  |   10 ++++------
 crypto/testmgr.c |   50 ++++++++++++++++++++++----------------------------
 2 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1d864e9..0043495 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -764,10 +764,9 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
 		struct tcrypt_result *tr = req->base.data;
 
-		ret = wait_for_completion_interruptible(&tr->completion);
-		if (!ret)
-			ret = tr->err;
+		wait_for_completion(&tr->completion);
 		reinit_completion(&tr->completion);
+		ret = tr->err;
 	}
 	return ret;
 }
@@ -993,10 +992,9 @@ static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
 		struct tcrypt_result *tr = req->base.data;
 
-		ret = wait_for_completion_interruptible(&tr->completion);
-		if (!ret)
-			ret = tr->err;
+		wait_for_completion(&tr->completion);
 		reinit_completion(&tr->completion);
+		ret = tr->err;
 	}
 
 	return ret;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 037368d..235b1ff 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -181,10 +181,9 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 static int wait_async_op(struct tcrypt_result *tr, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
-		ret = wait_for_completion_interruptible(&tr->completion);
-		if (!ret)
-			ret = tr->err;
+		wait_for_completion(&tr->completion);
 		reinit_completion(&tr->completion);
+		ret = tr->err;
 	}
 	return ret;
 }
@@ -353,12 +352,11 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&tresult.completion);
-			if (!ret && !(ret = tresult.err)) {
-				reinit_completion(&tresult.completion);
+			wait_for_completion(&tresult.completion);
+			reinit_completion(&tresult.completion);
+			ret = tresult.err;
+			if (!ret)
 				break;
-			}
 			/* fall through */
 		default:
 			printk(KERN_ERR "alg: hash: digest failed "
@@ -569,12 +567,11 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&result.completion);
-			if (!ret && !(ret = result.err)) {
-				reinit_completion(&result.completion);
+			wait_for_completion(&result.completion);
+			reinit_completion(&result.completion);
+			ret = result.err;
+			if (!ret)
 				break;
-			}
 		case -EBADMSG:
 			if (template[i].novrfy)
 				/* verification failure was expected */
@@ -720,12 +717,11 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&result.completion);
-			if (!ret && !(ret = result.err)) {
-				reinit_completion(&result.completion);
+			wait_for_completion(&result.completion);
+			reinit_completion(&result.completion);
+			ret = result.err;
+			if (!ret)
 				break;
-			}
 		case -EBADMSG:
 			if (template[i].novrfy)
 				/* verification failure was expected */
@@ -1002,12 +998,11 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&result.completion);
-			if (!ret && !((ret = result.err))) {
-				reinit_completion(&result.completion);
+			wait_for_completion(&result.completion);
+			reinit_completion(&result.completion);
+			ret = result.err;
+			if (!ret)
 				break;
-			}
 			/* fall through */
 		default:
 			pr_err("alg: skcipher%s: %s failed on test %d for %s: ret=%d\n",
@@ -1097,12 +1092,11 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-					&result.completion);
-			if (!ret && !((ret = result.err))) {
-				reinit_completion(&result.completion);
+			wait_for_completion(&result.completion);
+			reinit_completion(&result.completion);
+			ret = result.err;
+			if (!ret)
 				break;
-			}
 			/* fall through */
 		default:
 			pr_err("alg: skcipher%s: %s failed on chunk test %d for %s: ret=%d\n",
-- 
1.7.10.4
