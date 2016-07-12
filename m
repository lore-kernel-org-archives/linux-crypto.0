From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 23/30] crypto: api - Optimise away crypto_yield when hard preemption is on
Date: Tue, 12 Jul 2016 13:17:56 +0800
Message-ID: <E1bMq4y-0007U5-5U@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57715 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbcGLFR6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4y-0004gX-9y
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When hard preemption is enabled there is no need to explicitly
call crypto_yield.  This patch eliminates it if that is the case.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/algapi.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 0483f65..8637cdf 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -442,8 +442,10 @@ static inline int crypto_memneq(const void *a, const void *b, size_t size)
 
 static inline void crypto_yield(u32 flags)
 {
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_VOLUNTARY)
 	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
 		cond_resched();
+#endif
 }
 
 #endif	/* _CRYPTO_ALGAPI_H */
