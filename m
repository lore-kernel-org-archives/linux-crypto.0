From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/16] crypto: shash - Add __crypto_shash_cast
Date: Thu, 09 Jul 2009 12:53:56 +0800
Message-ID: <E1MOlds-0005Wr-CB@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44867 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753586AbZGIEx6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOlds-0006EV-L0
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add __crypto_shash_cast

This patch adds __crypto_shash_cast which turns a crypto_tfm
into crypto_shash.  It's analogous to the other __crypto_*_cast
functions.

It hasn't been needed until now since no existing shash algorithms
have had an init function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/hash.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index f104114..3af34ca 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -128,5 +128,10 @@ static inline void *crypto_shash_ctx_aligned(struct crypto_shash *tfm)
 	return crypto_tfm_ctx_aligned(&tfm->base);
 }
 
+static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_shash *)tfm;
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
