From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] crypto: drbg - Add stdrng alias and increase priority
Date: Wed, 03 Jun 2015 14:49:28 +0800
Message-ID: <E1Z02US-0001Gy-Hd@gondolin.me.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35865 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbbFCGtb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:49:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the stdrng module alias and increases the priority
to ensure that it is loaded in preference to other RNGs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/drbg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9284348..04836b4 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1876,7 +1876,7 @@ static inline void __init drbg_fill_array(struct rng_alg *alg,
 					  const struct drbg_core *core, int pr)
 {
 	int pos = 0;
-	static int priority = 100;
+	static int priority = 200;
 
 	memcpy(alg->base.cra_name, "stdrng", 6);
 	if (pr) {
@@ -1965,3 +1965,4 @@ MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) "
 		   CRYPTO_DRBG_HASH_STRING
 		   CRYPTO_DRBG_HMAC_STRING
 		   CRYPTO_DRBG_CTR_STRING);
+MODULE_ALIAS_CRYPTO("stdrng");
