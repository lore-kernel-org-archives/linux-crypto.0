From: Marek Vasut <marex@denx.de>
Subject: [PATCH] crypto: Move crypto_yield() to algapi.h
Date: Mon, 26 May 2014 15:32:05 +0200
Message-ID: <1401111125-10286-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:44566 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaEZNb7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 May 2014 09:31:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It makes no sense for crypto_yield() to be defined in scatterwalk.h ,
move it into algapi.h as it's an internal function to crypto API.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/algapi.h      | 6 ++++++
 include/crypto/scatterwalk.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

NOTE: I didn't manage to compile-test it, but logically it should work, since
      scatterwalk.h includes algapi.h .

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 016c2f1..623a59c 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -410,4 +410,10 @@ static inline int crypto_memneq(const void *a, const void *b, size_t size)
 	return __crypto_memneq(a, b, size) != 0UL ? 1 : 0;
 }
 
+static inline void crypto_yield(u32 flags)
+{
+	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		cond_resched();
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 6a626a5..7ef512f 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -25,12 +25,6 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
-static inline void crypto_yield(u32 flags)
-{
-	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
-		cond_resched();
-}
-
 static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 					struct scatterlist *sg2)
 {
-- 
2.0.0.rc0
