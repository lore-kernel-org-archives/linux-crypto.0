From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 10/11] crypto: algif_rng - Remove obsolete const-removal cast
Date: Tue, 21 Apr 2015 10:46:47 +0800
Message-ID: <E1YkOD1-0007M1-Up@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47662 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbDUCqu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that crypto_rng_reset takes a const argument, we no longer
need to cast away the const qualifier.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 8109aaa..150c2b6 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -164,7 +164,7 @@ static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
 	 * Check whether seedlen is of sufficient size is done in RNG
 	 * implementations.
 	 */
-	return crypto_rng_reset(private, (u8 *)seed, seedlen);
+	return crypto_rng_reset(private, seed, seedlen);
 }
 
 static const struct af_alg_type algif_type_rng = {
