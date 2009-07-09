From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/16] crypto: shash - Add shash_instance_ctx
Date: Thu, 09 Jul 2009 12:53:59 +0800
Message-ID: <E1MOldv-0005XI-JX@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44871 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757897AbZGIEyB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:54:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldv-0006Er-SS
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Add shash_instance_ctx

This patch adds the helper shash_instance_ctx which is the shash
analogue of crypto_instance_ctx.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/hash.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 3af34ca..069b93e 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -110,6 +110,11 @@ static inline struct shash_instance *shash_instance(
 			    struct shash_instance, alg);
 }
 
+static inline void *shash_instance_ctx(struct shash_instance *inst)
+{
+	return crypto_instance_ctx(shash_crypto_instance(inst));
+}
+
 static inline struct shash_instance *shash_alloc_instance(
 	const char *name, struct crypto_alg *alg)
 {
