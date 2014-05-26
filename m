From: Marek Vasut <marex@denx.de>
Subject: [PATCH] crypto: skcipher: Don't use __crypto_dequeue_request()
Date: Mon, 26 May 2014 18:51:48 +0200
Message-ID: <1401123108-31700-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:40400 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaEZQvn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 May 2014 12:51:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use skcipher_givcrypt_cast(crypto_dequeue_request(queue)) instead, which
does the same thing in much cleaner way. The skcipher_givcrypt_cast()
actually uses container_of() instead of messing around with offsetof()
too.

Signed-off-by: Marek Vasut <marex@denx.de>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 include/crypto/internal/skcipher.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

NOTE: I only compile-tested this one.
NOTE: Is there any way we can get rid of __crypto_dequeue_request() for good ?
      I doubt we can, since it's exported symbol and thus part of kernel ABI,
      right?

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 06e8b32..b3a46c5 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -81,8 +81,7 @@ static inline int skcipher_enqueue_givcrypt(
 static inline struct skcipher_givcrypt_request *skcipher_dequeue_givcrypt(
 	struct crypto_queue *queue)
 {
-	return __crypto_dequeue_request(
-		queue, offsetof(struct skcipher_givcrypt_request, creq.base));
+	return skcipher_givcrypt_cast(crypto_dequeue_request(queue));
 }
 
 static inline void *skcipher_givcrypt_reqctx(
-- 
2.0.0.rc0
