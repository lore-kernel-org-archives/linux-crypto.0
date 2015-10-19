From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: api - Only abort operations on fatal signal
Date: Mon, 19 Oct 2015 18:23:57 +0800
Message-ID: <20151019102357.GA6810@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42592 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbbJSKYB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 06:24:01 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently a number of Crypto API operations may fail when a signal
occurs.  This causes nasty problems as the caller of those operations
are often not in a good position to restart the operation.

In fact there is currently no need for those operations to be
interrupted by user signals at all.  All we need is for them to
be killable.

This patch replaces the relevant calls of signal_pending with
fatal_signal_pending, and wait_for_completion_interruptible with
wait_for_completion_killable, respectively.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index b788f16..b4ffc5b 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -706,7 +706,7 @@ struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
 err:
 		if (err != -EAGAIN)
 			break;
-		if (signal_pending(current)) {
+		if (fatal_signal_pending(current)) {
 			err = -EINTR;
 			break;
 		}
diff --git a/crypto/algapi.c b/crypto/algapi.c
index d130b41..59bf491 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -345,7 +345,7 @@ static void crypto_wait_for_test(struct crypto_larval *larval)
 		crypto_alg_tested(larval->alg.cra_driver_name, 0);
 	}
 
-	err = wait_for_completion_interruptible(&larval->completion);
+	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
 
 out:
diff --git a/crypto/api.c b/crypto/api.c
index afe4610..bbc147c 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -172,7 +172,7 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	struct crypto_larval *larval = (void *)alg;
 	long timeout;
 
-	timeout = wait_for_completion_interruptible_timeout(
+	timeout = wait_for_completion_killable_timeout(
 		&larval->completion, 60 * HZ);
 
 	alg = larval->adult;
@@ -445,7 +445,7 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 err:
 		if (err != -EAGAIN)
 			break;
-		if (signal_pending(current)) {
+		if (fatal_signal_pending(current)) {
 			err = -EINTR;
 			break;
 		}
@@ -562,7 +562,7 @@ void *crypto_alloc_tfm(const char *alg_name,
 err:
 		if (err != -EAGAIN)
 			break;
-		if (signal_pending(current)) {
+		if (fatal_signal_pending(current)) {
 			err = -EINTR;
 			break;
 		}
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index d94d99f..237f379 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -375,7 +375,7 @@ static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32 type,
 		err = PTR_ERR(alg);
 		if (err != -EAGAIN)
 			break;
-		if (signal_pending(current)) {
+		if (fatal_signal_pending(current)) {
 			err = -EINTR;
 			break;
 		}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
