From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/16] crypto: shash - Add crypto_shash_ctx_aligned
Date: Thu, 09 Jul 2009 12:53:55 +0800
Message-ID: <E1MOldr-0005Wi-9r@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44866 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752597AbZGIEx5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldr-0006EI-K6
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:55 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add crypto_shash_ctx_aligned

This patch adds crypto_shash_ctx_aligned which will be needed
by hmac after its conversion to shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/hash.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index fa5c9fb..f104114 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -123,5 +123,10 @@ static inline struct crypto_shash *crypto_spawn_shash(
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
+static inline void *crypto_shash_ctx_aligned(struct crypto_shash *tfm)
+{
+	return crypto_tfm_ctx_aligned(&tfm->base);
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
