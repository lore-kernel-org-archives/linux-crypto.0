From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 19/35] crypto: ahash - Add crypto_ahash_set_reqsize
Date: Wed, 15 Jul 2009 15:16:12 +0800
Message-ID: <E1MQyiq-00050O-W3@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53638 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbZGOHQP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyir-0004sT-E7
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:13 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: ahash - Add crypto_ahash_set_reqsize

This patch adds the helper crypto_ahash_set_reqsize so that
implementations do not directly access the crypto_ahash structure.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/hash.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 6e28349..5e45818 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -77,6 +77,12 @@ static inline struct ahash_alg *crypto_ahash_alg(
 	return &crypto_ahash_tfm(tfm)->__crt_alg->cra_ahash;
 }
 
+static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
+					    unsigned int reqsize)
+{
+	crypto_ahash_crt(tfm)->reqsize = reqsize;
+}
+
 static inline int ahash_enqueue_request(struct crypto_queue *queue,
 					     struct ahash_request *request)
 {
